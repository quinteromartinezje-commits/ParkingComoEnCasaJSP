package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import modelo.Perfil;
import util.ConexionBD;

// Consultas de la pantalla Perfil.
public class PerfilDAO {

    private String error = "";

    public String getError() {
        return error;
    }

    public Perfil buscar(int idUsuario) {
        String sql = "SELECT u.id, u.nombre_completo, u.documento, c.correo, c.rol, "
                + "DATE_FORMAT(u.fecha_registro, '%d/%m/%Y') AS registro, "
                + "DATE_FORMAT(c.ultimo_acceso, '%d/%m/%Y - %H:%i') AS acceso "
                + "FROM usuario u JOIN credenciales_acceso c ON c.id_usuario = u.id WHERE u.id = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return null;
            }
            Perfil p = new Perfil();
            p.id = rs.getInt("id");
            p.nombre = rs.getString("nombre_completo");
            p.documento = rs.getString("documento");
            p.correo = rs.getString("correo");
            p.rol = rs.getString("rol");
            p.fechaRegistro = rs.getString("registro");
            p.ultimoAcceso = rs.getString("acceso");
            p.vehiculosRegistrados = contar(conn, "SELECT COUNT(*) FROM registros_parqueo WHERE id_usuario = ?", idUsuario);
            p.accionesRealizadas = contar(conn, "SELECT COUNT(*) FROM auditoria WHERE id_usuario = ?", idUsuario);
            p.diasTrabajados = contar(conn, "SELECT COUNT(DISTINCT DATE(fecha_hora_ingreso)) FROM registros_parqueo WHERE id_usuario = ?", idUsuario);
            return p;
        } catch (Exception e) {
            System.out.println("Error al leer el perfil: " + e.getMessage());
            return null;
        }
    }

    private int contar(Connection conn, String sql, int idUsuario) throws Exception {
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        return rs.next() ? rs.getInt(1) : 0;
    }

    // Cambia nombre, correo y documento. Devuelve false si el correo o el documento ya los usa otra persona.
    public boolean actualizar(int idUsuario, String nombre, String correo, String documento) {
        UsuarioAdminDAO otros = new UsuarioAdminDAO();
        if (otros.existeCorreo(correo, idUsuario)) {
            error = "Ese correo ya lo usa otra persona.";
            return false;
        }
        if (otros.existeDocumento(documento, idUsuario)) {
            error = "Ese documento ya está registrado.";
            return false;
        }
        try (Connection conn = ConexionBD.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE usuario SET nombre_completo = ?, documento = ? WHERE id = ?");
            ps.setString(1, nombre);
            ps.setString(2, documento);
            ps.setInt(3, idUsuario);
            ps.executeUpdate();

            ps = conn.prepareStatement("UPDATE credenciales_acceso SET nombre = ?, correo = ? WHERE id_usuario = ?");
            ps.setString(1, nombre);
            ps.setString(2, correo);
            ps.setInt(3, idUsuario);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al actualizar el perfil: " + e.getMessage());
            error = "No se pudo guardar el perfil.";
            return false;
        }
    }

    // Cambia la contraseña si la actual está bien
    public boolean cambiarClave(int idUsuario, String actual, String nueva) {
        try (Connection conn = ConexionBD.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM credenciales_acceso WHERE id_usuario = ? AND clave = ?");
            ps.setInt(1, idUsuario);
            ps.setString(2, actual);
            ResultSet rs = ps.executeQuery();
            if (!rs.next() || rs.getInt(1) == 0) {
                error = "La contraseña actual no es correcta.";
                return false;
            }
            ps = conn.prepareStatement("UPDATE credenciales_acceso SET clave = ? WHERE id_usuario = ?");
            ps.setString(1, nueva);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al cambiar la clave: " + e.getMessage());
            error = "No se pudo cambiar la contraseña.";
            return false;
        }
    }
}

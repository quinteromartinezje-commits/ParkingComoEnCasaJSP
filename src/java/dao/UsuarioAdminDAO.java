package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.UsuarioFila;
import util.ConexionBD;

// Administración de usuarios. Cada persona está en las tablas usuario y credenciales_acceso.
public class UsuarioAdminDAO {

    private String error = "";

    public String getError() {
        return error;
    }

    private static final String SELECT =
            "SELECT u.id, u.nombre_completo, u.documento, c.correo, c.rol, c.cuenta_activa "
            + "FROM usuario u JOIN credenciales_acceso c ON c.id_usuario = u.id ";

    private UsuarioFila fila(ResultSet rs) throws Exception {
        UsuarioFila f = new UsuarioFila();
        f.id = rs.getInt("id");
        f.nombre = rs.getString("nombre_completo");
        f.documento = rs.getString("documento");
        f.correo = rs.getString("correo");
        f.rol = rs.getString("rol");
        f.activo = rs.getInt("cuenta_activa") == 1;
        return f;
    }

    public List<UsuarioFila> listar() {
        List<UsuarioFila> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT + "ORDER BY u.id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(fila(rs));
            }
        } catch (Exception e) {
            System.out.println("Error al leer los usuarios: " + e.getMessage());
        }
        return lista;
    }

    public UsuarioFila buscar(int id) {
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT + "WHERE u.id = ?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return fila(rs);
            }
        } catch (Exception e) {
            System.out.println("Error al buscar el usuario: " + e.getMessage());
        }
        return null;
    }

    // ¿Ya hay otro usuario con este correo? (excluirId = el que estamos editando, 0 si es nuevo)
    public boolean existeCorreo(String correo, int excluirId) {
        return existe("SELECT COUNT(*) FROM credenciales_acceso WHERE correo = ? AND id_usuario <> ?", correo, excluirId);
    }

    public boolean existeDocumento(String documento, int excluirId) {
        return existe("SELECT COUNT(*) FROM usuario WHERE documento = ? AND id <> ?", documento, excluirId);
    }

    private boolean existe(String sql, String dato, int excluirId) {
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dato);
            ps.setInt(2, excluirId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            System.out.println("Error al revisar duplicados: " + e.getMessage());
            return false;
        }
    }

    // Busca el rol en la tabla `rol`; si no existe, lo crea. Devuelve su id.
    private int idRol(Connection conn, String nombreRol) throws Exception {
        PreparedStatement ps = conn.prepareStatement("SELECT id FROM rol WHERE nombre = ?");
        ps.setString(1, nombreRol);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
        ps = conn.prepareStatement("INSERT INTO rol (nombre) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, nombreRol);
        ps.executeUpdate();
        rs = ps.getGeneratedKeys();
        rs.next();
        return rs.getInt(1);
    }

    // Crear un usuario nuevo
    public boolean crear(String nombre, String documento, String correo, String clave, String rol, boolean activo) {
        try (Connection conn = ConexionBD.getConnection()) {

            int idRol = idRol(conn, rol);

            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO usuario (id_rol, nombre_completo, documento, fecha_registro) VALUES (?, ?, ?, NOW())",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, idRol);
            ps.setString(2, nombre);
            ps.setString(3, documento);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            keys.next();
            int idUsuario = keys.getInt(1);

            ps = conn.prepareStatement(
                    "INSERT INTO credenciales_acceso (id_usuario, correo, clave, cuenta_activa, nombre, rol) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setInt(1, idUsuario);
            ps.setString(2, correo);
            ps.setString(3, clave);
            ps.setInt(4, activo ? 1 : 0);
            ps.setString(5, nombre);
            ps.setString(6, rol.toLowerCase());
            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            System.out.println("Error al crear el usuario: " + e.getMessage());
            error = "No se pudo guardar el usuario. Revisa la consola.";
            return false;
        }
    }

    // Actualizar un usuario (si la clave viene vacía, se deja la que tenía)
    public boolean actualizar(int id, String nombre, String documento, String correo, String clave, String rol, boolean activo) {
        try (Connection conn = ConexionBD.getConnection()) {

            int idRol = idRol(conn, rol);

            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE usuario SET id_rol = ?, nombre_completo = ?, documento = ? WHERE id = ?");
            ps.setInt(1, idRol);
            ps.setString(2, nombre);
            ps.setString(3, documento);
            ps.setInt(4, id);
            ps.executeUpdate();

            ps = conn.prepareStatement(
                    "UPDATE credenciales_acceso SET correo = ?, nombre = ?, rol = ?, cuenta_activa = ? WHERE id_usuario = ?");
            ps.setString(1, correo);
            ps.setString(2, nombre);
            ps.setString(3, rol.toLowerCase());
            ps.setInt(4, activo ? 1 : 0);
            ps.setInt(5, id);
            ps.executeUpdate();

            if (!clave.isEmpty()) {
                ps = conn.prepareStatement("UPDATE credenciales_acceso SET clave = ? WHERE id_usuario = ?");
                ps.setString(1, clave);
                ps.setInt(2, id);
                ps.executeUpdate();
            }
            return true;

        } catch (Exception e) {
            System.out.println("Error al actualizar el usuario: " + e.getMessage());
            error = "No se pudo actualizar el usuario. Revisa la consola.";
            return false;
        }
    }

    // Eliminar. Si la persona ya tiene registros (ingresos, auditoría, incidentes, cajas) no se borra,
    // porque se perdería el historial: solo se desactiva la cuenta.
    // Devuelve "eliminado", "desactivado" o "error".
    public String eliminar(int id) {
        try (Connection conn = ConexionBD.getConnection()) {

            if (tieneRegistros(conn, id)) {
                PreparedStatement ps = conn.prepareStatement("UPDATE credenciales_acceso SET cuenta_activa = 0 WHERE id_usuario = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                return "desactivado";
            }

            PreparedStatement ps = conn.prepareStatement("DELETE FROM credenciales_acceso WHERE id_usuario = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            ps = conn.prepareStatement("DELETE FROM usuario WHERE id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
            return "eliminado";

        } catch (Exception e) {
            System.out.println("Error al eliminar el usuario: " + e.getMessage());
            error = "No se pudo eliminar el usuario.";
            return "error";
        }
    }

    // ¿Esta persona ya hizo cosas en el sistema?
    private boolean tieneRegistros(Connection conn, int id) throws Exception {
        String[] tablas = {"registros_parqueo", "auditoria", "incidentes", "cajas"};
        for (String tabla : tablas) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM " + tabla + " WHERE id_usuario = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        }
        return false;
    }
}

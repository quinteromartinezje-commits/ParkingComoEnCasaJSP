package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;
import util.ConexionBD;

// Login: revisa en credenciales_acceso que el correo y la clave existan y la cuenta esté activa.
public class UsuarioDAO {

    public Usuario validarUsuario(String correo, String password) {
        Usuario usuario = null;
        String sql = "SELECT * FROM credenciales_acceso WHERE correo = ? AND clave = ? AND cuenta_activa = 1";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, correo);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol(rs.getString("rol"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error EN LA BASE DE DATOS: " + e.getMessage());
        }
        return usuario;
    }

    // Guarda la fecha y hora del último inicio de sesión (se ve en el Perfil)
    public void registrarAcceso(int idUsuario) {
        String sql = "UPDATE credenciales_acceso SET ultimo_acceso = NOW() WHERE id_usuario = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("No se pudo guardar el último acceso: " + e.getMessage());
        }
    }
}

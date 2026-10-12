package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;
import util.ConexionBD;

public class UsuarioDAO {

    public Usuario validarUsuario(String correo, String password) {
        Usuario usuario = null;
        String sql = "SELECT * FROM credenciales_acceso WHERE correo = ? AND clave = ?";
        
        System.out.println(">>> INTENTANDO BUSCAR EN LA BD...");
        System.out.println(">>> Correo buscado: '" + correo + "'");
        System.out.println(">>> Clave buscada: '" + password + "'");
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, correo);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                System.out.println(">>> ¡ÉXITO! Usuario encontrado en la base de datos.");
                usuario = new Usuario();
                usuario.setId(rs.getInt("id")); 
                usuario.setNombre(rs.getString("nombre"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol(rs.getString("rol"));
            } else {
                System.out.println(">>> FALLO: La consulta no devolvió ningún resultado. (Datos no coinciden)");
            }
        } catch (SQLException e) {
             throw new RuntimeException("ERROR EN LA BASE DE DATOS: " + e.getMessage());
        }
        return usuario;
    }
}
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    
    // Configuración de la conexión a tu base de datos
       private static final String URL = "jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "jess"; 
    private static final String PASSWORD = "1234";
    
    public static Connection getConnection() throws SQLException {
        try {
     
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
           
            throw new SQLException("Error: No se encontró el driver de MySQL.", e);
        }
    }
}
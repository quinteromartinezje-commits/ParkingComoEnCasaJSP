package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.Cupo;
import util.ConexionBD;

// Consultas de la pantalla Cupos. Los cupos A son de carros y los M de motos.
public class CupoDAO {

    // Cupos de una zona ("A", "M" o "" para todas), con búsqueda opcional por código
    public List<Cupo> listar(String zona, String buscar) {
        List<Cupo> lista = new ArrayList<>();
        String sql = "SELECT codigo_espacio, estado_actual FROM espacio_parqueo WHERE codigo_espacio LIKE ? AND codigo_espacio LIKE ? ORDER BY id";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, zona + "%");
            ps.setString(2, "%" + buscar + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Cupo(rs.getString(1), rs.getString(2)));
            }
        } catch (Exception e) {
            System.out.println("Error al leer los cupos: " + e.getMessage());
        }
        return lista;
    }

    // Cuántos cupos hay en un estado (disponible, ocupado o reservado)
    public int contar(String estado) {
        String sql = "SELECT COUNT(*) FROM espacio_parqueo WHERE estado_actual = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error al contar los cupos: " + e.getMessage());
        }
        return 0;
    }
}

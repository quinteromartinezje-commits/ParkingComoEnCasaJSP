package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.Incidente;
import util.ConexionBD;

// Incidentes. Necesita las columnas placa, tipo y prioridad (database/actualizacion_java.sql).
public class IncidenteDAO {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Incidente> recientes() {
        List<Incidente> lista = new ArrayList<>();
        String sql = "SELECT i.placa, i.ubicacion, i.descripcion, i.tipo, i.prioridad, u.nombre_completo, "
                + "TIMESTAMPDIFF(MINUTE, i.fecha_hora, NOW()) AS minutos "
                + "FROM incidentes i JOIN usuario u ON u.id = i.id_usuario "
                + "ORDER BY i.fecha_hora DESC, i.id DESC LIMIT 10";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Incidente i = new Incidente();
                String placa = rs.getString("placa");
                String ubicacion = rs.getString("ubicacion");
                String tipo = rs.getString("tipo");
                // El título es la placa; si no hay placa, el lugar; y si tampoco, el tipo
                if (placa != null && !placa.isEmpty()) {
                    i.titulo = placa;
                } else if (ubicacion != null && !ubicacion.isEmpty()) {
                    i.titulo = ubicacion;
                } else {
                    i.titulo = tipo != null ? tipo : "Incidente";
                }
                i.descripcion = rs.getString("descripcion");
                i.tipo = tipo != null ? tipo : "Novedad";
                i.prioridad = rs.getString("prioridad") != null ? rs.getString("prioridad") : "Media";
                i.reportadoPor = rs.getString("nombre_completo");
                i.cuando = hace(rs.getLong("minutos"));
                lista.add(i);
            }
        } catch (Exception e) {
            System.out.println("Error al leer los incidentes: " + e.getMessage()
                    + " (¿ya ejecutaste database/actualizacion_java.sql?)");
        }
        return lista;
    }

    public boolean guardar(int idUsuario, String placa, String tipo, String descripcion, String prioridad) {
        String sql = "INSERT INTO incidentes (id_usuario, descripcion, ubicacion, placa, tipo, prioridad, fecha_hora) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, descripcion);
            ps.setString(3, placa.isEmpty() ? "Parqueadero" : placa);   // "ubicacion" no acepta vacío
            ps.setString(4, placa.isEmpty() ? null : placa);
            ps.setString(5, tipo);
            ps.setString(6, prioridad);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al guardar el incidente: " + e.getMessage());
            error = "No se pudo guardar. ¿Ejecutaste database/actualizacion_java.sql?";
            return false;
        }
    }

    private String hace(long minutos) {
        if (minutos < 1) {
            return "Hace instantes";
        } else if (minutos < 60) {
            return "Hace " + minutos + " min";
        } else if (minutos < 1440) {
            return "Hace " + (minutos / 60) + " h";
        } else {
            return "Hace " + (minutos / 1440) + " d";
        }
    }
}

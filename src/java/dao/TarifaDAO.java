package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.Tarifa;
import util.ConexionBD;

// Tarifas por tipo de vehículo (modalidades Hora, Fraccion y Recargo).
public class TarifaDAO {

    private String error = "";

    public String getError() {
        return error;
    }

    // Tarifas vigentes: una fila por tipo de vehículo
    public List<Tarifa> listar() {
        List<Tarifa> lista = new ArrayList<>();
        String sql = "SELECT t.id, t.nombre_tipo, "
                + "MAX(CASE WHEN f.modalidad = 'Hora' THEN f.valor_unidad END) AS hora, "
                + "MAX(CASE WHEN f.modalidad = 'Fraccion' THEN f.valor_unidad END) AS fraccion, "
                + "MAX(CASE WHEN f.modalidad = 'Recargo' THEN f.valor_unidad END) AS recargo, "
                + "MIN(f.estado) AS estado "
                + "FROM tipo_vehiculo t JOIN tarifas f ON f.id_tipo_vehiculo = t.id AND f.tarifa_vigente = 1 "
                + "GROUP BY t.id, t.nombre_tipo ORDER BY t.id";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Tarifa t = new Tarifa();
                t.idTipo = rs.getInt("id");
                t.tipo = rs.getString("nombre_tipo");
                t.hora = rs.getDouble("hora");
                t.fraccion = rs.getDouble("fraccion");
                t.recargo = rs.getDouble("recargo");
                t.activo = rs.getInt("estado") == 1;
                lista.add(t);
            }
        } catch (Exception e) {
            System.out.println("Error al leer las tarifas: " + e.getMessage());
        }
        return lista;
    }

    // Una sola tarifa vigente (para llenar el formulario de editar). Devuelve null si no hay.
    public Tarifa buscar(int idTipo) {
        for (Tarifa t : listar()) {
            if (t.idTipo == idTipo) {
                return t;
            }
        }
        return null;
    }

    // Tipos de vehículo para el desplegable: cada elemento es {id, nombre}
    public List<String[]> tiposVehiculo() {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT id, nombre_tipo FROM tipo_vehiculo ORDER BY id";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new String[]{rs.getString(1), rs.getString(2)});
            }
        } catch (Exception e) {
            System.out.println("Error al leer los tipos de vehículo: " + e.getMessage());
        }
        return lista;
    }

    // Nombre de un tipo (para el historial de auditoría)
    public String nombreTipo(int idTipo) {
        for (String[] t : tiposVehiculo()) {
            if (t[0].equals(String.valueOf(idTipo))) {
                return t[1];
            }
        }
        return "";
    }

    // Guardar (sirve para crear y para actualizar):
    // apaga las tarifas vigentes de ese tipo y guarda las nuevas
    public boolean guardar(int idTipo, double hora, double fraccion, double recargo, boolean activo) {
        try (Connection conn = ConexionBD.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE tarifas SET tarifa_vigente = 0 WHERE id_tipo_vehiculo = ?");
            ps.setInt(1, idTipo);
            ps.executeUpdate();

            insertar(conn, idTipo, "Hora", hora, activo);
            insertar(conn, idTipo, "Fraccion", fraccion, activo);
            insertar(conn, idTipo, "Recargo", recargo, activo);
            return true;

        } catch (Exception e) {
            System.out.println("Error al guardar la tarifa: " + e.getMessage());
            error = "No se pudo guardar. Se mantiene la tarifa anterior.";
            return false;
        }
    }

    private void insertar(Connection conn, int idTipo, String modalidad, double valor, boolean activo) throws Exception {
        PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO tarifas (id_tipo_vehiculo, modalidad, valor_unidad, tarifa_vigente, estado) VALUES (?, ?, ?, 1, ?)");
        ps.setInt(1, idTipo);
        ps.setString(2, modalidad);
        ps.setDouble(3, valor);
        ps.setInt(4, activo ? 1 : 0);
        ps.executeUpdate();
    }

    // "Eliminar": la tarifa deja de estar vigente (no se borra para no perder el historial)
    public boolean eliminar(int idTipo) {
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE tarifas SET tarifa_vigente = 0 WHERE id_tipo_vehiculo = ?")) {
            ps.setInt(1, idTipo);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al eliminar la tarifa: " + e.getMessage());
            error = "No se pudo eliminar la tarifa.";
            return false;
        }
    }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Ingreso;
import util.ConexionBD;

public class IngresoDAO {

    // 1. Obtener ID del tipo de vehículo
    public int getIdTipoVehiculo(String nombreTipo) {
        int id = 0;
        String sql = "SELECT id FROM tipo_vehiculo WHERE LOWER(nombre_tipo) = LOWER(?)";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombreTipo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("id");
                    System.out.println("✅ Tipo de vehículo encontrado. ID: " + id);
                } else {
                    System.out.println("⚠️ Tipo de vehículo NO encontrado: " + nombreTipo);
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Error en getIdTipoVehiculo: " + e.getMessage());
        }
        return id;
    }

    // 2. Verificar si la placa ya existe en la tabla vehiculos
    public boolean existeVehiculo(String placa) {
        String sql = "SELECT COUNT(*) FROM vehiculos WHERE placa = ?";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    boolean existe = rs.getInt(1) > 0;
                    System.out.println("✅ Verificación de placa '" + placa + "': " + (existe ? "Ya existe" : "No existe, se creará"));
                    return existe;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Registrar vehículo nuevo (ahora devuelve true/false para que el servlet sepa si falló)
    public boolean registrarVehiculo(String placa, int idTipo) {
        String sql = "INSERT INTO vehiculos (placa, id_tipo_vehiculo, marca, modelo, color) VALUES (?, ?, 'DESCONOCIDA', 'DESCONOCIDA', 'DESCONOCIDA')";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            ps.setInt(2, idTipo);
            ps.executeUpdate();
            System.out.println("✅ Vehículo '" + placa + "' registrado en base de datos.");
            return true;
        } catch (Exception e) {
            System.out.println("❌ ERROR al registrar vehículo: " + e.getMessage());
            return false;
        }
    }

    // 4a. Buscar el id del cupo SIN modificarlo
    public int getIdEspacio(String codigoEspacio) {
        String sql = "SELECT id FROM espacio_parqueo WHERE LOWER(codigo_espacio) = LOWER(?)";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, codigoEspacio);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    System.out.println("✅ Cupo '" + codigoEspacio + "' encontrado. ID: " + id);
                    return id;
                }
                System.out.println("❌ ERROR: El cupo '" + codigoEspacio + "' NO existe en la tabla espacio_parqueo.");
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR en getIdEspacio: " + e.getMessage());
        }
        return 0;
    }

    // 4b. Marcar el cupo como ocupado (se llama SOLO después de guardar el registro)
    public void marcarOcupado(int idEspacio) {
        String sql = "UPDATE espacio_parqueo SET estado_actual = 'ocupado' WHERE id = ?";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEspacio);
            ps.executeUpdate();
            System.out.println("✅ Cupo actualizado a 'ocupado'.");
        } catch (Exception e) {
            System.out.println("❌ ERROR al marcar ocupado: " + e.getMessage());
        }
    }

    // 4c. Estado actual de un cupo (disponible, ocupado, reservado)
    public String getEstadoEspacio(int idEspacio) {
        String sql = "SELECT estado_actual FROM espacio_parqueo WHERE id = ?";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEspacio);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR en getEstadoEspacio: " + e.getMessage());
        }
        return "";
    }

    // 4d. Códigos de los cupos libres (para llenar la lista desplegable del formulario)
    public List<String> getCuposDisponibles() {
        List<String> lista = new ArrayList<>();
        String sql = "SELECT codigo_espacio FROM espacio_parqueo WHERE LOWER(estado_actual) = 'disponible' ORDER BY id";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR en getCuposDisponibles: " + e.getMessage());
        }
        return lista;
    }

    // 5. Verificar si ya está dentro del parqueadero
    public boolean existeVehiculoEnParqueo(String placa) {
        String sql = "SELECT COUNT(*) FROM registros_parqueo WHERE id_placa = ? AND fecha_hora_salida IS NULL";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    boolean dentro = rs.getInt(1) > 0;
                    System.out.println("✅ Verificación de ingreso: " + (dentro ? "Ya está dentro" : "Puede ingresar"));
                    return dentro;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Guardar el registro principal.
    //    Devuelve el id generado del registro (0 si falló). El ticket se arma como
    //    "TKT-" + id, igual que lo muestra la tabla de últimos ingresos.
    public int guardarRegistro(String placa, int idUsuario, int idEspacio, String fechaHora) {
        String sql = "INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, placa);
            ps.setInt(2, idUsuario);
            ps.setInt(3, idEspacio);
            ps.setString(4, fechaHora);

            int filas = ps.executeUpdate();
            if (filas > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int idRegistro = keys.getInt(1);
                        System.out.println("✅ Registro guardado en 'registros_parqueo'. ID: " + idRegistro);
                        return idRegistro;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("❌❌ ERROR REAL DE LA BASE DE DATOS: " + e.getMessage());
        }
        return 0;
    }

    // 7. Obtener los últimos ingresos para la tabla
    public List<Ingreso> getUltimosIngresos() {
        List<Ingreso> lista = new ArrayList<>();
        String sql = "SELECT r.id_placa as placa, t.nombre_tipo as tipo, e.codigo_espacio as cupo, " +
                     "DATE_FORMAT(r.fecha_hora_ingreso, '%H:%i') as hora, CONCAT('TKT-', r.id) as ticket " +
                     "FROM registros_parqueo r " +
                     "LEFT JOIN vehiculos v ON r.id_placa = v.placa " +
                     "LEFT JOIN tipo_vehiculo t ON v.id_tipo_vehiculo = t.id " +
                     "LEFT JOIN espacio_parqueo e ON r.id_espacio_parqueo = e.id " +
                     "ORDER BY r.id DESC LIMIT 5";

        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Ingreso ing = new Ingreso();
                ing.setPlaca(rs.getString("placa"));
                ing.setTipo(rs.getString("tipo") != null ? rs.getString("tipo") : "Desconocido");
                ing.setCupo(rs.getString("cupo") != null ? rs.getString("cupo") : "N/A");
                ing.setFechaHora(rs.getString("hora"));
                ing.setTicket(rs.getString("ticket"));
                lista.add(ing);
            }
            System.out.println("📊 Se obtuvieron " + lista.size() + " registros para la tabla.");
        } catch (Exception e) {
            System.out.println("❌ ERROR en la consulta de últimos ingresos: " + e.getMessage());
        }
        return lista;
    }
}

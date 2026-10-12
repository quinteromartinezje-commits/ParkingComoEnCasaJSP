package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                id = rs.getInt("id");
                System.out.println("✅ Tipo de vehículo encontrado. ID: " + id);
            } else {
                System.out.println("⚠️ Tipo de vehículo NO encontrado: " + nombreTipo);
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
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean existe = rs.getInt(1) > 0;
                System.out.println("✅ Verificación de placa '" + placa + "': " + (existe ? "Ya existe" : "No existe, se creará"));
                return existe;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 3. Registrar vehículo nuevo
    public void registrarVehiculo(String placa, int idTipo) {
        String sql = "INSERT INTO vehiculos (placa, id_tipo_vehiculo, marca, modelo, color) VALUES (?, ?, 'DESCONOCIDA', 'DESCONOCIDA', 'DESCONOCIDA')";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            ps.setInt(2, idTipo);
            ps.executeUpdate();
            System.out.println("✅ Vehículo '" + placa + "' registrado en base de datos.");
        } catch (Exception e) { 
            System.out.println("❌ ERROR al registrar vehículo: " + e.getMessage());
        }
    }

    // 4. Ocupar espacio (Cupo)
    public int ocuparEspacio(String codigoEspacio) {
        int idEspacio = 0;
        String sqlSelect = "SELECT id FROM espacio_parqueo WHERE LOWER(codigo_espacio) = LOWER(?)";
        String sqlUpdate = "UPDATE espacio_parqueo SET estado_actual = 'ocupado' WHERE id = ?";
        
        try (Connection conn = ConexionBD.getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement(sqlSelect);
            ps1.setString(1, codigoEspacio);
            ResultSet rs = ps1.executeQuery();
            if (rs.next()) {
                idEspacio = rs.getInt("id");
                System.out.println("✅ Cupo '" + codigoEspacio + "' encontrado. ID: " + idEspacio);
            } else {
                System.out.println("❌ ERROR: El cupo '" + codigoEspacio + "' NO existe en la tabla espacio_parqueo.");
            }

            if (idEspacio > 0) {
                PreparedStatement ps2 = conn.prepareStatement(sqlUpdate);
                ps2.setInt(1, idEspacio);
                ps2.executeUpdate();
                System.out.println("✅ Cupo actualizado a 'ocupado'.");
            }
        } catch (Exception e) { 
            System.out.println("❌ ERROR al ocupar espacio: " + e.getMessage());
        }
        return idEspacio;
    }

    // 5. Verificar si ya está dentro del parqueadero
    public boolean existeVehiculoEnParqueo(String placa) {
        String sql = "SELECT COUNT(*) FROM registros_parqueo WHERE id_placa = ? AND fecha_hora_salida IS NULL";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean dentro = rs.getInt(1) > 0;
                System.out.println("✅ Verificación de ingreso: " + (dentro ? "Ya está dentro" : "Puede ingresar"));
                return dentro;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 6. Guardar el registro principal
    public boolean guardarRegistro(String placa, int idUsuario, int idEspacio, String fechaHora, String ticket) {
        String sql = "INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            ps.setInt(2, idUsuario);
            ps.setInt(3, idEspacio);
            ps.setString(4, fechaHora);
            
            int filas = ps.executeUpdate();
            System.out.println("✅ Registro guardado en 'registros_parqueo'. Filas afectadas: " + filas);
            return filas > 0;
            
        } catch (Exception e) { 
            // ¡MENSAJE CLAVE!
            System.out.println("❌❌ ERROR REAL DE LA BASE DE DATOS: " + e.getMessage());
            return false; 
        }
    }

    // 7. Obtener los últimos ingresos para la tabla (Usando LEFT JOIN para evitar fallos)
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
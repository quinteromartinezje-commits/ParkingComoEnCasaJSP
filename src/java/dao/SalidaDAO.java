package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import modelo.Salida;
import util.ConexionBD;

// Salida de vehículos: buscar() calcula el cobro y registrarSalida() guarda el pago.
public class SalidaDAO {

    // Si algo sale mal, aquí queda el mensaje para mostrarlo en pantalla
    private String error = "";

    public String getError() {
        return error;
    }

    // 1) BUSCAR: por placa o por ticket (ej: ABC-123 o TKT-12)
    public Salida buscar(String texto) {
        String placa = texto.trim().toUpperCase();

        // Si escribieron "TKT-12" nos quedamos con el 12
        int idRegistro = -1;
        try {
            idRegistro = Integer.parseInt(placa.replace("TKT-", ""));
        } catch (NumberFormatException e) {
            // no era un número, entonces buscamos solo por placa
        }

        // Datos del vehículo que sigue dentro (sin hora de salida)
        String sql = "SELECT r.id, r.id_placa, r.id_espacio_parqueo, "
                + "t.id AS id_tipo, t.nombre_tipo, e.codigo_espacio, "
                + "DATE_FORMAT(r.fecha_hora_ingreso, '%d/%m/%Y - %H:%i') AS ingreso, "
                + "DATE_FORMAT(NOW(), '%d/%m/%Y - %H:%i') AS salida, "
                + "TIMESTAMPDIFF(MINUTE, r.fecha_hora_ingreso, NOW()) AS minutos "
                + "FROM registros_parqueo r "
                + "JOIN vehiculos v ON v.placa = r.id_placa "
                + "JOIN tipo_vehiculo t ON t.id = v.id_tipo_vehiculo "
                + "LEFT JOIN espacio_parqueo e ON e.id = r.id_espacio_parqueo "
                + "WHERE r.fecha_hora_salida IS NULL AND (r.id_placa = ? OR r.id = ?) "
                + "ORDER BY r.id DESC LIMIT 1";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, placa);
            ps.setInt(2, idRegistro);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                return null;   // no hay ningún vehículo dentro con ese dato
            }

            Salida s = new Salida();
            s.setIdRegistro(rs.getInt("id"));
            s.setPlaca(rs.getString("id_placa"));
            s.setTipo(rs.getString("nombre_tipo"));
            s.setIdEspacio(rs.getInt("id_espacio_parqueo"));
            s.setCupo(rs.getString("codigo_espacio"));
            s.setHoraIngreso(rs.getString("ingreso"));
            s.setHoraSalida(rs.getString("salida"));
            s.setMinutos(rs.getLong("minutos"));
            s.setTarifaHora(buscarTarifa(conn, rs.getInt("id_tipo")));
            s.calcular();
            return s;

        } catch (Exception e) {
            System.out.println("Error al buscar la salida: " + e.getMessage());
            return null;
        }
    }

    // Tarifa por hora vigente para ese tipo de vehículo
    private double buscarTarifa(Connection conn, int idTipo) throws Exception {
        String sql = "SELECT valor_unidad FROM tarifas "
                + "WHERE id_tipo_vehiculo = ? AND tarifa_vigente = 1 AND modalidad = 'Hora' LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, idTipo);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getDouble(1);
        }
        return 0;
    }

    // 2) REGISTRAR LA SALIDA
    //    Devuelve la Salida si todo salió bien, o null si hubo un problema
    //    (en ese caso el mensaje queda en getError()).
    public Salida registrarSalida(int idRegistro, String medioPago) {
        Salida s = buscar("TKT-" + idRegistro);

        if (s == null) {
            error = "Ese vehículo ya no está dentro del parqueadero.";
            return null;
        }
        if (s.getTarifaHora() <= 0) {
            error = "No hay una tarifa para " + s.getTipo()
                    + ". Ejecuta database/actualizacion_dashboard.sql.";
            return null;
        }

        try (Connection conn = ConexionBD.getConnection()) {

            // Buscamos el id del medio de pago (Efectivo, Tarjeta, ...)
            int idMetodo = 0;
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT id FROM metodo_pago WHERE nombre_metodo = ?");
            ps.setString(1, medioPago);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                idMetodo = rs.getInt(1);
            }
            if (idMetodo == 0) {
                error = "El medio de pago '" + medioPago + "' no existe.";
                return null;
            }

            // Paso 1: guardar la hora de salida
            ps = conn.prepareStatement("UPDATE registros_parqueo "
                    + "SET fecha_hora_salida = NOW(), tiempo_permanencia = ? WHERE id = ?");
            ps.setLong(1, s.getMinutos());
            ps.setInt(2, s.getIdRegistro());
            ps.executeUpdate();

            // Paso 2: guardar el pago
            ps = conn.prepareStatement("INSERT INTO comprobantes_pago "
                    + "(id_registro_parqueo, id_metodo_pago, numero_ticket, subtotal, impuestos, total_pagado, fecha_hora_pago) "
                    + "VALUES (?, ?, ?, ?, 0, ?, NOW())");
            ps.setInt(1, s.getIdRegistro());
            ps.setInt(2, idMetodo);
            ps.setString(3, s.getTicket());
            ps.setDouble(4, s.getTotal());
            ps.setDouble(5, s.getTotal());
            ps.executeUpdate();

            // Paso 3: dejar el cupo disponible otra vez
            ps = conn.prepareStatement(
                    "UPDATE espacio_parqueo SET estado_actual = 'disponible' WHERE id = ?");
            ps.setInt(1, s.getIdEspacio());
            ps.executeUpdate();

            return s;

        } catch (Exception e) {
            System.out.println("Error al registrar la salida: " + e.getMessage());
            error = "No se pudo registrar la salida. Revisa la consola.";
            return null;
        }
    }
}

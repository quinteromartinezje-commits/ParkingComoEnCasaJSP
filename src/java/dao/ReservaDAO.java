package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import modelo.Reserva;
import util.ConexionBD;

/**
 * Reservas de cupo (suscripciones mensuales).
 * Al reservar, el cupo queda en estado 'reservado' y el dashboard lo pinta de amarillo.
 */
public class ReservaDAO {

    // Reservas que siguen activas, la más reciente primero
    public List<Reserva> getReservasActivas() {
        List<Reserva> lista = new ArrayList<>();
        String sql =
            "SELECT s.id, c.nombre_completo, c.documento, s.id_placa, e.codigo_espacio, " +
            "       DATE_FORMAT(s.fecha_inicio, '%d/%m/%Y') AS inicio, " +
            "       DATE_FORMAT(s.fecha_fin, '%d/%m/%Y') AS fin, " +
            "       s.valor_mensualidad, s.estado_suscripcion " +
            "FROM suscripciones_mensuales s " +
            "JOIN cliente c ON c.id = s.id_cliente " +
            "LEFT JOIN espacio_parqueo e ON e.id = s.id_espacio_parqueo " +
            "WHERE LOWER(s.estado_suscripcion) = 'activa' " +
            "ORDER BY s.id DESC";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Reserva r = new Reserva();
                r.setId(rs.getInt("id"));
                r.setCliente(rs.getString("nombre_completo"));
                r.setDocumento(rs.getString("documento"));
                r.setPlaca(rs.getString("id_placa"));
                r.setCupo(rs.getString("codigo_espacio") != null ? rs.getString("codigo_espacio") : "Sin cupo");
                r.setFechaInicio(rs.getString("inicio"));
                r.setFechaFin(rs.getString("fin"));
                r.setValor(rs.getDouble("valor_mensualidad"));
                r.setEstado(rs.getString("estado_suscripcion"));
                lista.add(r);
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR en getReservasActivas: " + e.getMessage()
                    + " (¿ya ejecutaste database/actualizacion_dashboard.sql?)");
        }
        return lista;
    }

    // Códigos de los cupos que se pueden reservar
    public List<String> getCuposDisponibles() {
        return listaDeTexto("SELECT codigo_espacio FROM espacio_parqueo " +
                            "WHERE LOWER(estado_actual) = 'disponible' ORDER BY id");
    }

    public List<String> getTiposVehiculo() {
        return listaDeTexto("SELECT nombre_tipo FROM tipo_vehiculo ORDER BY id");
    }

    public List<String> getMetodosPago() {
        return listaDeTexto("SELECT nombre_metodo FROM metodo_pago ORDER BY id");
    }

    private List<String> listaDeTexto(String sql) {
        List<String> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR en ReservaDAO: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Crea una reserva completa en una transacción:
     * cliente + vehículo + suscripción + comprobante de pago + cupo en 'reservado'.
     * Lanza IllegalStateException con un mensaje claro si algo no se puede hacer.
     */
    public int crear(String nombre, String documento, String telefono, String correo,
                     String placa, String tipoVehiculo, String codigoCupo,
                     double valor, String medioPago) {
        try (Connection conn = ConexionBD.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1) El cupo debe estar disponible
                int idCupo = 0;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id FROM espacio_parqueo " +
                        "WHERE LOWER(codigo_espacio) = LOWER(?) AND LOWER(estado_actual) = 'disponible' FOR UPDATE")) {
                    ps.setString(1, codigoCupo);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) idCupo = rs.getInt(1);
                    }
                }
                if (idCupo == 0) {
                    throw new IllegalStateException("El cupo " + codigoCupo + " ya no está disponible.");
                }

                // 2) La placa no puede tener otra reserva activa
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT COUNT(*) FROM suscripciones_mensuales " +
                        "WHERE id_placa = ? AND LOWER(estado_suscripcion) = 'activa'")) {
                    ps.setString(1, placa);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            throw new IllegalStateException("La placa " + placa + " ya tiene una reserva activa.");
                        }
                    }
                }

                // 3) Cliente: se busca por documento y, si no existe, se crea
                int idCliente = buscarId(conn, "SELECT id FROM cliente WHERE documento = ?", documento);
                if (idCliente == 0) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO cliente (nombre_completo, documento, telefono, correo) VALUES (?, ?, ?, ?)",
                            Statement.RETURN_GENERATED_KEYS)) {
                        ps.setString(1, nombre);
                        ps.setString(2, documento);
                        ps.setString(3, telefono.isEmpty() ? null : telefono);
                        ps.setString(4, correo.isEmpty() ? null : correo);
                        ps.executeUpdate();
                        try (ResultSet keys = ps.getGeneratedKeys()) {
                            if (keys.next()) idCliente = keys.getInt(1);
                        }
                    }
                }

                // 4) Vehículo: se crea si todavía no existe
                if (buscarId(conn, "SELECT 1 FROM vehiculos WHERE placa = ?", placa) == 0) {
                    int idTipo = buscarId(conn, "SELECT id FROM tipo_vehiculo WHERE LOWER(nombre_tipo) = LOWER(?)", tipoVehiculo);
                    if (idTipo == 0) {
                        throw new IllegalStateException("El tipo de vehículo '" + tipoVehiculo + "' no existe.");
                    }
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO vehiculos (placa, id_tipo_vehiculo, marca, modelo, color) " +
                            "VALUES (?, ?, 'DESCONOCIDA', 'DESCONOCIDA', 'DESCONOCIDA')")) {
                        ps.setString(1, placa);
                        ps.setInt(2, idTipo);
                        ps.executeUpdate();
                    }
                }

                // 5) Medio de pago
                int idMetodo = buscarId(conn, "SELECT id FROM metodo_pago WHERE LOWER(nombre_metodo) = LOWER(?)", medioPago);
                if (idMetodo == 0) {
                    throw new IllegalStateException("El medio de pago '" + medioPago + "' no existe.");
                }

                // 6) La reserva (suscripción mensual de un mes)
                int idSuscripcion = 0;
                LocalDate inicio = LocalDate.now();
                LocalDate fin = inicio.plusMonths(1);
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO suscripciones_mensuales " +
                        "(id_cliente, id_placa, fecha_inicio, fecha_fin, valor_mensualidad, estado_suscripcion, id_espacio_parqueo) " +
                        "VALUES (?, ?, ?, ?, ?, 'activa', ?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, idCliente);
                    ps.setString(2, placa);
                    ps.setString(3, inicio.toString());   // formato AAAA-MM-DD
                    ps.setString(4, fin.toString());
                    ps.setDouble(5, valor);
                    ps.setInt(6, idCupo);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) idSuscripcion = keys.getInt(1);
                    }
                }

                // 7) Comprobante del pago de la mensualidad
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO comprobantes_pago " +
                        "(id_registro_parqueo, id_suscripcion, id_metodo_pago, numero_ticket, " +
                        " subtotal, impuestos, total_pagado, fecha_hora_pago) " +
                        "VALUES (NULL, ?, ?, ?, ?, 0, ?, NOW())")) {
                    ps.setInt(1, idSuscripcion);
                    ps.setInt(2, idMetodo);
                    ps.setString(3, "RES-" + idSuscripcion);
                    ps.setDouble(4, valor);
                    ps.setDouble(5, valor);
                    ps.executeUpdate();
                }

                // 8) El cupo pasa a 'reservado'
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE espacio_parqueo SET estado_actual = 'reservado' WHERE id = ?")) {
                    ps.setInt(1, idCupo);
                    ps.executeUpdate();
                }

                conn.commit();
                System.out.println("✅ Reserva creada. ID " + idSuscripcion + ", cupo " + codigoCupo);
                return idSuscripcion;
            } catch (RuntimeException | SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.out.println("❌ ERROR REAL DE LA BASE DE DATOS (reserva): " + e.getMessage());
            throw new IllegalStateException("No se pudo guardar la reserva. Revisa la consola del servidor.");
        }
    }

    // Cancela una reserva y deja el cupo libre otra vez
    public void cancelar(int idSuscripcion) {
        try (Connection conn = ConexionBD.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int idCupo = 0;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id_espacio_parqueo FROM suscripciones_mensuales " +
                        "WHERE id = ? AND LOWER(estado_suscripcion) = 'activa' FOR UPDATE")) {
                    ps.setInt(1, idSuscripcion);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new IllegalStateException("Esa reserva ya no está activa.");
                        }
                        idCupo = rs.getInt(1);
                    }
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE suscripciones_mensuales SET estado_suscripcion = 'cancelada' WHERE id = ?")) {
                    ps.setInt(1, idSuscripcion);
                    ps.executeUpdate();
                }
                if (idCupo > 0) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "UPDATE espacio_parqueo SET estado_actual = 'disponible' " +
                            "WHERE id = ? AND LOWER(estado_actual) = 'reservado'")) {
                        ps.setInt(1, idCupo);
                        ps.executeUpdate();
                    }
                }
                conn.commit();
            } catch (RuntimeException | SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.out.println("❌ ERROR REAL DE LA BASE DE DATOS (cancelar reserva): " + e.getMessage());
            throw new IllegalStateException("No se pudo cancelar la reserva. Revisa la consola del servidor.");
        }
    }

    // Devuelve el primer número de la consulta (0 si no hay resultados)
    private int buscarId(Connection conn, String sql, String valor) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, valor);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}

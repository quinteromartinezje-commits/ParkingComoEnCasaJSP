package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Salida;
import util.ConexionBD;

/**
 * Registro de salidas: busca el vehículo, calcula el cobro,
 * guarda el pago y libera el cupo.
 */
public class SalidaDAO {

    // Busca un vehículo que sigue dentro, por placa o por número de ticket (TKT-12 o 12)
    public Salida buscar(String texto) {
        try (Connection conn = ConexionBD.getConnection()) {
            return consultar(conn, texto.trim().toUpperCase(), idDesdeTexto(texto));
        } catch (Exception e) {
            System.out.println("❌ ERROR en SalidaDAO.buscar: " + e.getMessage());
            return null;
        }
    }

    // Convierte "TKT-12" o "12" en 12. Si no es un número devuelve -1.
    private int idDesdeTexto(String texto) {
        String t = texto.trim().toUpperCase().replace("TKT-", "").replace("#", "");
        try {
            return Integer.parseInt(t);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private Salida consultar(Connection conn, String placa, int idRegistro) throws SQLException {
        String sql =
            "SELECT r.id, r.id_placa, r.id_espacio_parqueo, t.id AS id_tipo, t.nombre_tipo, e.codigo_espacio, " +
            "       DATE_FORMAT(r.fecha_hora_ingreso, '%d/%m/%Y - %H:%i') AS ingreso, " +
            "       DATE_FORMAT(NOW(), '%d/%m/%Y - %H:%i') AS salida, " +
            "       TIMESTAMPDIFF(MINUTE, r.fecha_hora_ingreso, NOW()) AS minutos " +
            "FROM registros_parqueo r " +
            "JOIN vehiculos v ON v.placa = r.id_placa " +
            "JOIN tipo_vehiculo t ON t.id = v.id_tipo_vehiculo " +
            "LEFT JOIN espacio_parqueo e ON e.id = r.id_espacio_parqueo " +
            "WHERE r.fecha_hora_salida IS NULL AND (r.id_placa = ? OR r.id = ?) " +
            "ORDER BY r.id DESC LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            ps.setInt(2, idRegistro);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Salida s = new Salida();
                s.setIdRegistro(rs.getInt("id"));
                s.setPlaca(rs.getString("id_placa"));
                s.setTipo(rs.getString("nombre_tipo"));
                s.setIdEspacio(rs.getInt("id_espacio_parqueo"));
                s.setCupo(rs.getString("codigo_espacio"));
                s.setHoraIngreso(rs.getString("ingreso"));
                s.setHoraSalida(rs.getString("salida"));
                s.setMinutos(Math.max(0, rs.getLong("minutos")));
                s.setTarifaHora(buscarTarifa(conn, rs.getInt("id_tipo")));
                s.calcular();
                return s;
            }
        }
    }

    // Tarifa vigente por hora para un tipo de vehículo (0 si no hay)
    private double buscarTarifa(Connection conn, int idTipo) throws SQLException {
        String sql = "SELECT valor_unidad FROM tarifas " +
                     "WHERE id_tipo_vehiculo = ? AND tarifa_vigente = 1 ORDER BY id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTipo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0;
            }
        }
    }

    /**
     * Registra la salida completa en un solo paso (transacción):
     * 1) cierra el registro, 2) guarda el pago, 3) libera el cupo.
     * Si algo falla, no se guarda nada.
     * Lanza IllegalStateException con un mensaje fácil de leer cuando algo está mal.
     */
    public Salida registrarSalida(int idRegistro, String medioPago) {
        try (Connection conn = ConexionBD.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Salida s = consultar(conn, "", idRegistro);
                if (s == null) {
                    throw new IllegalStateException("Ese vehículo ya no está dentro del parqueadero.");
                }
                if (s.getTarifaHora() <= 0) {
                    throw new IllegalStateException("No hay una tarifa vigente para " + s.getTipo()
                            + ". Ejecuta database/actualizacion_dashboard.sql para cargar las tarifas.");
                }

                int idMetodo = buscarIdMetodo(conn, medioPago);
                if (idMetodo == 0) {
                    throw new IllegalStateException("El medio de pago '" + medioPago
                            + "' no existe en la tabla metodo_pago.");
                }

                // 1) Cerrar el registro de parqueo
                String sqlCerrar = "UPDATE registros_parqueo " +
                        "SET fecha_hora_salida = NOW(), tiempo_permanencia = ? " +
                        "WHERE id = ? AND fecha_hora_salida IS NULL";
                try (PreparedStatement ps = conn.prepareStatement(sqlCerrar)) {
                    ps.setLong(1, s.getMinutos());
                    ps.setInt(2, s.getIdRegistro());
                    if (ps.executeUpdate() == 0) {
                        throw new IllegalStateException("La salida de este vehículo ya fue registrada.");
                    }
                }

                // 2) Guardar el comprobante de pago
                String sqlPago = "INSERT INTO comprobantes_pago " +
                        "(id_registro_parqueo, id_suscripcion, id_metodo_pago, numero_ticket, " +
                        " subtotal, impuestos, total_pagado, fecha_hora_pago) " +
                        "VALUES (?, NULL, ?, ?, ?, 0, ?, NOW())";
                try (PreparedStatement ps = conn.prepareStatement(sqlPago)) {
                    ps.setInt(1, s.getIdRegistro());
                    ps.setInt(2, idMetodo);
                    ps.setString(3, s.getTicket());
                    ps.setDouble(4, s.getTotal());
                    ps.setDouble(5, s.getTotal());
                    ps.executeUpdate();
                }

                // 3) Liberar el cupo (solo si ningún otro vehículo lo sigue usando)
                if (s.getIdEspacio() > 0) {
                    String sqlCupo = "UPDATE espacio_parqueo SET estado_actual = 'disponible' " +
                            "WHERE id = ? AND NOT EXISTS (" +
                            "  SELECT 1 FROM registros_parqueo " +
                            "  WHERE id_espacio_parqueo = ? AND fecha_hora_salida IS NULL)";
                    try (PreparedStatement ps = conn.prepareStatement(sqlCupo)) {
                        ps.setInt(1, s.getIdEspacio());
                        ps.setInt(2, s.getIdEspacio());
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                System.out.println("✅ Salida registrada. Placa " + s.getPlaca() + ", total " + s.getTotal());
                return s;
            } catch (RuntimeException e) {
                conn.rollback();
                throw e;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.out.println("❌ ERROR REAL DE LA BASE DE DATOS (salida): " + e.getMessage());
            throw new IllegalStateException("No se pudo registrar la salida. Revisa la consola del servidor.");
        }
    }

    private int buscarIdMetodo(Connection conn, String nombre) throws SQLException {
        String sql = "SELECT id FROM metodo_pago WHERE LOWER(nombre_metodo) = LOWER(?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}

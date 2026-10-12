package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import modelo.Reserva;
import util.ConexionBD;

// Reservas de cupo (se guardan como suscripciones mensuales).
public class ReservaDAO {

    // Si algo sale mal, aquí queda el mensaje para mostrarlo en pantalla
    private String error = "";

    public String getError() {
        return error;
    }

    // LISTAS PARA LA PANTALLA

    // Reservas que siguen activas
    public List<Reserva> getReservasActivas() {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT s.id, c.nombre_completo, c.documento, s.id_placa, e.codigo_espacio, "
                + "DATE_FORMAT(s.fecha_inicio, '%d/%m/%Y') AS inicio, "
                + "DATE_FORMAT(s.fecha_fin, '%d/%m/%Y') AS fin, "
                + "s.valor_mensualidad, s.estado_suscripcion "
                + "FROM suscripciones_mensuales s "
                + "JOIN cliente c ON c.id = s.id_cliente "
                + "LEFT JOIN espacio_parqueo e ON e.id = s.id_espacio_parqueo "
                + "WHERE s.estado_suscripcion = 'activa' "
                + "ORDER BY s.id DESC";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reserva r = new Reserva();
                r.setId(rs.getInt("id"));
                r.setCliente(rs.getString("nombre_completo"));
                r.setDocumento(rs.getString("documento"));
                r.setPlaca(rs.getString("id_placa"));
                r.setCupo(rs.getString("codigo_espacio"));
                r.setFechaInicio(rs.getString("inicio"));
                r.setFechaFin(rs.getString("fin"));
                r.setValor(rs.getDouble("valor_mensualidad"));
                r.setEstado(rs.getString("estado_suscripcion"));
                lista.add(r);
            }
        } catch (Exception e) {
            System.out.println("Error al leer las reservas: " + e.getMessage()
                    + " (¿ya ejecutaste database/actualizacion_dashboard.sql?)");
        }
        return lista;
    }

    // Cupos que se pueden reservar
    public List<String> getCuposDisponibles() {
        return leerLista("SELECT codigo_espacio FROM espacio_parqueo WHERE estado_actual = 'disponible' ORDER BY id");
    }

    public List<String> getTiposVehiculo() {
        return leerLista("SELECT nombre_tipo FROM tipo_vehiculo ORDER BY id");
    }

    public List<String> getMetodosPago() {
        return leerLista("SELECT nombre_metodo FROM metodo_pago ORDER BY id");
    }

    // Ejecuta una consulta que devuelve una sola columna y la convierte en lista
    private List<String> leerLista(String sql) {
        List<String> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println("Error en ReservaDAO: " + e.getMessage());
        }
        return lista;
    }

    // CREAR UNA RESERVA
    // Devuelve true si se guardó. Si no, el motivo queda en getError().
    public boolean crear(String nombre, String documento, String telefono, String correo,
                         String placa, String tipoVehiculo, String codigoCupo,
                         double valor, String medioPago) {

        // Los cupos M son solo para motos; carros y camionetas van en los cupos A
        boolean cupoDeMotos = codigoCupo.toUpperCase().startsWith("M");
        boolean esMoto = tipoVehiculo.equalsIgnoreCase("Moto");
        if (cupoDeMotos != esMoto) {
            error = "El cupo " + codigoCupo + " no sirve para " + tipoVehiculo
                    + ": los cupos M son solo para motos y los A para carros y camionetas.";
            return false;
        }

        try (Connection conn = ConexionBD.getConnection()) {

            // 1) El cupo tiene que estar disponible
            int idCupo = buscarId(conn,
                    "SELECT id FROM espacio_parqueo WHERE codigo_espacio = ? AND estado_actual = 'disponible'",
                    codigoCupo);
            if (idCupo == 0) {
                error = "El cupo " + codigoCupo + " ya no está disponible.";
                return false;
            }

            // 2) La placa no puede tener otra reserva activa
            int yaReservada = buscarId(conn,
                    "SELECT id FROM suscripciones_mensuales WHERE id_placa = ? AND estado_suscripcion = 'activa'",
                    placa);
            if (yaReservada != 0) {
                error = "La placa " + placa + " ya tiene una reserva activa.";
                return false;
            }

            // 3) El medio de pago y el tipo de vehículo tienen que existir
            int idMetodo = buscarId(conn, "SELECT id FROM metodo_pago WHERE nombre_metodo = ?", medioPago);
            int idTipo = buscarId(conn, "SELECT id FROM tipo_vehiculo WHERE nombre_tipo = ?", tipoVehiculo);
            if (idMetodo == 0 || idTipo == 0) {
                error = "El tipo de vehículo o el medio de pago no existe en la base de datos.";
                return false;
            }

            // 4) Cliente: si ya existe (por documento) lo usamos; si no, lo creamos
            int idCliente = buscarId(conn, "SELECT id FROM cliente WHERE documento = ?", documento);
            if (idCliente == 0) {
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO cliente (nombre_completo, documento, telefono, correo) VALUES (?, ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, nombre);
                ps.setString(2, documento);
                ps.setString(3, telefono.isEmpty() ? null : telefono);
                ps.setString(4, correo.isEmpty() ? null : correo);
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    idCliente = keys.getInt(1);
                }
            }

            // 5) Vehículo: si no existe lo creamos
            if (buscarId(conn, "SELECT 1 FROM vehiculos WHERE placa = ?", placa) == 0) {
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO vehiculos (placa, id_tipo_vehiculo, marca, modelo, color) "
                        + "VALUES (?, ?, 'DESCONOCIDA', 'DESCONOCIDA', 'DESCONOCIDA')");
                ps.setString(1, placa);
                ps.setInt(2, idTipo);
                ps.executeUpdate();
            }

            // 6) Guardamos la reserva (dura un mes desde hoy)
            LocalDate inicio = LocalDate.now();
            LocalDate fin = inicio.plusMonths(1);
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO suscripciones_mensuales "
                    + "(id_cliente, id_placa, fecha_inicio, fecha_fin, valor_mensualidad, estado_suscripcion, id_espacio_parqueo) "
                    + "VALUES (?, ?, ?, ?, ?, 'activa', ?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, idCliente);
            ps.setString(2, placa);
            ps.setString(3, inicio.toString());   // formato AAAA-MM-DD
            ps.setString(4, fin.toString());
            ps.setDouble(5, valor);
            ps.setInt(6, idCupo);
            ps.executeUpdate();

            int idReserva = 0;
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                idReserva = keys.getInt(1);
            }

            // 7) Guardamos el pago de la mensualidad
            ps = conn.prepareStatement(
                    "INSERT INTO comprobantes_pago "
                    + "(id_suscripcion, id_metodo_pago, numero_ticket, subtotal, impuestos, total_pagado, fecha_hora_pago) "
                    + "VALUES (?, ?, ?, ?, 0, ?, NOW())");
            ps.setInt(1, idReserva);
            ps.setInt(2, idMetodo);
            ps.setString(3, "RES-" + idReserva);
            ps.setDouble(4, valor);
            ps.setDouble(5, valor);
            ps.executeUpdate();

            // 8) El cupo pasa a 'reservado'
            ps = conn.prepareStatement("UPDATE espacio_parqueo SET estado_actual = 'reservado' WHERE id = ?");
            ps.setInt(1, idCupo);
            ps.executeUpdate();

            return true;

        } catch (Exception e) {
            System.out.println("Error al crear la reserva: " + e.getMessage());
            error = "No se pudo guardar la reserva. Revisa la consola.";
            return false;
        }
    }

    // CANCELAR UNA RESERVA: queda 'cancelada' y el cupo vuelve a 'disponible'
    public boolean cancelar(int idReserva) {
        try (Connection conn = ConexionBD.getConnection()) {

            int idCupo = buscarId(conn,
                    "SELECT id_espacio_parqueo FROM suscripciones_mensuales WHERE id = ? AND estado_suscripcion = 'activa'",
                    String.valueOf(idReserva));

            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE suscripciones_mensuales SET estado_suscripcion = 'cancelada' WHERE id = ?");
            ps.setInt(1, idReserva);
            ps.executeUpdate();

            if (idCupo > 0) {
                ps = conn.prepareStatement("UPDATE espacio_parqueo SET estado_actual = 'disponible' WHERE id = ?");
                ps.setInt(1, idCupo);
                ps.executeUpdate();
            }
            return true;

        } catch (Exception e) {
            System.out.println("Error al cancelar la reserva: " + e.getMessage());
            error = "No se pudo cancelar la reserva. Revisa la consola.";
            return false;
        }
    }

    // Ejecuta una consulta con un dato y devuelve el primer número (0 si no hay resultados)
    private int buscarId(Connection conn, String sql, String dato) throws Exception {
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, dato);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }
}

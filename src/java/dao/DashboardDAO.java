package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.Actividad;
import modelo.Cupo;
import modelo.DashboardResumen;
import util.ConexionBD;

// Consultas del dashboard. Todo sale de la base de datos.
public class DashboardDAO {

    // Recaudo del día: parqueo por hora + mensualidades de las reservas
    private static final String SQL_RECAUDO =
        "SELECT COALESCE(SUM(total_pagado), 0) FROM comprobantes_pago " +
        "WHERE DATE(fecha_hora_pago) = CURDATE()";

    private static final String SQL_INCIDENTES =
        "SELECT COUNT(*) FROM incidentes WHERE DATE(fecha_hora) = CURDATE()";

    // Reservas vigentes: suscripciones activas que todavía no vencen
    private static final String SQL_RESERVAS =
        "SELECT COUNT(*) FROM suscripciones_mensuales " +
        "WHERE LOWER(estado_suscripcion) = 'activa' AND fecha_fin >= CURDATE()";

    // Resumen para las tarjetas
    public DashboardResumen getResumen() {
        DashboardResumen r = new DashboardResumen();

        int hoy = scalarInt("SELECT COUNT(*) FROM registros_parqueo WHERE DATE(fecha_hora_ingreso) = CURDATE()");
        int ayer = scalarInt("SELECT COUNT(*) FROM registros_parqueo WHERE DATE(fecha_hora_ingreso) = CURDATE() - INTERVAL 1 DAY");
        r.setVehiculosHoy(hoy);
        r.setVariacion(ayer > 0 ? Integer.valueOf(Math.round((hoy - ayer) * 100f / ayer)) : null);

        r.setSalidasHoy(scalarInt("SELECT COUNT(*) FROM registros_parqueo WHERE DATE(fecha_hora_salida) = CURDATE()"));

        r.setTotalCupos(scalarInt("SELECT COUNT(*) FROM espacio_parqueo"));
        r.setCuposDisponibles(scalarInt("SELECT COUNT(*) FROM espacio_parqueo WHERE LOWER(estado_actual) = 'disponible'"));
        r.setCuposOcupados(scalarInt("SELECT COUNT(*) FROM espacio_parqueo WHERE LOWER(estado_actual) = 'ocupado'"));
        r.setCuposReservados(scalarInt("SELECT COUNT(*) FROM espacio_parqueo WHERE LOWER(estado_actual) = 'reservado'"));

        r.setReservasActivas(scalarInt(SQL_RESERVAS));
        r.setRecaudadoHoy(scalarDouble(SQL_RECAUDO));
        r.setIncidentesHoy(scalarInt(SQL_INCIDENTES));
        return r;
    }

    // Cuadrícula de ocupación
    public List<Cupo> getCupos() {
        List<Cupo> lista = new ArrayList<>();
        String sql = "SELECT codigo_espacio, estado_actual FROM espacio_parqueo ORDER BY id";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Cupo(rs.getString("codigo_espacio"), rs.getString("estado_actual")));
            }
        } catch (Exception e) {
            System.out.println("Error en getCupos: " + e.getMessage());
        }
        return lista;
    }

    // Actividad reciente
    // Hacemos 4 consultas sencillas (ingresos, salidas, reservas e incidentes),
    // las juntamos en una sola lista y la ordenamos del más reciente al más antiguo.
    public List<Actividad> getActividadReciente(int limite) {
        List<Actividad> lista = new ArrayList<>();
        lista.addAll(actividadIngresos());
        lista.addAll(actividadSalidas());
        lista.addAll(actividadReservas());
        lista.addAll(actividadIncidentes());

        // Menos minutos = más reciente
        lista.sort((a, b) -> Long.compare(a.getMinutos(), b.getMinutos()));

        // Nos quedamos solo con los primeros "limite"
        if (lista.size() > limite) {
            return new ArrayList<>(lista.subList(0, limite));
        }
        return lista;
    }

    // Últimos ingresos de vehículos
    private List<Actividad> actividadIngresos() {
        String sql =
            "SELECT r.id_placa, t.nombre_tipo, e.codigo_espacio, " +
            "       TIMESTAMPDIFF(MINUTE, r.fecha_hora_ingreso, NOW()) AS minutos " +
            "FROM registros_parqueo r " +
            "LEFT JOIN vehiculos v ON r.id_placa = v.placa " +
            "LEFT JOIN tipo_vehiculo t ON v.id_tipo_vehiculo = t.id " +
            "LEFT JOIN espacio_parqueo e ON r.id_espacio_parqueo = e.id " +
            "ORDER BY r.fecha_hora_ingreso DESC LIMIT 6";
        List<Actividad> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String titulo = "Ingreso: " + rs.getString("nombre_tipo") + " (" + rs.getString("id_placa") + ")";
                String detalle = "Cupo " + rs.getString("codigo_espacio") + " · " + hace(rs.getLong("minutos"));
                lista.add(new Actividad("ingreso", titulo, detalle, rs.getLong("minutos")));
            }
        } catch (Exception e) {
            System.out.println("Error en actividad de ingresos: " + e.getMessage());
        }
        return lista;
    }

    // Últimas salidas de vehículos
    private List<Actividad> actividadSalidas() {
        String sql =
            "SELECT r.id_placa, t.nombre_tipo, " +
            "       TIMESTAMPDIFF(MINUTE, r.fecha_hora_salida, NOW()) AS minutos " +
            "FROM registros_parqueo r " +
            "LEFT JOIN vehiculos v ON r.id_placa = v.placa " +
            "LEFT JOIN tipo_vehiculo t ON v.id_tipo_vehiculo = t.id " +
            "WHERE r.fecha_hora_salida IS NOT NULL " +
            "ORDER BY r.fecha_hora_salida DESC LIMIT 6";
        List<Actividad> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String titulo = "Salida: " + rs.getString("nombre_tipo") + " (" + rs.getString("id_placa") + ")";
                String detalle = hace(rs.getLong("minutos"));
                lista.add(new Actividad("salida", titulo, detalle, rs.getLong("minutos")));
            }
        } catch (Exception e) {
            System.out.println("Error en actividad de salidas: " + e.getMessage());
        }
        return lista;
    }

    // Últimas reservas (usa la fecha de inicio, que ya existe en la tabla)
    private List<Actividad> actividadReservas() {
        String sql =
            "SELECT id_placa, " +
            "       TIMESTAMPDIFF(MINUTE, fecha_inicio, NOW()) AS minutos " +
            "FROM suscripciones_mensuales " +
            "WHERE LOWER(estado_suscripcion) = 'activa' " +
            "ORDER BY id DESC LIMIT 6";
        List<Actividad> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String titulo = "Reserva: " + rs.getString("id_placa");
                String detalle = "Reserva mensual activa";
                lista.add(new Actividad("reserva", titulo, detalle, rs.getLong("minutos")));
            }
        } catch (Exception e) {
            System.out.println("Error en actividad de reservas: " + e.getMessage());
        }
        return lista;
    }

    // Últimos incidentes
    private List<Actividad> actividadIncidentes() {
        String sql =
            "SELECT descripcion, ubicacion, " +
            "       TIMESTAMPDIFF(MINUTE, fecha_hora, NOW()) AS minutos " +
            "FROM incidentes ORDER BY fecha_hora DESC LIMIT 6";
        List<Actividad> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String titulo = "Incidente: " + rs.getString("descripcion");
                String detalle = rs.getString("ubicacion") + " · " + hace(rs.getLong("minutos"));
                lista.add(new Actividad("incidente", titulo, detalle, rs.getLong("minutos")));
            }
        } catch (Exception e) {
            System.out.println("Error en actividad de incidentes: " + e.getMessage());
        }
        return lista;
    }

    // Utilidades
    private int scalarInt(String sql) {
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Error en consulta del dashboard: " + e.getMessage());
        }
        return 0;
    }

    private double scalarDouble(String sql) {
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            System.out.println("Error en consulta del dashboard: " + e.getMessage());
        }
        return 0;
    }

    // Convierte minutos en "Hace 5 min", "Hace 2 h" o "Hace 3 d"
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

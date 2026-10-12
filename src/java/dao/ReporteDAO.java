package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import modelo.Barra;
import modelo.Categoria;
import modelo.ReporteResumen;
import util.ConexionBD;

// Consultas de Reportes: suma lo recaudado y cuenta vehículos entre dos fechas.
public class ReporteDAO {

    // Arma el reporte completo para el rango. tipo = diario, semanal, mensual o vehiculos
    public ReporteResumen generar(LocalDate desde, LocalDate hasta, String tipo) {
        ReporteResumen r = new ReporteResumen();

        long dias = ChronoUnit.DAYS.between(desde, hasta) + 1;
        r.totalRecaudado = total(desde, hasta);
        r.vehiculosAtendidos = vehiculos(desde, hasta);
        r.promedioDiario = r.totalRecaudado / dias;

        // Para el porcentaje de cambio comparamos con el período anterior de la misma duración
        LocalDate antesHasta = desde.minusDays(1);
        LocalDate antesDesde = antesHasta.minusDays(dias - 1);
        double totalAntes = total(antesDesde, antesHasta);
        int vehiculosAntes = vehiculos(antesDesde, antesHasta);
        r.cambioTotal = cambio(r.totalRecaudado, totalAntes);
        r.cambioPromedio = cambio(r.promedioDiario, totalAntes / dias);
        r.cambioVehiculos = cambio(r.vehiculosAtendidos, vehiculosAntes);

        r.barras = barras(desde, hasta, tipo);
        r.categorias = categorias(desde, hasta);
        return r;
    }

    private Integer cambio(double actual, double anterior) {
        if (anterior <= 0) {
            return null;
        }
        return (int) Math.round((actual - anterior) * 100 / anterior);
    }

    private double total(LocalDate desde, LocalDate hasta) {
        String sql = "SELECT COALESCE(SUM(total_pagado), 0) FROM comprobantes_pago WHERE DATE(fecha_hora_pago) BETWEEN ? AND ?";
        return numero(sql, desde, hasta);
    }

    private int vehiculos(LocalDate desde, LocalDate hasta) {
        String sql = "SELECT COUNT(*) FROM registros_parqueo WHERE DATE(fecha_hora_ingreso) BETWEEN ? AND ?";
        return (int) numero(sql, desde, hasta);
    }

    // Ejecuta una consulta que devuelve un solo número
    private double numero(String sql, LocalDate desde, LocalDate hasta) {
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, desde.toString());
            ps.setString(2, hasta.toString());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println("Error en el reporte: " + e.getMessage());
        }
        return 0;
    }

    // Barras del gráfico
    private List<Barra> barras(LocalDate desde, LocalDate hasta, String tipo) {
        String sql;
        if (tipo.equals("vehiculos")) {
            sql = "SELECT t.nombre_tipo AS etiqueta, COUNT(*) AS valor "
                + "FROM registros_parqueo r JOIN vehiculos v ON v.placa = r.id_placa "
                + "JOIN tipo_vehiculo t ON t.id = v.id_tipo_vehiculo "
                + "WHERE DATE(r.fecha_hora_ingreso) BETWEEN ? AND ? GROUP BY t.nombre_tipo ORDER BY t.nombre_tipo";
        } else if (tipo.equals("semanal")) {
            sql = "SELECT CONCAT('Sem ', WEEK(fecha_hora_pago, 1)) AS etiqueta, SUM(total_pagado) AS valor "
                + "FROM comprobantes_pago WHERE DATE(fecha_hora_pago) BETWEEN ? AND ? "
                + "GROUP BY YEARWEEK(fecha_hora_pago, 1), WEEK(fecha_hora_pago, 1) ORDER BY YEARWEEK(fecha_hora_pago, 1)";
        } else if (tipo.equals("mensual")) {
            sql = "SELECT DATE_FORMAT(fecha_hora_pago, '%m/%Y') AS etiqueta, SUM(total_pagado) AS valor "
                + "FROM comprobantes_pago WHERE DATE(fecha_hora_pago) BETWEEN ? AND ? "
                + "GROUP BY DATE_FORMAT(fecha_hora_pago, '%Y-%m'), DATE_FORMAT(fecha_hora_pago, '%m/%Y') "
                + "ORDER BY DATE_FORMAT(fecha_hora_pago, '%Y-%m')";
        } else {
            sql = "SELECT DATE_FORMAT(fecha_hora_pago, '%d/%m') AS etiqueta, SUM(total_pagado) AS valor "
                + "FROM comprobantes_pago WHERE DATE(fecha_hora_pago) BETWEEN ? AND ? "
                + "GROUP BY DATE(fecha_hora_pago), DATE_FORMAT(fecha_hora_pago, '%d/%m') ORDER BY DATE(fecha_hora_pago)";
        }

        List<Barra> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, desde.toString());
            ps.setString(2, hasta.toString());
            ResultSet rs = ps.executeQuery();
            double mayor = 0;
            while (rs.next()) {
                Barra b = new Barra();
                b.etiqueta = rs.getString("etiqueta");
                b.valor = rs.getDouble("valor");
                if (b.valor > mayor) {
                    mayor = b.valor;
                }
                lista.add(b);
            }
            // La barra más alta mide 100 %, las demás se calculan frente a ella
            for (Barra b : lista) {
                b.porcentaje = mayor > 0 ? (int) Math.max(4, Math.round(b.valor * 100 / mayor)) : 0;
            }
        } catch (Exception e) {
            System.out.println("Error en el gráfico: " + e.getMessage());
        }
        return lista;
    }

    // Total recaudado por tipo de vehículo (las mensualidades salen como "Mensualidades")
    private List<Categoria> categorias(LocalDate desde, LocalDate hasta) {
        String sql = "SELECT COALESCE(t.nombre_tipo, 'Mensualidades') AS nombre, SUM(c.total_pagado) AS valor "
                + "FROM comprobantes_pago c "
                + "LEFT JOIN registros_parqueo r ON r.id = c.id_registro_parqueo "
                + "LEFT JOIN vehiculos v ON v.placa = r.id_placa "
                + "LEFT JOIN tipo_vehiculo t ON t.id = v.id_tipo_vehiculo "
                + "WHERE DATE(c.fecha_hora_pago) BETWEEN ? AND ? "
                + "GROUP BY COALESCE(t.nombre_tipo, 'Mensualidades') ORDER BY valor DESC";
        List<Categoria> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, desde.toString());
            ps.setString(2, hasta.toString());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Categoria c = new Categoria();
                c.nombre = rs.getString("nombre");
                c.valor = rs.getDouble("valor");
                lista.add(c);
            }
        } catch (Exception e) {
            System.out.println("Error en las categorías: " + e.getMessage());
        }
        return lista;
    }

    // Filas para exportar a Excel (CSV): cada elemento es {ticket, fecha, placa, tipo, medio de pago, total}
    public List<String[]> detalle(LocalDate desde, LocalDate hasta) {
        String sql = "SELECT c.numero_ticket, DATE_FORMAT(c.fecha_hora_pago, '%Y-%m-%d %H:%i') AS fecha, "
                + "COALESCE(r.id_placa, s.id_placa, '') AS placa, COALESCE(t.nombre_tipo, 'Mensualidad') AS tipo, "
                + "m.nombre_metodo, c.total_pagado "
                + "FROM comprobantes_pago c "
                + "LEFT JOIN registros_parqueo r ON r.id = c.id_registro_parqueo "
                + "LEFT JOIN suscripciones_mensuales s ON s.id = c.id_suscripcion "
                + "LEFT JOIN vehiculos v ON v.placa = COALESCE(r.id_placa, s.id_placa) "
                + "LEFT JOIN tipo_vehiculo t ON t.id = v.id_tipo_vehiculo "
                + "JOIN metodo_pago m ON m.id = c.id_metodo_pago "
                + "WHERE DATE(c.fecha_hora_pago) BETWEEN ? AND ? ORDER BY c.fecha_hora_pago";
        List<String[]> lista = new ArrayList<>();
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, desde.toString());
            ps.setString(2, hasta.toString());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new String[]{rs.getString(1), rs.getString(2), rs.getString(3),
                                       rs.getString(4), rs.getString(5), rs.getString(6)});
            }
        } catch (Exception e) {
            System.out.println("Error al exportar: " + e.getMessage());
        }
        return lista;
    }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.ConsultaFila;
import util.ConexionBD;

// Consultas de la pantalla Consulta.
public class ConsultaDAO {

    // texto = placa o ticket (vacío = los últimos movimientos)
    // estado = todos, activo (sigue dentro) o finalizado (ya salió)
    public List<ConsultaFila> buscar(String texto, String estado) {
        List<ConsultaFila> lista = new ArrayList<>();

        String sql = "SELECT r.id, r.id_placa, t.nombre_tipo, e.codigo_espacio, u.nombre_completo AS operario, "
                + "DATE_FORMAT(r.fecha_hora_ingreso, '%d/%m/%Y - %H:%i') AS ingreso, "
                + "DATE_FORMAT(r.fecha_hora_salida, '%d/%m/%Y - %H:%i') AS salida, "
                + "TIMESTAMPDIFF(MINUTE, r.fecha_hora_ingreso, COALESCE(r.fecha_hora_salida, NOW())) AS minutos, "
                + "c.total_pagado, m.nombre_metodo "
                + "FROM registros_parqueo r "
                + "JOIN vehiculos v ON v.placa = r.id_placa "
                + "JOIN tipo_vehiculo t ON t.id = v.id_tipo_vehiculo "
                + "LEFT JOIN espacio_parqueo e ON e.id = r.id_espacio_parqueo "
                + "LEFT JOIN usuario u ON u.id = r.id_usuario "
                + "LEFT JOIN comprobantes_pago c ON c.id_registro_parqueo = r.id "
                + "LEFT JOIN metodo_pago m ON m.id = c.id_metodo_pago "
                + "WHERE (r.id_placa LIKE ? OR r.id = ?) ";
        if (estado.equals("activo")) {
            sql += "AND r.fecha_hora_salida IS NULL ";
        } else if (estado.equals("finalizado")) {
            sql += "AND r.fecha_hora_salida IS NOT NULL ";
        }
        sql += "ORDER BY r.id DESC LIMIT 30";

        // Si escribieron "TKT-12" o "#TKT-12" nos quedamos con el número 12
        String limpio = texto.toUpperCase().replace("#", "").replace("TKT-", "").trim();
        int idTicket = -1;
        try {
            idTicket = Integer.parseInt(limpio);
        } catch (NumberFormatException e) {
            // no era un número: se busca solo por placa
        }

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + texto.toUpperCase().trim() + "%");
            ps.setInt(2, idTicket);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ConsultaFila f = new ConsultaFila();
                f.id = rs.getInt("id");
                f.placa = rs.getString("id_placa");
                f.tipo = rs.getString("nombre_tipo");
                f.ingreso = rs.getString("ingreso");
                f.salida = rs.getString("salida");
                f.minutos = Math.max(0, rs.getLong("minutos"));
                double total = rs.getDouble("total_pagado");
                f.monto = rs.wasNull() ? null : Double.valueOf(total);
                f.cupo = rs.getString("codigo_espacio");
                f.operario = rs.getString("operario");
                f.medioPago = rs.getString("nombre_metodo");
                lista.add(f);
            }
        } catch (Exception e) {
            System.out.println("Error en la consulta: " + e.getMessage());
        }
        return lista;
    }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.AuditoriaFila;
import util.ConexionBD;

// Guarda y consulta el historial de lo que hace cada usuario.
public class AuditoriaDAO {

    public static final int POR_PAGINA = 10;

    // Guardar un evento (no detiene el programa si falla)
    public static void registrar(int idUsuario, String accion, String modulo, String detalle, String ip) {
        String sql = "INSERT INTO auditoria (id_usuario, accion_realizada, tabla_afectada, descripcion_detalle, fecha_hora_accion, direccion_ip) "
                + "VALUES (?, ?, ?, ?, NOW(), ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, accion);
            ps.setString(3, modulo);
            ps.setString(4, detalle);
            ps.setString(5, ip);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al guardar la auditoría: " + e.getMessage());
        }
    }

    // Filtros: usuario (id o ""), fecha (hoy / semana / mes / todos), módulo ("" = todos)
    private String condiciones(String usuario, String fecha, String modulo) {
        String where = " WHERE 1 = 1";
        if (!usuario.isEmpty()) {
            where += " AND a.id_usuario = ?";
        }
        if (fecha.equals("hoy")) {
            where += " AND DATE(a.fecha_hora_accion) = CURDATE()";
        } else if (fecha.equals("semana")) {
            where += " AND YEARWEEK(a.fecha_hora_accion, 1) = YEARWEEK(CURDATE(), 1)";
        } else if (fecha.equals("mes")) {
            where += " AND YEAR(a.fecha_hora_accion) = YEAR(CURDATE()) AND MONTH(a.fecha_hora_accion) = MONTH(CURDATE())";
        }
        if (!modulo.isEmpty()) {
            where += " AND a.tabla_afectada = ?";
        }
        return where;
    }

    // Pone los valores de los "?" en el mismo orden en que aparecen
    private void valores(PreparedStatement ps, String usuario, String modulo) throws Exception {
        int n = 1;
        if (!usuario.isEmpty()) {
            ps.setInt(n++, Integer.parseInt(usuario));
        }
        if (!modulo.isEmpty()) {
            ps.setString(n++, modulo);
        }
    }

    public int contar(String usuario, String fecha, String modulo) {
        String sql = "SELECT COUNT(*) FROM auditoria a" + condiciones(usuario, fecha, modulo);
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            valores(ps, usuario, modulo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error al contar la auditoría: " + e.getMessage());
        }
        return 0;
    }

    public List<AuditoriaFila> listar(String usuario, String fecha, String modulo, int pagina) {
        List<AuditoriaFila> lista = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(a.fecha_hora_accion, '%d/%m/%Y - %H:%i') AS fecha, "
                + "u.nombre_completo, a.accion_realizada, a.tabla_afectada, a.descripcion_detalle, a.direccion_ip "
                + "FROM auditoria a JOIN usuario u ON u.id = a.id_usuario"
                + condiciones(usuario, fecha, modulo)
                + " ORDER BY a.fecha_hora_accion DESC, a.id DESC LIMIT ? OFFSET ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            valores(ps, usuario, modulo);
            int n = (usuario.isEmpty() ? 0 : 1) + (modulo.isEmpty() ? 0 : 1);
            ps.setInt(n + 1, POR_PAGINA);
            ps.setInt(n + 2, (pagina - 1) * POR_PAGINA);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AuditoriaFila f = new AuditoriaFila();
                f.fecha = rs.getString("fecha");
                f.usuario = rs.getString("nombre_completo");
                f.accion = rs.getString("accion_realizada");
                f.modulo = rs.getString("tabla_afectada");
                f.detalle = rs.getString("descripcion_detalle");
                f.ip = rs.getString("direccion_ip");
                lista.add(f);
            }
        } catch (Exception e) {
            System.out.println("Error al leer la auditoría: " + e.getMessage());
        }
        return lista;
    }

    // Usuarios para el filtro: cada elemento es {id, nombre}
    public List<String[]> usuarios() {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT id, nombre_completo FROM usuario ORDER BY nombre_completo";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new String[]{rs.getString(1), rs.getString(2)});
            }
        } catch (Exception e) {
            System.out.println("Error al leer los usuarios: " + e.getMessage());
        }
        return lista;
    }
}

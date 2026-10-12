package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import dao.ReporteDAO;
import modelo.ReporteResumen;
import modelo.Usuario;
import util.Sesion;

// Reportes de ingresos por rango de fechas. Con exportar=csv descarga un archivo para Excel.
@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = Sesion.usuario(request);
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fechas: si no vienen (o no son válidas) usamos los últimos 7 días
        LocalDate hoy = LocalDate.now();
        LocalDate desde = aFecha(request.getParameter("desde"), hoy.minusDays(6));
        LocalDate hasta = aFecha(request.getParameter("hasta"), hoy);

        String tipo = request.getParameter("tipo");
        if (tipo == null || tipo.isEmpty()) {
            tipo = "diario";
        }

        request.setAttribute("desde", desde.toString());
        request.setAttribute("hasta", hasta.toString());
        request.setAttribute("tipo", tipo);

        // Fechas incorrectas -> ventana "Fecha inválida"
        if (hasta.isAfter(hoy) || desde.isAfter(hasta)) {
            request.setAttribute("fechaInvalida", "true");
            request.setAttribute("reporte", new ReporteResumen());
            request.getRequestDispatcher("reportes.jsp").forward(request, response);
            return;
        }

        ReporteDAO dao = new ReporteDAO();

        // Descargar el archivo para Excel
        if ("csv".equals(request.getParameter("exportar"))) {
            exportar(response, dao.detalle(desde, hasta), desde, hasta);
            AuditoriaDAO.registrar(usuario.getId(), "Exportar Reporte", "Reportes",
                    "Reporte del " + desde + " al " + hasta, request.getRemoteAddr());
            return;
        }

        ReporteResumen reporte = dao.generar(desde, hasta, tipo);
        request.setAttribute("reporte", reporte);
        if (reporte.sinDatos()) {
            request.setAttribute("sinDatos", "true");
        }
        request.getRequestDispatcher("reportes.jsp").forward(request, response);
    }

    // Escribe un archivo CSV (se abre con Excel). El ; separa las columnas.
    private void exportar(HttpServletResponse response, List<String[]> filas, LocalDate desde, LocalDate hasta)
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=reporte_" + desde + "_a_" + hasta + ".csv");
        PrintWriter out = response.getWriter();
        out.print('﻿');   // marca para que Excel entienda las tildes
        out.println("Ticket;Fecha;Placa;Tipo;Medio de pago;Total");
        for (String[] f : filas) {
            out.println(f[0] + ";" + f[1] + ";" + f[2] + ";" + f[3] + ";" + f[4] + ";" + f[5]);
        }
        out.flush();
    }

    private LocalDate aFecha(String texto, LocalDate porDefecto) {
        try {
            return LocalDate.parse(texto);
        } catch (Exception e) {
            return porDefecto;
        }
    }
}

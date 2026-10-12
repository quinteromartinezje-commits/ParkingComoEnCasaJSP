<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.ReporteResumen, modelo.Barra, modelo.Categoria" %>
<%@ include file="sesion.jspf" %>
<%!
    // Muestra el cambio frente al período anterior: +15% (verde) o -5%
    String cambio(Integer c) {
        if (c == null) return "";
        String clase = c >= 0 ? "positive" : "negative";
        String signo = c >= 0 ? "+" : "";
        return "<span class=\"stat-cambio " + clase + "\"" + (c < 0 ? " style=\"color:#dc3545;\"" : "") + ">" + signo + c + "%</span>";
    }
%>
<%
    String paginaActiva = "reportes";
    String tituloPagina = "Reportes y Estadísticas";

    ReporteResumen reporte = (ReporteResumen) request.getAttribute("reporte");
    if (reporte == null) reporte = new ReporteResumen();
    String desde = (String) request.getAttribute("desde");
    String hasta = (String) request.getAttribute("hasta");
    String tipo = (String) request.getAttribute("tipo");
    if (tipo == null) tipo = "diario";
    boolean fechaInvalida = request.getAttribute("fechaInvalida") != null;
    boolean sinDatos = request.getAttribute("sinDatos") != null;

    String tituloGrafico = tipo.equals("semanal") ? "Ingresos Semanales (COP)"
            : tipo.equals("mensual") ? "Ingresos Mensuales (COP)"
            : tipo.equals("vehiculos") ? "Vehículos por Tipo"
            : "Histórico de Ingresos Diarios (COP)";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/reportes.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <% if (fechaInvalida) { %>
                <div class="msg msg-error">La fecha "Desde" no puede ser mayor que la fecha "Hasta".</div>
                <% } else if (sinDatos) { %>
                <div class="msg msg-error">No hay datos para el rango seleccionado.</div>
                <% } %>

                <!-- Filtros: es un formulario GET normal -->
                <div class="card">
                    <form class="reportes-filtros" action="ReporteServlet" method="get">
                        <div class="filtros-row">
                            <div class="form-group">
                                <label class="form-label">Desde</label>
                                <input type="date" name="desde" class="form-input" value="<%= ver(desde) %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hasta</label>
                                <input type="date" name="hasta" class="form-input" value="<%= ver(hasta) %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Tipo de Reporte</label>
                                <select name="tipo" class="form-input">
                                    <option value="diario"<%= tipo.equals("diario") ? " selected" : "" %>>Ingresos Diarios</option>
                                    <option value="semanal"<%= tipo.equals("semanal") ? " selected" : "" %>>Ingresos Semanales</option>
                                    <option value="mensual"<%= tipo.equals("mensual") ? " selected" : "" %>>Ingresos Mensuales</option>
                                    <option value="vehiculos"<%= tipo.equals("vehiculos") ? " selected" : "" %>>Vehículos por Tipo</option>
                                </select>
                            </div>
                        </div>
                        <div class="filtros-acciones">
                            <button type="submit" class="btn btn-primary">GENERAR REPORTE</button>
                            <button type="submit" name="exportar" value="csv" class="btn btn-excel">EXPORTAR EXCEL (CSV)</button>
                        </div>
                    </form>
                </div>

                <!-- Tarjetas -->
                <div class="stats-grid-reportes">
                    <div class="stat-card-reporte">
                        <div class="stat-header-reporte"><span class="stat-label-reporte">Total Recaudado</span></div>
                        <div class="stat-value-reporte"><%= plata(reporte.totalRecaudado) %> <%= cambio(reporte.cambioTotal) %></div>
                    </div>
                    <div class="stat-card-reporte">
                        <div class="stat-header-reporte"><span class="stat-label-reporte">Promedio Diario</span></div>
                        <div class="stat-value-reporte"><%= plata(reporte.promedioDiario) %> <%= cambio(reporte.cambioPromedio) %></div>
                    </div>
                    <div class="stat-card-reporte">
                        <div class="stat-header-reporte"><span class="stat-label-reporte">Vehículos Atendidos</span></div>
                        <div class="stat-value-reporte"><%= reporte.vehiculosAtendidos %> <%= cambio(reporte.cambioVehiculos) %></div>
                    </div>
                </div>

                <div class="reportes-grid">
                    <div class="card card-grande">
                        <div class="card-header"><h2><%= tituloGrafico %></h2></div>
                        <div class="chart-container">
                            <div class="bar-chart">
                                <% if (reporte.barras.isEmpty()) { %>
                                <p style="padding:16px;">Sin información para graficar.</p>
                                <% } else { for (Barra b : reporte.barras) { %>
                                <div class="bar-item" title="<%= tipo.equals("vehiculos") ? String.valueOf((long) b.valor) : plata(b.valor) %>">
                                    <div class="bar" style="height: <%= Math.max(b.porcentaje, 2) %>%"></div>
                                    <span class="bar-label"><%= ver(b.etiqueta) %></span>
                                </div>
                                <% } } %>
                            </div>
                        </div>
                    </div>

                    <div class="card card-pequena">
                        <div class="card-header"><h2>Resumen de Categorías</h2></div>
                        <div class="categorias-list">
                            <% if (reporte.categorias.isEmpty()) { %>
                            <p>Sin datos.</p>
                            <% } else { for (Categoria c : reporte.categorias) { %>
                            <div class="categoria-item">
                                <span class="categoria-nombre"><%= ver(c.nombre) %></span>
                                <span class="categoria-valor"><%= plata(c.valor) %></span>
                            </div>
                            <% } } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

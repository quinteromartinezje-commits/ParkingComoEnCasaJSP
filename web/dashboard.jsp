<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.DashboardResumen" %>
<%@ page import="modelo.Cupo" %>
<%@ page import="modelo.Actividad" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "dashboard";
    String tituloPagina = "Dashboard General";

    // Los datos los prepara DashboardServlet (método GET). Si alguien abre
    // dashboard.jsp directamente, lo mandamos primero al servlet.
    DashboardResumen resumen = (DashboardResumen) request.getAttribute("resumen");
    if (resumen == null) {
        response.sendRedirect("DashboardServlet");
        return;
    }
    List<Cupo> cupos = (List<Cupo>) request.getAttribute("cupos");
    List<Actividad> actividades = (List<Actividad>) request.getAttribute("actividades");
    String horaActual = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- La página se vuelve a pedir al servlet cada 30 segundos para mostrar datos nuevos -->
    <meta http-equiv="refresh" content="30;url=DashboardServlet">
    <title>Dashboard General - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>

    <div class="app-container">

        <!-- MENÚ LATERAL -->
        <%@ include file="menu.jspf" %>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="main-content">

            <%@ include file="cabecera.jspf" %>

            <main class="content-area">

                <p class="dashboard-refresh">Datos actualizados a las <strong><%= horaActual %></strong> · se refrescan solos cada 30 segundos</p>

                <!-- TARJETAS DE ESTADÍSTICAS (salen de la base de datos) -->
                <div class="stats-grid">

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Ingresos Hoy</span>
                            <div class="stat-icon blue"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg></div>
                        </div>
                        <div class="stat-value"><%= resumen.getVehiculosHoy() %>
                            <% if (resumen.getVariacion() != null) {
                                   int v = resumen.getVariacion(); %>
                                <span class="stat-change <%= v >= 0 ? "positive" : "negative" %>"><%= v >= 0 ? "+" : "" %><%= v %>%</span>
                            <% } %>
                        </div>
                        <div class="stat-sub">Vehículos que entraron hoy</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Salidas Hoy</span>
                            <div class="stat-icon blue"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></div>
                        </div>
                        <div class="stat-value"><%= resumen.getSalidasHoy() %></div>
                        <div class="stat-sub">Vehículos que ya pagaron y salieron</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Cupos Disponibles</span>
                            <div class="stat-icon blue"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg></div>
                        </div>
                        <div class="stat-value"><%= resumen.getCuposDisponibles() %>/<%= resumen.getTotalCupos() %></div>
                        <div class="stat-sub"><%= resumen.getCuposOcupados() %> ocupados · <%= resumen.getCuposReservados() %> reservados</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Reservas Activas</span>
                            <div class="stat-icon blue"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="24" height="24" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
                        </div>
                        <div class="stat-value"><%= resumen.getReservasActivas() %></div>
                        <div class="stat-sub"><a href="ReservaServlet">Ver reservas</a></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Recaudado Diario</span>
                            <div class="stat-icon blue"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
                        </div>
                        <div class="stat-value"><%= plata(resumen.getRecaudadoHoy()) %></div>
                        <div class="stat-sub">Parqueo por hora + reservas</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Incidentes</span>
                            <div class="stat-icon red"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                        </div>
                        <div class="stat-value"><%= resumen.getIncidentesHoy() %></div>
                        <div class="stat-sub">Reportados hoy</div>
                    </div>
                </div>

                <!-- SECCIÓN INFERIOR: Ocupación + Actividad -->
                <div class="dashboard-grid">

                    <!-- OCUPACIÓN EN TIEMPO REAL -->
                    <div class="card card-large">
                        <div class="card-header">
                            <h2>Ocupación en Tiempo Real</h2>
                        </div>
                        <div class="legend">
                            <span class="legend-item"><span class="dot blue"></span> Disp (<%= resumen.getCuposDisponibles() %>)</span>
                            <span class="legend-item"><span class="dot gray"></span> Ocup (<%= resumen.getCuposOcupados() %>)</span>
                            <span class="legend-item"><span class="dot yellow"></span> Res (<%= resumen.getCuposReservados() %>)</span>
                        </div>
                        <div class="cupos-grid">
                            <% if (cupos != null && !cupos.isEmpty()) {
                                   for (Cupo c : cupos) { %>
                                <div class="cupos <%= c.getColor() %>" title="<%= ver(c.getCodigo()) %> · <%= ver(c.getEstado()) %>"><%= ver(c.getCodigo()) %></div>
                            <%     }
                               } else { %>
                                <p>Aún no hay cupos registrados.</p>
                            <% } %>
                        </div>
                    </div>

                    <!-- ACTIVIDAD RECIENTE -->
                    <div class="card card-small">
                        <div class="card-header">
                            <h2>Actividad Reciente</h2>
                        </div>
                        <div class="activity-list">
                            <% if (actividades != null && !actividades.isEmpty()) {
                                   for (Actividad a : actividades) { %>
                                <div class="activity-item">
                                    <span class="activity-dot <%= a.getColor() %>"></span>
                                    <div class="activity-content">
                                        <strong><%= ver(a.getTitulo()) %></strong>
                                        <span><%= ver(a.getDetalle()) %></span>
                                    </div>
                                </div>
                            <%     }
                               } else { %>
                                <p>Todavía no hay movimientos.</p>
                            <% } %>
                        </div>
                    </div>

                </div>

            </main>
        </div>
    </div>
</body>
</html>

<%@ page import="modelo.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nombre = usuario.getNombre();
    String rol = usuario.getRol();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes de Operación - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/reportes.css">
</head>
<body>
    <div class="app-container">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="sidebar-logo">
                <img src="img/logoblanco.png" alt="Logo" class="sidebar-logo-img">
                <span class="sidebar-title">Parking Como en Casa</span>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="dashboard.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Dashboard</a></li>
                    <li><a href="ingreso.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg> Ingreso</a></li>
                    <li><a href="salida.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Salida</a></li>
                    <li><a href="tarifas.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg> Tarifas</a></li>
                    <li><a href="cupos.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Cupos</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
                    <li><a href="auditoria.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg> Auditoría</a></li>
                    <li><a href="consulta.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg> Consulta</a></li>
                    <li><a href="incidentes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> Incidentes</a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Cerrar Sesión
                </a>
            </div>
        </aside>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="main-content">
            <header class="navbar">
                <h1 class="page-title">Reportes de Operación</h1>
                <div class="navbar-right">
                    <button class="icon-btn" title="Notificaciones">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    </button>
                    <div class="user-info">
                        <div class="user-avatar">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        </div>
                        <div class="user-details">
    <span class="user-name"><%= nombre %></span>
    <span class="user-role"><%= rol %></span>
</div>
                    </div>
                </div>
            </header>

            <main class="content-area">
                <!-- FILTROS DE REPORTE -->
                <div class="card">
                    <div class="reportes-filtros">
                        <div class="filtros-row">
                            <div class="form-group">
                                <label class="form-label">Desde</label>
                                <input type="date" id="fechaDesde" class="form-input" value="2026-07-20">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hasta</label>
                                <input type="date" id="fechaHasta" class="form-input" value="2026-08-26">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Tipo de Reporte</label>
                                <select id="tipoReporte" class="form-input">
                                    <option value="diario">Ingresos Diarios</option>
                                    <option value="semanal">Ingresos Semanales</option>
                                    <option value="mensual">Ingresos Mensuales</option>
                                    <option value="vehiculos">Vehículos por Tipo</option>
                                </select>
                            </div>
                        </div>
                        <div class="filtros-acciones">
                            <button class="btn btn-pdf" onclick="exportarPDF()">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                EXPORTAR PDF
                            </button>
                            <button class="btn btn-excel" onclick="exportarExcel()">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                EXPORTAR EXCEL
                            </button>
                        </div>
                    </div>
                </div>

                <!-- TARJETAS DE ESTADÍSTICAS -->
                <div class="stats-grid-reportes">
                    <div class="stat-card-reporte">
    <div class="stat-header-reporte">
        <span class="stat-label-reporte">Total Recaudado</span>
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
        </svg>
    </div>
    <div class="stat-value-reporte">
        $2,450,000
        <span class="stat-cambio positive">+15%</span>
    </div>
</div>

                    <div class="stat-card-reporte">
                        <div class="stat-header-reporte">
                            <span class="stat-label-reporte">Promedio Diario</span>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        </div>
                        <div class="stat-value-reporte">
                            $350,000
                            <span class="stat-cambio positive">+8%</span>
                        </div>
                    </div>

                    <div class="stat-card-reporte">
                        <div class="stat-header-reporte">
                            <span class="stat-label-reporte">Vehículos Atendidos</span>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H5.24a2 2 0 0 0-1.8 1.1l-.8 1.63A6 6 0 0 0 2 12.42V16h2"/><circle cx="6.5" cy="16.5" r="2.5"/><circle cx="16.5" cy="16.5" r="2.5"/></svg>
                        </div>
                        <div class="stat-value-reporte">
                            482
                            <span class="stat-cambio positive">+12%</span>
                        </div>
                    </div>
                </div>

                <!-- GRÁFICO Y RESUMEN -->
                <div class="reportes-grid">
                    <!-- GRÁFICO DE BARRAS -->
                    <div class="card card-grande">
    <div class="card-header">
        <h2>Histórico de Ingresos Diarios (COP)</h2>
    </div>
    <div class="chart-container">
        <div class="bar-chart">
            <div class="bar-item">
                <div class="bar" style="height: 60%"></div>
                <span class="bar-label">Lun</span>
            </div>
            <div class="bar-item">
                <div class="bar" style="height: 75%"></div>
                <span class="bar-label">Mar</span>
            </div>
            <div class="bar-item">
                <div class="bar" style="height: 85%"></div>
                <span class="bar-label">Mié</span>
            </div>
            <div class="bar-item">
                <div class="bar" style="height: 50%"></div>
                <span class="bar-label">Jue</span>
            </div>
            <div class="bar-item">
                <div class="bar" style="height: 80%"></div>
                <span class="bar-label">Vie</span>
            </div>
            <div class="bar-item">
                <div class="bar" style="height: 95%"></div>
                <span class="bar-label">Sáb</span>
            </div>
            <div class="bar-item">
                <div class="bar" style="height: 45%"></div>
                <span class="bar-label">Dom</span>
            </div>
        </div>
    </div>
</div>

                    <!-- RESUMEN DE CATEGORÍAS -->
                    <div class="card card-pequena">
                        <div class="card-header">
                            <h2>Resumen de Categorías</h2>
                        </div>
                        <div class="categorias-list">
                            <div class="categoria-item">
                                <span class="categoria-nombre">Carros</span>
                                <span class="categoria-valor">$1,820,000</span>
                            </div>
                            <div class="categoria-item">
                                <span class="categoria-nombre">Motos</span>
                                <span class="categoria-valor">$480,000</span>
                            </div>
                            <div class="categoria-item">
                                <span class="categoria-nombre">Camionetas</span>
                                <span class="categoria-valor">$150,000</span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/reportes.js"></script>

    <!-- MODAL: Rango sin datos -->
    <div id="modalSinDatos" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Rango sin datos</h3>
            </div>
            <div class="modal-body">
                <p>No existen registros para este período.</p>
                <p class="modal-hint">Seleccione un rango de fechas diferente o verifique que haya ingresos registrados.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalSinDatos')">Entendido</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Fecha inválida -->
    <div id="modalFechaInvalida" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Fecha inválida</h3>
            </div>
            <div class="modal-body">
                <p>La fecha seleccionada no es válida.</p>
                <p class="modal-hint">No se puede seleccionar una fecha futura. Por favor corrija el rango de fechas.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalFechaInvalida')">Entendido</button>
            </div>
        </div>
    </div>

</body>
</html>
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
    <title>Auditoría del Sistema - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/auditoria.css">
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
                    <li><a href="ReservaServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Reservas</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
                    <li><a href="auditoria.jsp" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg> Auditoría</a></li>
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
                <h1 class="page-title">Auditoría del Sistema</h1>
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
                <!-- FILTROS -->
                <div class="card">
                    <div class="auditoria-filtros">
                        <div class="filtros-row">
                            <div class="form-group">
                                <label class="form-label">Usuario</label>
                                <select id="filtroUsuario" class="form-input">
                                    <option value="">Todos los usuarios</option>
                                    <option value="carlos">Carlos Mendoza</option>
                                    <option value="laura">Laura Beltrán</option>
                                    <option value="pedro">Pedro Gómez</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Rango de Fechas</label>
                                <select id="filtroFecha" class="form-input">
                                    <option value="hoy">Hoy (26/10/2026)</option>
                                    <option value="semana">Esta semana</option>
                                    <option value="mes">Este mes</option>
                                    <option value="personalizado">Personalizado</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Módulo / Acción</label>
                                <select id="filtroModulo" class="form-input">
                                    <option value="todos">Todos los módulos</option>
                                    <option value="ingreso">Ingreso</option>
                                    <option value="salida">Salida</option>
                                    <option value="tarifas">Tarifas</option>
                                    <option value="usuarios">Usuarios</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TABLA DE AUDITORÍA -->
                <div class="card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Fecha / Hora</th>
                                    <th>Usuario</th>
                                    <th>Acción</th>
                                    <th>Módulo</th>
                                    <th>Detalle</th>
                                    <th>IP</th>
                                </tr>
                            </thead>
                            <tbody id="tablaAuditoria">
                                <tr>
                                    <td>26/10/2026 - 15:30</td>
                                    <td><strong>Carlos Mendoza</strong></td>
                                    <td><span class="badge badge-accion-ingreso">Registrar Ingreso</span></td>
                                    <td>Ingreso</td>
                                    <td>Ingreso de vehículo con placa KLY-982</td>
                                    <td>192.168.1.45</td>
                                </tr>
                                <tr>
                                    <td>26/10/2026 - 15:15</td>
                                    <td><strong>Laura Beltrán</strong></td>
                                    <td><span class="badge badge-accion-salida">Registrar Salida</span></td>
                                    <td>Salida</td>
                                    <td>Salida y cobro procesado para ticket #TKT-10252</td>
                                    <td>192.168.1.48</td>
                                </tr>
                                <tr>
                                    <td>26/10/2026 - 14:10</td>
                                    <td><strong>Carlos Mendoza</strong></td>
                                    <td><span class="badge badge-accion-modificar">Modificar Tarifa</span></td>
                                    <td>Tarifas</td>
                                    <td>Cambio de tarifa por hora carro a $5,000</td>
                                    <td>192.168.1.45</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- PAGINACIÓN -->
                    <div class="paginacion">
                        <span class="paginacion-info">Mostrando 1-3 de 142 eventos</span>
                        <div class="paginacion-botones">
                            <button class="btn-pagina active">1</button>
                            <button class="btn-pagina">2</button>
                            <button class="btn-pagina">3</button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/auditoria.js"></script>

</body>
</html>
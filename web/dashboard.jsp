<%@ page import="modelo.Usuario" %>
<%
    // Obtenemos el usuario que guardamos en la sesión en el Servlet
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String nombre = usuario != null ? usuario.getNombre() : "Usuario";
    String rol = usuario != null ? usuario.getRol() : "Invitado";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard General - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/dashboard.css">
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
                    <li><a href="dashboard.jsp" class="active">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                        Dashboard
                    </a></li>
                    <li><a href="ingreso.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
                        Ingreso
                    </a></li>
                    <li><a href="salida.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                        Salida
                    </a></li>
                    <li><a href="tarifas.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                        Tarifas
                    </a></li>
                    <li><a href="cupos.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                        Cupos
                    </a></li>
                    <li><a href="usuarios.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        Usuarios
                    </a></li>
                    <li><a href="reportes.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        Reportes
                    </a></li>
                    <li><a href="auditoria.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        Auditoría
                    </a></li>
                    <li><a href="consulta.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        Consulta
                    </a></li>
                    <li><a href="incidentes.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                        Incidentes
                    </a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                        <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Cerrar Sesión
                </a>
            </div>
        </aside>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="main-content">
            
            <!-- HEADER -->
            <header class="navbar">
                <h1 class="page-title">Dashboard General</h1>
                <div class="navbar-right">
                    <button class="icon-btn" title="Notificaciones">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    </button>
                    <div class="user-info">
                        <div class="user-avatar">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        </div>
                        <div class="user-details">
                            <!-- AQUÍ ESTÁ LA MAGIA JSP: Muestra el nombre y rol reales -->
                            <span class="user-name"><%= nombre %></span>
                            <span class="user-role"><%= rol %></span>
                        </div>
                    </div>
                </div>
            </header>

            <!-- ÁREA DE CONTENIDO -->
            <main class="content-area">
                
                <!-- TARJETAS DE ESTADÍSTICAS -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Vehículos Hoy</span>
                            <div class="stat-icon blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H5.24a2 2 0 0 0-1.8 1.1l-.8 1.63A6 6 0 0 0 2 12.42V16h2"/><circle cx="6.5" cy="16.5" r="2.5"/><circle cx="16.5" cy="16.5" r="2.5"/></svg>
                            </div>
                        </div>
                        <div class="stat-value">142 <span class="stat-change positive">+12%</span></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Cupos Disponibles</span>
                            <div class="stat-icon blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                            </div>
                        </div>
                        <div class="stat-value">38/120</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Recaudado Diario</span>
                            <div class="stat-icon blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                            </div>
                        </div>
                        <div class="stat-value">$425,500</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-label">Incidentes</span>
                            <div class="stat-icon red">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                            </div>
                        </div>
                        <div class="stat-value">2</div>
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
                            <span class="legend-item"><span class="dot blue"></span> Disp</span>
                            <span class="legend-item"><span class="dot gray"></span> Ocup</span>
                            <span class="legend-item"><span class="dot yellow"></span> Res</span>
                        </div>
                        <div class="cupos-grid">
                            <!-- Fila 1 -->
                            <div class="cupos yellow">A-1</div>
                            <div class="cupos blue">A-2</div>
                            <div class="cupos blue">A-3</div>
                            <div class="cupos gray">A-4</div>
                            <div class="cupos blue">A-5</div>
                            <div class="cupos blue">A-6</div>
                            <div class="cupos gray">A-7</div>
                            <!-- Fila 2 -->
                            <div class="cupos yellow">A-8</div>
                            <div class="cupos blue">A-9</div>
                            <div class="cupos gray">A-10</div>
                            <div class="cupos blue">A-11</div>
                            <div class="cupos blue">A-12</div>
                            <div class="cupos gray">A-13</div>
                            <div class="cupos blue">A-14</div>
                            <!-- Fila 3 -->
                            <div class="cupos yellow">A-15</div>
                            <div class="cupos gray">A-16</div>
                            <div class="cupos blue">A-17</div>
                            <div class="cupos blue">A-18</div>
                            <div class="cupos gray">A-19</div>
                            <div class="cupos blue">A-20</div>
                            <div class="cupos blue">A-21</div>
                            <!-- Fila 4 -->
                            <div class="cupos yellow">A-22</div>
                            <div class="cupos blue">A-23</div>
                            <div class="cupos blue">A-24</div>
                        </div>
                    </div>

                    <!-- ACTIVIDAD RECIENTE -->
                    <div class="card card-small">
                        <div class="card-header">
                            <h2>Actividad Reciente</h2>
                        </div>
                        <div class="activity-list">
                            <div class="activity-item">
                                <span class="activity-dot blue"></span>
                                <div class="activity-content">
                                    <strong>Ingreso: Toyota Hilux (KLY-982)</strong>
                                    <span>Zona A-4 &middot; Hace 2 min</span>
                                </div>
                            </div>
                            <div class="activity-item">
                                <span class="activity-dot green"></span>
                                <div class="activity-content">
                                    <strong>Salida: Mazda 3 (GHB-112)</strong>
                                    <span>Pago: Tarjeta &middot; Hace 10 min</span>
                                </div>
                            </div>
                            <div class="activity-item">
                                <span class="activity-dot red"></span>
                                <div class="activity-content">
                                    <strong>Incidente: Lámpara apagada</strong>
                                    <span>Pasillo 2 &middot; Hace 14 min</span>
                                </div>
                            </div>
                            <div class="activity-item">
                                <span class="activity-dot blue"></span>
                                <div class="activity-content">
                                    <strong>Ingreso: Moto Yamaha (QWE-88F)</strong>
                                    <span>Zona M-12 &middot; Hace 14 min</span>
                                </div>
                            </div>
                        </div>                  </div>

                </div>

            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
</body>
</html>
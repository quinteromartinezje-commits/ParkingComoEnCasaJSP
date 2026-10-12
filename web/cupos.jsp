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
    <title>Control de Cupos - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/cupos.css">
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
                    <li><a href="cupos.jsp" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Cupos</a></li>
                    <li><a href="ReservaServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Reservas</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
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
                <h1 class="page-title">Control de Cupos y Mapa de Ocupación</h1>
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
                
                <!-- 1. ESTADÍSTICAS -->
                <div class="cupos-stats">
                    <div class="stat-card stat-disponible">
                        <div class="stat-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                        </div>
                        <div class="stat-content">
                            <span class="stat-label">Disponibles</span>
                            <span class="stat-value">62 Cupos</span>
                        </div>
                    </div>
                    <div class="stat-card stat-ocupado">
                        <div class="stat-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#dc3545" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="15" y1="9" x2="9" y2="15"/>
                                <line x1="9" y1="9" x2="15" y2="15"/>
                            </svg>
                        </div>
                        <div class="stat-content">
                            <span class="stat-label">Ocupados</span>
                            <span class="stat-value">58 Cupos</span>
                        </div>
                    </div>
                    <div class="stat-card stat-reservado">
                        <div class="stat-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                                <line x1="16" y1="2" x2="16" y2="6"/>
                                <line x1="8" y1="2" x2="8" y2="6"/>
                                <line x1="3" y1="10" x2="21" y2="10"/>
                            </svg>
                        </div>
                        <div class="stat-content">
                            <span class="stat-label">Reservados</span>
                            <span class="stat-value">8 Cupos</span>
                        </div>
                    </div>
                </div>

                <!-- 2. FILTROS Y BÚSQUEDA -->
                <div class="cupos-toolbar">
                    <div class="nivel-tabs">
                        <button class="nivel-tab">Piso 1</button>
                        <button class="nivel-tab active">Nivel / Piso 2</button>
                        <button class="nivel-tab">Piso 3 (Motos)</button>
                    </div>
                    <div class="search-cupo">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#54595d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" placeholder="Buscar Cupo" id="buscarCupo">
                    </div>
                </div>

                <!-- 3. MAPA DE CUPOS - Piso 1 -->
                <div class="card piso-mapa" id="mapa-piso-1">
                    <div class="card-header">
                        <h2>Distribución del Piso 1</h2>
                    </div>
                    <div class="cupos-grid">
                        <div class="cupo-card cupo-disponible" data-codigo="P1-1"><span class="cupo-codigo">P1-1</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P1-2"><span class="cupo-codigo">P1-2</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P1-3"><span class="cupo-codigo">P1-3</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P1-4"><span class="cupo-codigo">P1-4</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P1-5"><span class="cupo-codigo">P1-5</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-reservado" data-codigo="P1-6"><span class="cupo-codigo">P1-6</span><span class="cupo-estado">RES</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P1-7"><span class="cupo-codigo">P1-7</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P1-8"><span class="cupo-codigo">P1-8</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P1-9"><span class="cupo-codigo">P1-9</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P1-10"><span class="cupo-codigo">P1-10</span><span class="cupo-estado">DISP</span></div>
                    </div>
                </div>

                <!-- 3. MAPA DE CUPOS - Piso 2 (ACTIVO POR DEFECTO) -->
                <div class="card piso-mapa active" id="mapa-piso-2">
                    <div class="card-header">
                        <h2>Distribución del Piso 2</h2>
                    </div>
                    <div class="cupos-grid">
                        <div class="cupo-card cupo-reservado" data-codigo="P2-1"><span class="cupo-codigo">P2-1</span><span class="cupo-estado">RES</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-2"><span class="cupo-codigo">P2-2</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-3"><span class="cupo-codigo">P2-3</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-4"><span class="cupo-codigo">P2-4</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-5"><span class="cupo-codigo">P2-5</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-6"><span class="cupo-codigo">P2-6</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-7"><span class="cupo-codigo">P2-7</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-8"><span class="cupo-codigo">P2-8</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-9"><span class="cupo-codigo">P2-9</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-reservado" data-codigo="P2-10"><span class="cupo-codigo">P2-10</span><span class="cupo-estado">RES</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-11"><span class="cupo-codigo">P2-11</span><span class="cupo-estado">DISP</span></div>
                        
                        <div class="cupo-card cupo-disponible" data-codigo="P2-12"><span class="cupo-codigo">P2-12</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-13"><span class="cupo-codigo">P2-13</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-14"><span class="cupo-codigo">P2-14</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-15"><span class="cupo-codigo">P2-15</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-16"><span class="cupo-codigo">P2-16</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-17"><span class="cupo-codigo">P2-17</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-18"><span class="cupo-codigo">P2-18</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-reservado" data-codigo="P2-19"><span class="cupo-codigo">P2-19</span><span class="cupo-estado">RES</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-20"><span class="cupo-codigo">P2-20</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-21"><span class="cupo-codigo">P2-21</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-22"><span class="cupo-codigo">P2-22</span><span class="cupo-estado">DISP</span></div>
                        
                        <div class="cupo-card cupo-disponible" data-codigo="P2-23"><span class="cupo-codigo">P2-23</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-24"><span class="cupo-codigo">P2-24</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-25"><span class="cupo-codigo">P2-25</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-26"><span class="cupo-codigo">P2-26</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-27"><span class="cupo-codigo">P2-27</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-reservado" data-codigo="P2-28"><span class="cupo-codigo">P2-28</span><span class="cupo-estado">RES</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-29"><span class="cupo-codigo">P2-29</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-30"><span class="cupo-codigo">P2-30</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-31"><span class="cupo-codigo">P2-31</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-32"><span class="cupo-codigo">P2-32</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="P2-33"><span class="cupo-codigo">P2-33</span><span class="cupo-estado">OCUP</span></div>
                        
                        <div class="cupo-card cupo-disponible" data-codigo="P2-34"><span class="cupo-codigo">P2-34</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-35"><span class="cupo-codigo">P2-35</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="P2-36"><span class="cupo-codigo">P2-36</span><span class="cupo-estado">DISP</span></div>
                    </div>
                </div>

                <!-- 3. MAPA DE CUPOS - Piso 3 (Motos) -->
                <div class="card piso-mapa" id="mapa-piso-3">
                    <div class="card-header">
                        <h2>Distribución del Piso 3 (Motos)</h2>
                    </div>
                    <div class="cupos-grid">
                        <div class="cupo-card cupo-disponible" data-codigo="M-1"><span class="cupo-codigo">M-1</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="M-2"><span class="cupo-codigo">M-2</span><span class="cupo-estado">OCUP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="M-3"><span class="cupo-codigo">M-3</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="M-4"><span class="cupo-codigo">M-4</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-reservado" data-codigo="M-5"><span class="cupo-codigo">M-5</span><span class="cupo-estado">RES</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="M-6"><span class="cupo-codigo">M-6</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-disponible" data-codigo="M-7"><span class="cupo-codigo">M-7</span><span class="cupo-estado">DISP</span></div>
                        <div class="cupo-card cupo-ocupado" data-codigo="M-8"><span class="cupo-codigo">M-8</span><span class="cupo-estado">OCUP</span></div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script src="js/main.js"></script>
    <script src="js/cupos.js"></script>

    <!-- MODALES -->
    <div id="modalCeldaOcupada" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Celda ya ocupada</h3>
            </div>
            <div class="modal-body">
                <p id="mensajeCeldaOcupada">El cupo seleccionado ya está ocupado.</p>
                <p class="modal-hint">Seleccione otro cupo disponible o libere el cupo actual primero.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalCeldaOcupada')">Entendido</button>
            </div>
        </div>
    </div>

    <div id="modalTipoIncorrecto" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Tipo de vehículo incorrecto</h3>
            </div>
            <div class="modal-body">
                <p id="mensajeTipoIncorrecto">No se puede asignar este tipo de vehículo al cupo seleccionado.</p>
                <p class="modal-hint">Los cupos están designados específicamente para carros o motos según su tamaño.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalTipoIncorrecto')">Entendido</button>
            </div>
        </div>
    </div>

    <div id="modalAsignacionExitosa" class="modal-overlay">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
                <h3>Asignación exitosa</h3>
            </div>
            <div class="modal-body">
                <p id="mensajeAsignacionExitosa">El vehículo ha sido asignado correctamente.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalAsignacionExitosa')">Aceptar</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Asignar Vehículo -->
    <div id="modalAsignarVehiculo" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H5.24a2 2 0 0 0-1.8 1.1l-.8 1.63A6 6 0 0 0 2 12.42V16h2"/>
                    <circle cx="6.5" cy="16.5" r="2.5"/>
                    <circle cx="16.5" cy="16.5" r="2.5"/>
                </svg>
                <h3>Asignar vehículo al cupo <span id="cupoSeleccionado"></span></h3>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Tipo de vehículo</label>
                    <div class="radio-group horizontal">
                        <label class="radio-btn">
                            <input type="radio" name="tipoVehiculo" value="carro">
                            <span>Carro</span>
                        </label>
                        <label class="radio-btn">
                            <input type="radio" name="tipoVehiculo" value="moto">
                            <span>Moto</span>
                        </label>
                        <label class="radio-btn">
                            <input type="radio" name="tipoVehiculo" value="camioneta">
                            <span>Camioneta</span>
                        </label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Placa del vehículo</label>
                    <input type="text" id="placaVehiculo" class="form-input" placeholder="Ej: ABC-123" style="text-transform: uppercase;">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="cerrarModal('modalAsignarVehiculo')">Cancelar</button>
                <button class="btn btn-primary" onclick="confirmarAsignacion()">Asignar</button>
            </div>
        </div>
    </div>

</body>
</html>
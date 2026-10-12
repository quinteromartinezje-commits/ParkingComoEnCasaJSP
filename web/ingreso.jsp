<%@ page import="modelo.Usuario" %>
<%
    // 1. VERIFICACIÓN DE SEGURIDAD: Si no hay sesión, devuelve al login
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
    <title>Registro de Ingreso - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/ingreso.css">
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
                    <li><a href="dashboard.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                        Dashboard
                    </a></li>
                    <li><a href="ingreso.jsp" class="active">
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
                <h1 class="page-title">Registro de Ingreso</h1>
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

            <!-- ÁREA DE CONTENIDO -->
            <main class="content-area">
                <div class="ingreso-layout">
                    
                    <!-- COLUMNA IZQUIERDA: FORMULARIO -->
                    <div class="card">
                        <div class="card-header">
                            <h2>Nuevo Registro de Entrada</h2>
                        </div>
                        
                        <!-- Mensaje de error si el Servlet lo envía (Flujo Alternativo 1a del CU-07) -->
                        <% String errorPlaca = (String) request.getAttribute("errorPlaca"); %>
                        <% if (errorPlaca != null) { %>
                            <div style="background-color: rgba(220, 53, 69, 0.1); border: 1px solid var(--color-danger); color: var(--color-danger); padding: 12px 16px; border-radius: var(--border-radius); margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                <%= errorPlaca %>
                            </div>
                        <% } %>

                        <!-- Formulario conectado al Servlet -->
                        <form action="IngresoServlet" method="post" id="formIngreso" class="form-ingreso">
                            
                            <!-- Placa del Vehículo -->
                            <div class="form-group">
                                <label class="form-label">Placa del Vehículo *</label>
                                <div class="input-with-icon">
                                    <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H5.24a2 2 0 0 0-1.8 1.1l-.8 1.63A6 6 0 0 0 2 12.42V16h2"/>
                                        <circle cx="6.5" cy="16.5" r="2.5"/>
                                        <circle cx="16.5" cy="16.5" r="2.5"/>
                                    </svg>
                                    <input type="text" id="placa" name="placa" class="form-input" placeholder="ABC-123" maxlength="8" required style="text-transform: uppercase;">
                                </div>
                            </div>

                            <!-- Tipo de Vehículo -->
                            <div class="form-group">
                                <label class="form-label">Tipo de Vehículo *</label>
                                <div class="vehicle-buttons">
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Carro" required>
                                        Carro
                                    </label>
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Moto">
                                        Moto
                                    </label>
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Camioneta">
                                        Camioneta
                                    </label>
                                </div>
                            </div>

                            <!-- Fecha y Hora + Cupo (Se llenarán con JavaScript) -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Fecha y Hora</label>
                                    <div class="input-with-icon">
                                        <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                                            <line x1="16" y1="2" x2="16" y2="6"/>
                                            <line x1="8" y1="2" x2="8" y2="6"/>
                                            <line x1="3" y1="10" x2="21" y2="10"/>
                                        </svg>
                                        <input type="text" id="fechaHora" name="fechaHora" class="form-input" readonly>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Cupo Asignado</label>
                                    <div class="input-with-icon">
                                        <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="3" width="7" height="7"/>
                                            <rect x="14" y="3" width="7" height="7"/>
                                            <rect x="14" y="14" width="7" height="7"/>
                                            <rect x="3" y="14" width="7" height="7"/>
                                        </svg>
                                        <input type="text" id="cupo" name="cupo" class="form-input" placeholder="A-14 (Disponible)" readonly>
                                    </div>
                                </div>
                            </div>

                            <!-- Código de Ticket -->
                            <div class="form-group">
                                <div class="ticket-label">CÓDIGO DE TICKET GENERADO</div>
                                <div class="ticket-code-display" id="ticketCode">#TKT-2026-10254</div>
                            </div>

                            <!-- BOTÓN DE REGISTRO -->
                            <button type="submit" id="btnRegistrar" class="btn btn-primary btn-block">
                                + Registrar Ingreso
                            </button>
                        </form>
                    </div>

                    <!-- COLUMNA DERECHA: TABLA -->
                    <div class="card">
                        <div class="card-header">
                            <h2>Últimos Ingresos Registrados</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Placa</th>
                                        <th>Tipo</th>
                                        <th>Hora</th>
                                        <th>Zona</th>
                                        <th>Ticket</th>
                                    </tr>
                                </thead>
                                <tbody id="tablaIngresos">
                                    <tr>
                                        <td><strong>KLY-982</strong></td>
                                        <td><span class="badge badge-tipo">CAMIONETA</span></td>
                                        <td>15:28</td>
                                        <td><span class="badge badge-zona">A-4</span></td>
                                        <td>#TKT-10253</td>
                                    </tr>
                                    <tr>
                                        <td><strong>GHB-112</strong></td>
                                        <td><span class="badge badge-tipo">CARRO</span></td>
                                        <td>15:15</td>
                                        <td><span class="badge badge-zona">A-12</span></td>
                                        <td>#TKT-10252</td>
                                    </tr>
                                    <tr>
                                        <td><strong>QWE-88F</strong></td>
                                        <td><span class="badge badge-tipo">MOTO</span></td>
                                        <td>15:10</td>
                                        <td><span class="badge badge-zona">M-1</span></td>
                                        <td>#TKT-10251</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/ingreso.js"></script>

    <!-- ============================================
         MODALES 
         ============================================ -->
    
    <!-- MODAL 1: Placa ya registrada -->
    <div id="modalPlacaDuplicada" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Placa ya registrada</h3>
            </div>
            <div class="modal-body">
                <p>El vehículo con placa <strong id="placaDuplicada"></strong> ya se encuentra dentro del parqueadero.</p>
                <p>No se permite registrar un ingreso duplicado.</p>
                <p class="modal-hint">Si el vehículo salió sin registro, contacte al administrador.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="cerrarModal('modalPlacaDuplicada')">Cerrar</button>
                <button class="btn btn-primary" onclick="irAConsulta()">Ir a Consulta</button>
            </div>
        </div>
    </div>

    <!-- MODAL 2: Datos incompletos -->
    <div id="modalDatosIncompletos" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Datos incompletos</h3>
            </div>
            <div class="modal-body">
                <p id="mensajeIncompleto">Por favor complete todos los campos obligatorios.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalDatosIncompletos')">Entendido</button>
            </div>
        </div>
    </div>

    <!-- MODAL 3: Registro exitoso con tiquete -->
    <div id="modalExito" class="modal-overlay">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
                <h3>Ingreso registrado exitosamente</h3>
            </div>
            <div class="modal-body">
                <div class="tiquete-preview">
                    <div class="tiquete-header">
                        <strong>Parking Como en Casa</strong>
                        <span>Tiquete de Entrada</span>
                    </div>
                    <div class="tiquete-body">
                        <div class="tiquete-row">
                            <span class="tiquete-label">Placa:</span>
                            <span class="tiquete-value" id="tiquetePlaca"></span>
                        </div>
                        <div class="tiquete-row">
                            <span class="tiquete-label">Tipo:</span>
                            <span class="tiquete-value" id="tiqueteTipo"></span>
                        </div>
                        <div class="tiquete-row">
                            <span class="tiquete-label">Cupo:</span>
                            <span class="tiquete-value" id="tiqueteCupo"></span>
                        </div>
                        <div class="tiquete-row">
                            <span class="tiquete-label">Hora entrada:</span>
                            <span class="tiquete-value" id="tiqueteHora"></span>
                        </div>
                        <div class="tiquete-row tiquete-ticket">
                            <span class="tiquete-label">Ticket:</span>
                            <span class="tiquete-value" id="tiqueteCodigo"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="cerrarModal('modalExito')">Cerrar</button>
                <button class="btn btn-primary" onclick="imprimirTiquete()">Imprimir Tiquete</button>
            </div>
        </div>
    </div>

    <!-- Script mínimo para asegurar mayúsculas en la placa y fecha/hora automática -->
    <script>
        // 1. Forzar mayúsculas en la placa
        document.getElementById('placa').addEventListener('input', function (e) {
            e.target.value = e.target.value.toUpperCase();
        });

        // 2. Llenar fecha y hora actual automáticamente al cargar
        document.addEventListener('DOMContentLoaded', function() {
            const ahora = new Date();
            const fechaHoraStr = ahora.toLocaleString('es-CO', { 
                year: 'numeric', month: '2-digit', day: '2-digit', 
                hour: '2-digit', minute: '2-digit' 
            });
            document.getElementById('fechaHora').value = fechaHoraStr;
        });
    </script>
</body>
</html>
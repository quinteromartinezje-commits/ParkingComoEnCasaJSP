<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Ingreso" %>
<%@ page import="util.Texto" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Los cupos libres y los últimos ingresos los prepara IngresoServlet (GET).
    List<String> cuposLibres = (List<String>) request.getAttribute("cuposLibres");
    if (cuposLibres == null) {
        response.sendRedirect("IngresoServlet");
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
    
    <!-- Estilos para validación personalizada y botones de tipo -->
    <style>
        /* Mensajes de error personalizados */
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 4px;
            display: none;
            font-weight: 500;
        }
        .error-message.visible {
            display: block;
        }
        
        /* Borde rojo en campos con error */
        .form-input.error {
            border-color: #dc3545 !important;
        }
        
        /* Botones de tipo de vehículo - Estilos para que se vean marcados */
        .vehicle-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        .vehicle-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border: 2px solid #ced4da;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 14px;
            font-weight: 500;
            color: #54595d;
        }
        .vehicle-btn:hover {
            border-color: #3366cc;
            background-color: rgba(51, 102, 204, 0.05);
        }
        .vehicle-btn input[type="radio"] {
            margin: 0;
            cursor: pointer;
            accent-color: #3366cc;
        }
        /* Cuando el radio está seleccionado, el label se resalta */
        .vehicle-btn.selected {
            border-color: #3366cc;
            background-color: rgba(51, 102, 204, 0.1);
            color: #3366cc;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="sidebar-logo">
                <img src="img/logoblanco.png" alt="Logo" class="sidebar-logo-img">
                <span class="sidebar-title">Parking Como en Casa</span>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="DashboardServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Dashboard</a></li>
                    <li><a href="IngresoServlet" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg> Ingreso</a></li>
                    <li><a href="SalidaServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Salida</a></li>
                    <li><a href="ReservaServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Reservas</a></li>
                    <li><a href="tarifas.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg> Tarifas</a></li>
                    <li><a href="cupos.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Cupos</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
                    <li><a href="auditoria.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg> Auditoría</a></li>
                    <li><a href="consulta.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg> Consulta</a></li>
                    <li><a href="incidentes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> Incidentes</a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-btn"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Cerrar Sesión</a>
            </div>
        </aside>

        <div class="main-content">
            <header class="navbar">
                <h1 class="page-title">Registro de Ingreso</h1>
                <div class="navbar-right">
                    <button class="icon-btn" title="Notificaciones"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg></button>
                    <div class="user-info">
                        <div class="user-avatar"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
                        <div class="user-details">
                            <span class="user-name"><%= nombre %></span>
                            <span class="user-role"><%= rol %></span>
                        </div>
                    </div>
                </div>
            </header>

                        <main class="content-area">
                
                <!-- CUADRO ROJO DE DEPURACIÓN (Solo aparece si hay error) -->
                <% String errorDebug = (String) request.getAttribute("errorDebug"); %>
                <% if (errorDebug != null) { %>
                    <div style="background-color: #dc3545; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; font-size: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                        ?? ERROR DE DEPURACIÓN:<br><br>
                        <%= errorDebug %>
                    </div>
                <% } %>

                <div class="ingreso-layout">
                    <div class="card">
                        <div class="card-header"><h2>Nuevo Registro de Entrada</h2></div>
                        
                        <!-- Formulario SIN required (validación personalizada con JS) -->
                        <form action="IngresoServlet" method="post" id="formIngreso" class="form-ingreso" novalidate>
                            
                            <!-- Placa del Vehículo -->
                            <div class="form-group">
                                <label class="form-label">Placa del Vehículo *</label>
                                <div class="input-with-icon">
                                    <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H5.24a2 2 0 0 0-1.8 1.1l-.8 1.63A6 6 0 0 0 2 12.42V16h2"/><circle cx="6.5" cy="16.5" r="2.5"/><circle cx="16.5" cy="16.5" r="2.5"/></svg>
                                    <input type="text" id="placa" name="placa" class="form-input" placeholder="ABC-123" maxlength="8" style="text-transform: uppercase;">
                                </div>
                                <span class="error-message" id="error-placa">Por favor, ingresa la placa del vehículo</span>
                            </div>

                            <!-- Tipo de Vehículo -->
                            <div class="form-group">
                                <label class="form-label">Tipo de Vehículo *</label>
                                <div class="vehicle-buttons">
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Carro"> Carro
                                    </label>
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Moto"> Moto
                                    </label>
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Camioneta"> Camioneta
                                    </label>
                                </div>
                                <span class="error-message" id="error-tipo">Por favor, selecciona el tipo de vehículo</span>
                            </div>

                            <!-- Fecha y Hora + Cupo -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Fecha y Hora</label>
                                    <div class="input-with-icon">
                                        <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                        <input type="text" id="fechaHora" name="fechaHora" class="form-input" readonly>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Cupo Asignado *</label>
                                    <div class="input-with-icon">
                                        <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                                        <select id="cupo" name="cupo" class="form-input" style="cursor: pointer;">
                                            <% if (cuposLibres.isEmpty()) { %>
                                                <option value="" disabled selected>No hay cupos disponibles</option>
                                            <% } else { %>
                                                <option value="" disabled selected>Seleccionar cupo disponible</option>
                                                <% for (String c : cuposLibres) { %>
                                                    <option value="<%= Texto.escapar(c) %>"><%= Texto.escapar(c) %></option>
                                                <% } %>
                                            <% } %>
                                        </select>
                                    </div>
                                    <span class="error-message" id="error-cupo">Por favor, selecciona un cupo</span>
                                </div>
                            </div>

                            <button type="submit" id="btnRegistrar" class="btn btn-primary btn-block">+ Registrar Ingreso</button>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header"><h2>Últimos Ingresos Registrados</h2></div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr><th>Placa</th><th>Tipo</th><th>Hora</th><th>Zona</th><th>Ticket</th></tr>
                                </thead>
                                <tbody id="tablaIngresos">
                                    <% 
                                        List<Ingreso> lista = (List<Ingreso>) request.getAttribute("listaIngresos");
                                        if (lista != null && !lista.isEmpty()) {
                                            for (Ingreso ing : lista) { 
                                    %>
                                        <tr>
                                            <td><strong><%= Texto.escapar(ing.getPlaca()) %></strong></td>
                                            <td><span class="badge badge-tipo"><%= ing.getTipo().toUpperCase() %></span></td>
                                            <td><%= ing.getFechaHora() %></td>
                                            <td><span class="badge badge-zona"><%= ing.getCupo() %></span></td>
                                            <td><%= ing.getTicket() %></td>
                                        </tr>
                                    <% 
                                            } 
                                        } else { 
                                    %>
                                        <tr><td colspan="5" style="text-align: center; color: #7f8c8d;">Aún no hay ingresos registrados.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- MODALES -->
    <div id="modalPlacaDuplicada" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Placa ya registrada</h3>
            </div>
            <div class="modal-body">
                <p>El vehículo con placa <strong id="placaDuplicada"></strong> ya se encuentra dentro del parqueadero.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="cerrarModal('modalPlacaDuplicada')">Cerrar</button
            </div>
        </div>
    </div>

    <div id="modalCupoOcupado" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Cupo no disponible</h3>
            </div>
            <div class="modal-body">
                <p>El cupo <strong id="cupoNoDisponible"></strong> ya está <span id="estadoCupo"></span>. Por favor elige otro cupo de la lista.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="cerrarModal('modalCupoOcupado')">Cerrar</button>
            </div>
        </div>
    </div>

    <div id="modalExito" class="modal-overlay">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <h3>Ingreso registrado exitosamente</h3>
            </div>
            <div class="modal-body">
                <div class="tiquete-preview">
                    <div class="tiquete-header"><strong>Parking Como en Casa</strong><span>Tiquete de Entrada</span></div>
                    <div class="tiquete-body">
                        <div class="tiquete-row"><span class="tiquete-label">Placa:</span><span class="tiquete-value" id="tiquetePlaca"></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Tipo:</span><span class="tiquete-value" id="tiqueteTipo"></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Cupo:</span><span class="tiquete-value" id="tiqueteCupo"></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Hora entrada:</span><span class="tiquete-value" id="tiqueteHora"></span></div>
                        <div class="tiquete-row tiquete-ticket"><span class="tiquete-label">Ticket:</span><span class="tiquete-value" id="tiqueteCodigo"></span></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="cerrarModal('modalExito')">Cerrar</button>
                <button class="btn btn-primary" onclick="imprimirTiquete()">Imprimir Tiquete</button>
            </div>
        </div>
    </div>

    <script src="js/ingreso.js"></script>
    
    <!-- Script para activar modales desde el servidor -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            <% if ("true".equals(request.getAttribute("modalExito"))) { %>
                document.getElementById('modalExito').classList.add('active');
                document.getElementById('tiquetePlaca').textContent = '<%= request.getAttribute("tPlaca") != null ? request.getAttribute("tPlaca") : "" %>';
                document.getElementById('tiqueteTipo').textContent = '<%= request.getAttribute("tTipo") != null ? request.getAttribute("tTipo") : "" %>';
                document.getElementById('tiqueteCupo').textContent = '<%= request.getAttribute("tCupo") != null ? request.getAttribute("tCupo") : "" %>';
                document.getElementById('tiqueteHora').textContent = '<%= request.getAttribute("tHora") != null ? request.getAttribute("tHora") : "" %>';
                document.getElementById('tiqueteCodigo').textContent = '<%= request.getAttribute("tTicket") != null ? request.getAttribute("tTicket") : "" %>';
            <% } %>
            <% if ("true".equals(request.getAttribute("modalCupo"))) { %>
                document.getElementById('modalCupoOcupado').classList.add('active');
                document.getElementById('cupoNoDisponible').textContent = '<%= Texto.escapar((String) request.getAttribute("cupoNoDisponible")) %>';
                document.getElementById('estadoCupo').textContent = '<%= Texto.escapar((String) request.getAttribute("estadoCupo")) %>';
            <% } %>
            <% if ("true".equals(request.getAttribute("modalError"))) { %>
                document.getElementById('modalPlacaDuplicada').classList.add('active');
                document.getElementById('placaDuplicada').textContent = '<%= request.getAttribute("placaDuplicada") != null ? request.getAttribute("placaDuplicada") : "" %>';
            <% } %>
        });
    </script>
</body>
</html>
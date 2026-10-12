<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Reserva" %>
<%@ page import="util.Texto" %>
<%
    // Si no hay sesión iniciada, volvemos al login
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nombre = usuario.getNombre();
    String rol = usuario.getRol();

    // Los datos los prepara ReservaServlet (GET). Si abren reservas.jsp directo, pasan primero por el servlet.
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    if (reservas == null) {
        response.sendRedirect("ReservaServlet");
        return;
    }
    List<String> cuposLibres = (List<String>) request.getAttribute("cuposLibres");
    List<String> tipos = (List<String>) request.getAttribute("tipos");
    List<String> metodos = (List<String>) request.getAttribute("metodos");
    String mensajeOk = (String) request.getAttribute("mensajeOk");
    String mensajeError = (String) request.getAttribute("mensajeError");

    // Si hubo un error, se vuelven a mostrar los datos que la persona había escrito
    String vNombre = Texto.escapar(request.getParameter("nombre"));
    String vDocumento = Texto.escapar(request.getParameter("documento"));
    String vTelefono = Texto.escapar(request.getParameter("telefono"));
    String vCorreo = Texto.escapar(request.getParameter("correo"));
    String vPlaca = Texto.escapar(request.getParameter("placa"));
    String vValor = Texto.escapar(request.getParameter("valor"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservas - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/ingreso.css">
    <link rel="stylesheet" href="css/mensajes.css">
    <link rel="stylesheet" href="css/reservas.css">
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
                    <li><a href="IngresoServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg> Ingreso</a></li>
                    <li><a href="SalidaServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Salida</a></li>
                    <li><a href="ReservaServlet" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Reservas</a></li>
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
                <h1 class="page-title">Reservas de Cupos</h1>
                <div class="navbar-right">
                    <button class="icon-btn" title="Notificaciones"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg></button>
                    <div class="user-info">
                        <div class="user-avatar"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
                        <div class="user-details">
                            <span class="user-name"><%= Texto.escapar(nombre) %></span>
                            <span class="user-role"><%= Texto.escapar(rol) %></span>
                        </div>
                    </div>
                </div>
            </header>

            <main class="content-area">

                <% if (mensajeOk != null) { %>
                    <div class="msg msg-ok"><%= Texto.escapar(mensajeOk) %></div>
                <% } %>
                <% if (mensajeError != null) { %>
                    <div class="msg msg-error"><%= Texto.escapar(mensajeError) %></div>
                <% } %>

                <div class="ingreso-layout">

                    <!-- FORMULARIO (método POST) -->
                    <div class="card">
                        <div class="card-header"><h2>Nueva Reserva</h2></div>

                        <form action="ReservaServlet" method="post" class="form-ingreso" id="formReserva">
                            <input type="hidden" name="accion" value="crear">

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="nombre">Nombre completo *</label>
                                    <input type="text" id="nombre" name="nombre" class="form-input" maxlength="150" value="<%= vNombre %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="documento">Documento *</label>
                                    <input type="text" id="documento" name="documento" class="form-input" maxlength="20" value="<%= vDocumento %>" required>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="telefono">Teléfono</label>
                                    <input type="text" id="telefono" name="telefono" class="form-input" maxlength="20" value="<%= vTelefono %>">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="correo">Correo</label>
                                    <input type="email" id="correo" name="correo" class="form-input" maxlength="100" value="<%= vCorreo %>">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="placa">Placa *</label>
                                    <input type="text" id="placa" name="placa" class="form-input" maxlength="10" placeholder="ABC-123" style="text-transform: uppercase;" value="<%= vPlaca %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="tipo">Tipo de vehículo *</label>
                                    <select id="tipo" name="tipo" class="form-input" required>
                                        <% if (tipos != null) { for (String t : tipos) { %>
                                            <option value="<%= Texto.escapar(t) %>"><%= Texto.escapar(t) %></option>
                                        <% } } %>
                                    </select>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="cupo">Cupo a reservar *</label>
                                    <select id="cupo" name="cupo" class="form-input" required>
                                        <% if (cuposLibres == null || cuposLibres.isEmpty()) { %>
                                            <option value="" disabled selected>No hay cupos disponibles</option>
                                        <% } else { %>
                                            <option value="" disabled selected>Seleccionar cupo</option>
                                            <% for (String c : cuposLibres) { %>
                                                <option value="<%= Texto.escapar(c) %>"><%= Texto.escapar(c) %></option>
                                            <% } %>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="valor">Valor mensualidad (COP) *</label>
                                    <input type="number" id="valor" name="valor" class="form-input" min="1" step="1" placeholder="150000" value="<%= vValor %>" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="medioPago">Medio de pago *</label>
                                <select id="medioPago" name="medioPago" class="form-input" required>
                                    <% if (metodos != null) { for (String m : metodos) { %>
                                        <option value="<%= Texto.escapar(m) %>"><%= Texto.escapar(m) %></option>
                                    <% } } %>
                                </select>
                            </div>

                            <p class="form-hint">La reserva dura un mes desde hoy. El cupo queda en amarillo en el dashboard.</p>
                            <button type="submit" class="btn btn-primary btn-block">+ Guardar Reserva</button>
                        </form>
                    </div>

                    <!-- LISTA DE RESERVAS ACTIVAS -->
                    <div class="card">
                        <div class="card-header"><h2>Reservas Activas (<%= reservas.size() %>)</h2></div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr><th>Cliente</th><th>Placa</th><th>Cupo</th><th>Vigencia</th><th>Valor</th><th></th></tr>
                                </thead>
                                <tbody>
                                    <% if (reservas.isEmpty()) { %>
                                        <tr><td colspan="6" style="text-align: center; color: #7f8c8d;">Aún no hay reservas activas.</td></tr>
                                    <% } else {
                                           for (Reserva r : reservas) { %>
                                        <tr>
                                            <td><strong><%= Texto.escapar(r.getCliente()) %></strong><br><small><%= Texto.escapar(r.getDocumento()) %></small></td>
                                            <td><%= Texto.escapar(r.getPlaca()) %></td>
                                            <td><span class="badge badge-zona"><%= Texto.escapar(r.getCupo()) %></span></td>
                                            <td><small><%= r.getFechaInicio() %><br>al <%= r.getFechaFin() %></small></td>
                                            <td><%= Texto.dinero(r.getValor()) %></td>
                                            <td><button type="button" class="btn btn-secondary btn-mini"
                                                        onclick="pedirCancelar(<%= r.getId() %>, '<%= Texto.escapar(r.getPlaca()) %>')">Cancelar</button></td>
                                        </tr>
                                    <%     }
                                       } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- MODAL: confirmar cancelación (el formulario también usa POST) -->
    <div id="modalCancelarReserva" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Cancelar reserva</h3>
            </div>
            <form action="ReservaServlet" method="post">
                <input type="hidden" name="accion" value="cancelar">
                <input type="hidden" name="idReserva" id="idReservaCancelar" value="">
                <div class="modal-body">
                    <p>¿Seguro que deseas cancelar la reserva de la placa <strong id="placaCancelar"></strong>?</p>
                    <p class="modal-hint">El cupo quedará disponible otra vez.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="cerrarModal('modalCancelarReserva')">No, volver</button>
                    <button type="submit" class="btn btn-danger">Sí, cancelar reserva</button>
                </div>
            </form>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script>
        // Abre el modal y le pasa el número de la reserva
        function pedirCancelar(id, placa) {
            document.getElementById('idReservaCancelar').value = id;
            document.getElementById('placaCancelar').textContent = placa;
            abrirModal('modalCancelarReserva');
        }
        // La placa siempre en mayúsculas
        document.getElementById('placa').addEventListener('input', function (e) {
            e.target.value = e.target.value.toUpperCase();
        });
    </script>
</body>
</html>

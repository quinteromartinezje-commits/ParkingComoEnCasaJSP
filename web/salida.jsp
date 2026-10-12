<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Salida" %>
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

    // Datos que prepara SalidaServlet
    Salida detalle = (Salida) request.getAttribute("detalle");        // vehículo encontrado (GET)
    Salida salidaOk = (Salida) request.getAttribute("salidaOk");      // salida ya registrada (POST)
    String medioPagoOk = (String) request.getAttribute("medioPagoOk");
    String mensajeError = (String) request.getAttribute("mensajeError");
    String textoBuscado = (String) request.getAttribute("textoBuscado");
    boolean hayDetalle = (detalle != null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Salida - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/salida.css">
    <link rel="stylesheet" href="css/mensajes.css">
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
                    <li><a href="SalidaServlet" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Salida</a></li>
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
                <h1 class="page-title">Registro de Salida</h1>
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

                <% if (mensajeError != null) { %>
                    <div class="msg msg-error"><%= Texto.escapar(mensajeError) %></div>
                <% } %>

                <div class="salida-layout">
                    <!-- COLUMNA IZQUIERDA -->
                    <div class="salida-columna-izquierda">

                        <!-- BÚSQUEDA: formulario con método GET -->
                        <div class="card">
                            <div class="card-header"><h2>Búsqueda de Registro</h2></div>
                            <form action="SalidaServlet" method="get" class="search-box" id="formBuscar">
                                <div class="search-input-wrapper">
                                    <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                    <input type="text" id="buscarPlaca" name="buscar" placeholder="Ingrese placa o número de ticket" maxlength="12"
                                           value="<%= Texto.escapar(textoBuscado) %>">
                                </div>
                                <button type="submit" id="btnBuscar" class="btn btn-primary btn-search" title="Buscar">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                </button>
                            </form>
                            <p class="search-hint">Ingrese la placa del vehículo o número de ticket para el cálculo automático de tarifa.</p>
                        </div>

                        <!-- DETALLE DE ESTADÍA -->
                        <div class="card" id="cardDetalle">
                            <div class="card-header"><h2>Detalle de Estadía</h2></div>
                            <div class="detalle-grid">
                                <div class="detalle-row">
                                    <span class="detalle-label">Placa</span>
                                    <span class="detalle-value placa" id="detallePlaca"><%= hayDetalle ? Texto.escapar(detalle.getPlaca()) : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Tipo de Vehículo</span>
                                    <span class="detalle-value" id="detalleTipo"><%= hayDetalle ? Texto.escapar(detalle.getTipo()) : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Ticket Asociado</span>
                                    <span class="detalle-value ticket" id="detalleTicket"><%= hayDetalle ? "#" + detalle.getTicket() : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Cupo</span>
                                    <span class="detalle-value" id="detalleCupo"><%= hayDetalle && detalle.getCupo() != null ? Texto.escapar(detalle.getCupo()) : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Hora de Ingreso</span>
                                    <span class="detalle-value" id="detalleHoraIngreso"><%= hayDetalle ? detalle.getHoraIngreso() : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Hora de Salida (Estimada)</span>
                                    <span class="detalle-value" id="detalleHoraSalida"><%= hayDetalle ? detalle.getHoraSalida() : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Tiempo Transcurrido</span>
                                    <span class="detalle-value highlight" id="detalleTiempo"><%= hayDetalle ? detalle.getTiempoTexto() : "-" %></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- COLUMNA DERECHA -->
                    <div class="salida-columna-derecha">
                        <!-- LIQUIDACIÓN: formulario con método POST -->
                        <form action="SalidaServlet" method="post" id="formSalida">
                        <input type="hidden" name="idRegistro" value="<%= hayDetalle ? detalle.getIdRegistro() : "" %>">
                        <input type="hidden" name="medioPago" id="medioPago" value="Efectivo">

                        <div class="card" id="cardLiquidacion">
                            <div class="card-header"><h2>Liquidación e Importe</h2></div>
                            <div class="liquidacion-grid">
                                <div class="liquidacion-row">
                                    <span class="liquidacion-label">Tarifa Base (primera hora o fracción)</span>
                                    <span class="liquidacion-value" id="liqTarifaBase"><%= hayDetalle ? Texto.dinero(detalle.getTarifaHora()) : "$0" %></span>
                                </div>
                                <div class="liquidacion-row">
                                    <span class="liquidacion-label">Horas Adicionales (<span id="liqFracciones"><%= hayDetalle ? detalle.getHorasAdicionales() : 0 %></span> x <%= hayDetalle ? Texto.dinero(detalle.getTarifaHora()) : "$0" %>)</span>
                                    <span class="liquidacion-value" id="liqFraccionesTotal"><%= hayDetalle ? Texto.dinero(detalle.getTotalAdicionales()) : "$0" %></span>
                                </div>
                                <div class="liquidacion-row total">
                                    <span class="liquidacion-label">Total a Pagar</span>
                                    <span class="liquidacion-value total-amount" id="liqTotal"><%= hayDetalle ? Texto.dinero(detalle.getTotal()) : "$0" %></span>
                                </div>
                            </div>

                            <!-- MEDIO DE PAGO -->
                            <div class="medio-pago-section">
                                <h3 class="medio-pago-title">Medio de Pago</h3>
                                <div class="medio-pago-buttons">
                                    <button type="button" class="medio-pago-btn active" data-medio="Efectivo">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                                        Efectivo
                                    </button>
                                    <button type="button" class="medio-pago-btn" data-medio="Tarjeta">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                                        Tarjeta
                                    </button>
                                    <button type="button" class="medio-pago-btn" data-medio="QR/Transferencia">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                                        QR / Transferencia
                                    </button>
                                </div>
                            </div>

                            <!-- BOTONES -->
                            <div class="action-buttons">
                                <button type="submit" id="btnCompletar" class="btn btn-primary btn-large" <%= hayDetalle ? "" : "disabled" %>>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                                    Completar Pago y Registrar Salida
                                </button>
                                <button type="button" id="btnCancelar" class="btn btn-secondary btn-large">Cancelar</button>
                            </div>
                        </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- MODALES -->

    <!-- MODAL: Vehículo no encontrado (se abre desde el servidor) -->
    <div id="modalNoEncontrado" class="modal-overlay <%= "true".equals(request.getAttribute("noEncontrado")) ? "active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Vehículo no encontrado</h3>
            </div>
            <div class="modal-body">
                <p>No se encontró ningún vehículo dentro del parqueadero con la placa o ticket ingresado.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="cerrarModal('modalNoEncontrado')">Entendido</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Campo vacío (se abre desde el servidor o desde el navegador) -->
    <div id="modalCampoVacio" class="modal-overlay <%= "true".equals(request.getAttribute("campoVacio")) ? "active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Campo vacío</h3>
            </div>
            <div class="modal-body">
                <p>Por favor ingrese una placa o número de ticket para buscar el registro.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="cerrarModal('modalCampoVacio')">Entendido</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Salida registrada (datos reales del servidor) -->
    <div id="modalSalidaExitosa" class="modal-overlay <%= salidaOk != null ? "active" : "" %>">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <h3>Salida registrada exitosamente</h3>
            </div>
            <div class="modal-body">
                <% if (salidaOk != null) { %>
                <div class="tiquete-preview">
                    <div class="tiquete-header">
                        <strong>Parking Como en Casa</strong>
                        <span>Tiquete de Salida</span>
                    </div>
                    <div class="tiquete-body">
                        <div class="tiquete-row"><span class="tiquete-label">Placa:</span><span class="tiquete-value"><%= Texto.escapar(salidaOk.getPlaca()) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Tiempo:</span><span class="tiquete-value"><%= salidaOk.getTiempoTexto() %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Hora Salida:</span><span class="tiquete-value"><%= salidaOk.getHoraSalida() %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Total Pagado:</span><span class="tiquete-value"><%= Texto.dinero(salidaOk.getTotal()) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Medio de Pago:</span><span class="tiquete-value"><%= Texto.escapar(medioPagoOk) %></span></div>
                        <div class="tiquete-row tiquete-ticket"><span class="tiquete-label">Cupo Liberado:</span><span class="tiquete-value"><%= salidaOk.getCupo() != null ? Texto.escapar(salidaOk.getCupo()) : "-" %></span></div>
                    </div>
                </div>
                <% } %>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="cerrarModal('modalSalidaExitosa')">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="imprimirTiqueteSalida()">Imprimir</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Confirmar cancelación -->
    <div id="modalConfirmarCancelacion" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Confirmar cancelación</h3>
            </div>
            <div class="modal-body">
                <p>¿Está seguro de cancelar el registro de salida?</p>
                <p class="modal-hint">Los datos mostrados se perderán y deberá iniciar la búsqueda nuevamente.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="cerrarModal('modalConfirmarCancelacion')">No, continuar</button>
                <button type="button" class="btn btn-danger" onclick="confirmarCancelacion()">Sí, cancelar salida</button>
            </div>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/salida.js"></script>
</body>
</html>

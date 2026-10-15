<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.Salida" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "salida";
    String tituloPagina = "Registro de Salida";

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
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">

        <%@ include file="menu.jspf" %>

        <div class="main-content">

            <%@ include file="cabecera.jspf" %>

            <main class="content-area">

                <% if (mensajeError != null) { %>
                    <div class="msg msg-error"><%= ver(mensajeError) %></div>
                <% } %>

                <div class="salida-layout">
                    <!-- COLUMNA IZQUIERDA -->
                    <div class="salida-columna-izquierda">

                        <!-- BÚSQUEDA: formulario con método GET -->
                        <div class="card">
                            <div class="card-header"><h2>Búsqueda de Registro</h2></div>
                            <form action="SalidaServlet" method="get" class="search-box">
                                <div class="search-input-wrapper">
                                    <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                    <input type="text" id="buscarPlaca" name="buscar" class="mayusculas" required placeholder="Ingrese placa o número de ticket" maxlength="12"
                                           value="<%= ver(textoBuscado) %>">
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
                                    <span class="detalle-value placa" id="detallePlaca"><%= hayDetalle ? ver(detalle.getPlaca()) : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Tipo de Vehículo</span>
                                    <span class="detalle-value" id="detalleTipo"><%= hayDetalle ? ver(detalle.getTipo()) : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Ticket Asociado</span>
                                    <span class="detalle-value ticket" id="detalleTicket"><%= hayDetalle ? "#" + detalle.getTicket() : "-" %></span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Cupo</span>
                                    <span class="detalle-value" id="detalleCupo"><%= hayDetalle && detalle.getCupo() != null ? ver(detalle.getCupo()) : "-" %></span>
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
                        <form action="SalidaServlet" method="post">
                        <input type="hidden" name="idRegistro" value="<%= hayDetalle ? detalle.getIdRegistro() : "" %>">
                        
                        <div class="card" id="cardLiquidacion">
                            <div class="card-header"><h2>Liquidación e Importe</h2></div>
                            <div class="liquidacion-grid">
                                <div class="liquidacion-row">
                                    <span class="liquidacion-label">Tarifa Base (primera hora o fracción)</span>
                                    <span class="liquidacion-value" id="liqTarifaBase"><%= hayDetalle ? plata(detalle.getTarifaHora()) : "$0" %></span>
                                </div>
                                <div class="liquidacion-row">
                                    <span class="liquidacion-label">Horas Adicionales (<span id="liqFracciones"><%= hayDetalle ? detalle.getHorasAdicionales() : 0 %></span> x <%= hayDetalle ? plata(detalle.getTarifaHora()) : "$0" %>)</span>
                                    <span class="liquidacion-value" id="liqFraccionesTotal"><%= hayDetalle ? plata(detalle.getTotalAdicionales()) : "$0" %></span>
                                </div>
                                <div class="liquidacion-row total">
                                    <span class="liquidacion-label">Total a Pagar</span>
                                    <span class="liquidacion-value total-amount" id="liqTotal"><%= hayDetalle ? plata(detalle.getTotal()) : "$0" %></span>
                                </div>
                            </div>

                            <!-- MEDIO DE PAGO -->
                            <div class="medio-pago-section">
                                <h3 class="medio-pago-title">Medio de Pago</h3>
                                <div class="medio-pago-buttons">
                                    <label class="medio-pago-btn"><input type="radio" name="medioPago" value="Efectivo" checked>
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                                        Efectivo</label>
                                    <label class="medio-pago-btn"><input type="radio" name="medioPago" value="Tarjeta">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                                        Tarjeta</label>
                                    <label class="medio-pago-btn"><input type="radio" name="medioPago" value="Transferencia">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                                        QR / Transferencia</label>
                                </div>
                            </div>
                            <!-- [CU-04] SECCIÓN DINÁMICA: CONTROL DE EFECTIVO -->
                            <div id="seccionEfectivo" style="margin-top: 20px; padding: 15px; background: rgba(0,0,0,0.02); border-radius: 8px; border: 1px dashed #ccc;">
                                <input type="hidden" name="totalCobro" value="<%= hayDetalle ? detalle.getTotal() : 0.0 %>">
                                <input type="hidden" name="placaVehiculo" value="<%= hayDetalle ? detalle.getPlaca() : "" %>">
                                
                                <div class="form-group" style="margin-bottom: 12px;">
                                    <label for="montoRecibido" style="display:block; margin-bottom: 6px; font-weight: bold; color: #333;">Monto Recibido ($)</label>
                                    <input type="number" id="montoRecibido" name="montoRecibido" class="form-control" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ccc; font-size: 1rem;" 
                                           min="0" step="50" placeholder="Ej. 10000" oninput="calcularVueltas()" <%= !hayDetalle ? "disabled" : "" %>>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 8px;">
                                    <span style="font-weight: 500; color: #6b7280;">Cambio / Vueltas:</span>
                                    <span id="lblCambio" style="font-size: 1.2rem; font-weight: bold; color: #10b981;">$0</span>
                                </div>
                            </div>

                            <script>
                                function calcularVueltas() {
                                    const total = parseFloat(document.getElementsByName("totalCobro")[0].value) || 0;
                                    const recibido = parseFloat(document.getElementById("montoRecibido").value) || 0;
                                    const lblCambio = document.getElementById("lblCambio");

                                    if (recibido < total) {
                                        lblCambio.innerText = "Monto insuficiente";
                                        lblCambio.style.color = "#ef4444";
                                    } else {
                                        const vueltas = recibido - total;
                                        lblCambio.innerText = "$" + vueltas.toLocaleString('es-CO', { minimumFractionDigits: 0 });
                                        lblCambio.style.color = "#10b981";
                                    }
                                }
                            </script>

                            <!-- BOTONES -->
                            <div class="action-buttons">
                                <button type="submit" id="btnCompletar" class="btn btn-primary btn-large" <%= hayDetalle ? "" : "disabled" %>>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                                    Completar Pago y Registrar Salida
                                </button>
                                <a id="btnCancelar" class="btn btn-secondary btn-large" href="SalidaServlet">Cancelar</a>
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
                <a class="btn btn-primary" href="SalidaServlet">Entendido</a>
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
                <a class="btn btn-primary" href="SalidaServlet">Entendido</a>
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
                        <div class="tiquete-row"><span class="tiquete-label">Placa:</span><span class="tiquete-value"><%= ver(salidaOk.getPlaca()) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Tiempo:</span><span class="tiquete-value"><%= salidaOk.getTiempoTexto() %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Hora Salida:</span><span class="tiquete-value"><%= salidaOk.getHoraSalida() %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Total Pagado:</span><span class="tiquete-value"><%= plata(salidaOk.getTotal()) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Medio de Pago:</span><span class="tiquete-value"><%= ver(medioPagoOk) %></span></div>
                        <div class="tiquete-row tiquete-ticket"><span class="tiquete-label">Cupo Liberado:</span><span class="tiquete-value"><%= salidaOk.getCupo() != null ? ver(salidaOk.getCupo()) : "-" %></span></div>
                    </div>
                </div>
                <% } %>
            </div>
            <div class="modal-footer">
                <a class="btn btn-primary" href="SalidaServlet">Cerrar</a>
            </div>
        </div>
    </div>
</body>
</html>
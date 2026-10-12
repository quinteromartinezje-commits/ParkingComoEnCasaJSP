<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Reserva" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "reservas";
    String tituloPagina = "Reservas de Cupos";

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
    // ¿Hay una reserva por cancelar? (llega con ?cancelar=ID)
    int cancelarId = request.getAttribute("cancelarId") == null ? 0 : (Integer) request.getAttribute("cancelarId");
    String placaCancelar = null;
    for (Reserva r : reservas) {
        if (r.getId() == cancelarId) placaCancelar = r.getPlaca();
    }
    String vNombre = ver(request.getParameter("nombre"));
    String vDocumento = ver(request.getParameter("documento"));
    String vTelefono = ver(request.getParameter("telefono"));
    String vCorreo = ver(request.getParameter("correo"));
    String vPlaca = ver(request.getParameter("placa"));
    String vValor = ver(request.getParameter("valor"));
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
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">

        <%@ include file="menu.jspf" %>

        <div class="main-content">

            <%@ include file="cabecera.jspf" %>

            <main class="content-area">

                <% if (mensajeOk != null) { %>
                    <div class="msg msg-ok"><%= ver(mensajeOk) %></div>
                <% } %>
                <% if (mensajeError != null) { %>
                    <div class="msg msg-error"><%= ver(mensajeError) %></div>
                <% } %>

                <div class="ingreso-layout">

                    <!-- FORMULARIO (método POST) -->
                    <div class="card">
                        <div class="card-header"><h2>Nueva Reserva</h2></div>

                        <form action="ReservaServlet" method="post" class="form-ingreso">
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
                                    <input type="text" id="placa" name="placa" class="form-input mayusculas" maxlength="10" placeholder="ABC-123" value="<%= vPlaca %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="tipo">Tipo de vehículo *</label>
                                    <select id="tipo" name="tipo" class="form-input" required>
                                        <% if (tipos != null) { for (String t : tipos) { %>
                                            <option value="<%= ver(t) %>"><%= ver(t) %></option>
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
                                                <option value="<%= ver(c) %>"><%= ver(c) %></option>
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
                                        <option value="<%= ver(m) %>"><%= ver(m) %></option>
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
                                            <td><strong><%= ver(r.getCliente()) %></strong><br><small><%= ver(r.getDocumento()) %></small></td>
                                            <td><%= ver(r.getPlaca()) %></td>
                                            <td><span class="badge badge-zona"><%= ver(r.getCupo()) %></span></td>
                                            <td><small><%= r.getFechaInicio() %><br>al <%= r.getFechaFin() %></small></td>
                                            <td><%= plata(r.getValor()) %></td>
                                            <td><a class="btn btn-secondary btn-mini" href="ReservaServlet?cancelar=<%= r.getId() %>">Cancelar</a></td>
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

    <!-- Confirmar cancelación (el servlet la abre con ?cancelar=ID) -->
    <div class="modal-overlay<%= placaCancelar != null ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning"><h3>Cancelar reserva</h3></div>
            <form action="ReservaServlet" method="post">
                <input type="hidden" name="accion" value="cancelar">
                <input type="hidden" name="idReserva" value="<%= cancelarId %>">
                <div class="modal-body">
                    <p>¿Seguro que deseas cancelar la reserva de la placa <strong><%= ver(placaCancelar) %></strong>?</p>
                    <p class="modal-hint">El cupo quedará disponible otra vez.</p>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="ReservaServlet">No, volver</a>
                    <button type="submit" class="btn btn-danger">Sí, cancelar reserva</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

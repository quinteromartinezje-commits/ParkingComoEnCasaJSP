<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, modelo.Tarifa" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "tarifas";
    String tituloPagina = "Configuración de Tarifas";

    // Lo que nos mandó el servlet
    List<Tarifa> tarifas = (List<Tarifa>) request.getAttribute("tarifas");
    List<String[]> tipos = (List<String[]>) request.getAttribute("tipos");
    String abrir = (String) request.getAttribute("abrir");
    Tarifa editar = (Tarifa) request.getAttribute("tarifaEditar");
    Tarifa eliminar = (Tarifa) request.getAttribute("tarifaEliminar");
    String mensajeExito = (String) request.getAttribute("mensajeExito");
    String valorInvalido = (String) request.getAttribute("valorInvalido");
    String volverA = (String) request.getAttribute("volverA");
    boolean errorGuardado = request.getAttribute("errorGuardado") != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuración de Tarifas - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/tarifas.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <div class="tarifas-header">
                    <h2>Configuración Vigente</h2>
                    <a class="btn btn-primary" href="TarifaServlet?nueva=1">+ Nueva Tarifa</a>
                </div>

                <div class="card">
                    <div class="table-responsive">
                        <table class="tarifas-table">
                            <thead>
                                <tr>
                                    <th>Tipo de Vehículo</th>
                                    <th>Tarifa por Hora</th>
                                    <th>Tarifa Fracción</th>
                                    <th>Recargo Nocturno</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (tarifas == null || tarifas.isEmpty()) { %>
                                <tr><td colspan="6" style="text-align:center;">Todavía no hay tarifas. Crea la primera con "Nueva Tarifa".</td></tr>
                                <% } else { for (Tarifa t : tarifas) { %>
                                <tr>
                                    <td><strong><%= ver(t.tipo) %></strong></td>
                                    <td class="precio"><%= plata(t.hora) %></td>
                                    <td class="precio"><%= plata(t.fraccion) %></td>
                                    <td><%= plata(t.recargo) %></td>
                                    <td><span class="<%= t.activo ? "badge-activo" : "badge-inactivo" %>"><%= t.activo ? "Activo" : "Inactivo" %></span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a class="btn-icon btn-edit" title="Editar" href="TarifaServlet?editar=<%= t.idTipo %>"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></a>
                                            <a class="btn-icon btn-delete" title="Eliminar" href="TarifaServlet?eliminar=<%= t.idTipo %>"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg></a>
                                        </div>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <%-- ===== Ventanas (el servlet decide cuál se ve: la clase "active" la pone Java) ===== --%>

    <!-- Nueva tarifa -->
    <div class="modal-overlay<%= "nueva".equals(abrir) ? " active" : "" %>">
        <div class="modal-card modal-edit">
            <form action="TarifaServlet" method="post">
                <input type="hidden" name="accion" value="guardar">
                <div class="modal-header"><h3>Nueva Tarifa</h3></div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Tipo de Vehículo</label>
                        <select name="idTipo" class="form-input" required>
                            <option value="">Seleccione...</option>
                            <% if (tipos != null) { for (String[] tp : tipos) { %>
                            <option value="<%= tp[0] %>"><%= ver(tp[1]) %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tarifa por Hora</label>
                        <input type="number" name="hora" class="form-input" placeholder="Ej: 5000" min="1" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tarifa Fracción</label>
                        <input type="number" name="fraccion" class="form-input" placeholder="Ej: 1250" min="1" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Recargo Nocturno</label>
                        <input type="number" name="recargo" class="form-input" placeholder="Ej: 1500" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="TarifaServlet">Cancelar</a>
                    <button type="submit" class="btn btn-primary">Guardar Tarifa</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Editar tarifa -->
    <div class="modal-overlay<%= "editar".equals(abrir) && editar != null ? " active" : "" %>">
        <div class="modal-card modal-edit">
            <% if (editar != null) { %>
            <form action="TarifaServlet" method="post">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="idTipo" value="<%= editar.idTipo %>">
                <div class="modal-header"><h3>Editar Tarifa</h3></div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Tipo de Vehículo</label>
                        <input type="text" class="form-input" value="<%= ver(editar.tipo) %>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tarifa por Hora</label>
                        <input type="number" name="hora" class="form-input" value="<%= (long) editar.hora %>" min="1" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tarifa Fracción</label>
                        <input type="number" name="fraccion" class="form-input" value="<%= (long) editar.fraccion %>" min="1" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Recargo Nocturno</label>
                        <input type="number" name="recargo" class="form-input" value="<%= (long) editar.recargo %>" min="0" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Estado</label>
                        <select name="estado" class="form-input">
                            <option value="Activo"<%= editar.activo ? " selected" : "" %>>Activar</option>
                            <option value="Inactivo"<%= !editar.activo ? " selected" : "" %>>Desactivar</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="TarifaServlet">Cancelar</a>
                    <button type="submit" class="btn btn-primary">Actualizar Tarifa</button>
                </div>
            </form>
            <% } %>
        </div>
    </div>

    <!-- Confirmar eliminación -->
    <div class="modal-overlay<%= "eliminar".equals(abrir) && eliminar != null ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <form action="TarifaServlet" method="post">
                <div class="modal-header modal-header-warning"><h3>Confirmar eliminación</h3></div>
                <div class="modal-body">
                    <% if (eliminar != null) { %>
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="idTipo" value="<%= eliminar.idTipo %>">
                    <p>¿Está seguro que desea eliminar la tarifa de <strong><%= ver(eliminar.tipo) %></strong>?</p>
                    <% } %>
                    <p class="modal-hint">Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="TarifaServlet">Cancelar</a>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Valor inválido -->
    <div class="modal-overlay<%= valorInvalido != null ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning"><h3>Valor inválido</h3></div>
            <div class="modal-body"><p><%= ver(valorInvalido) %></p></div>
            <div class="modal-footer">
                <a class="btn btn-primary" href="TarifaServlet?<%= volverA == null ? "" : volverA %>">Entendido</a>
            </div>
        </div>
    </div>

    <!-- Error al guardar -->
    <div class="modal-overlay<%= errorGuardado ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning"><h3>No se pudo guardar</h3></div>
            <div class="modal-body"><p>Hubo un problema con la base de datos. Revisa la consola de NetBeans.</p></div>
            <div class="modal-footer"><a class="btn btn-primary" href="TarifaServlet">Cerrar</a></div>
        </div>
    </div>

    <!-- Guardado / eliminado con éxito -->
    <div class="modal-overlay<%= mensajeExito != null ? " active" : "" %>">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success"><h3>Listo</h3></div>
            <div class="modal-body"><p><%= ver(mensajeExito) %></p></div>
            <div class="modal-footer"><a class="btn btn-primary" href="TarifaServlet">Aceptar</a></div>
        </div>
    </div>
</body>
</html>

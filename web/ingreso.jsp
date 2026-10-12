<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Ingreso" %>
<%@ include file="sesion.jspf" %>
<%
    // Quién está dentro, el menú y las ayudas ver()/plata() vienen de sesion.jspf
    String paginaActiva = "ingreso";
    String tituloPagina = "Registro de Ingreso";
    // Los cupos libres y los últimos ingresos los prepara IngresoServlet (GET).
    List<String> cuposLibres = (List<String>) request.getAttribute("cuposLibres");
    // El servlet avisa qué ventana (modal) hay que mostrar
    String claseExito = "true".equals(request.getAttribute("modalExito")) ? " active" : "";
    String claseCupo = "true".equals(request.getAttribute("modalCupo")) ? " active" : "";
    String claseTipo = "true".equals(request.getAttribute("modalTipo")) ? " active" : "";
    String claseTarifa = "true".equals(request.getAttribute("modalTarifa")) ? " active" : "";
    String clasePlaca = "true".equals(request.getAttribute("modalError")) ? " active" : "";

    // Avisos de campos vacíos (los pone el servlet) y valores que la persona ya había elegido
    String errPlaca = (String) request.getAttribute("errPlaca");
    String errTipo = (String) request.getAttribute("errTipo");
    String errCupo = (String) request.getAttribute("errCupo");
    String vPlaca = request.getParameter("placa") == null ? "" : request.getParameter("placa");
    String vTipo = request.getParameter("tipo") == null ? "" : request.getParameter("tipo");
    String vCupo = request.getParameter("cupo") == null ? "" : request.getParameter("cupo");

    // Si el ingreso se guardó bien, el formulario queda limpio
    if (!claseExito.isEmpty()) { vPlaca = ""; vTipo = ""; vCupo = ""; }

    if (cuposLibres == null) {
        response.sendRedirect("IngresoServlet");
        return;
    }
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
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

                        <main class="content-area">
                
                <% String errorDebug = (String) request.getAttribute("errorDebug"); %>
                <% if (errorDebug != null) { %>
                    <div class="msg msg-error"><%= ver(errorDebug) %></div>
                <% } %>

                <div class="ingreso-layout">
                    <div class="card">
                        <div class="card-header"><h2>Nuevo Registro de Entrada</h2></div>
                        
                        <!-- Las validaciones las hace el navegador (required) y el servlet -->
                        <form action="IngresoServlet" method="post" class="form-ingreso">
                            
                            <!-- Placa del Vehículo -->
                            <div class="form-group">
                                <label class="form-label">Placa del Vehículo *</label>
                                <div class="input-with-icon">
                                    <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H5.24a2 2 0 0 0-1.8 1.1l-.8 1.63A6 6 0 0 0 2 12.42V16h2"/><circle cx="6.5" cy="16.5" r="2.5"/><circle cx="16.5" cy="16.5" r="2.5"/></svg>
                                    <input type="text" id="placa" name="placa" class="form-input mayusculas<%= errPlaca != null ? " error" : "" %>" placeholder="ABC-123" maxlength="10" value="<%= ver(vPlaca) %>">
                                </div>
                                <span class="error-message<%= errPlaca != null ? " visible" : "" %>"><%= ver(errPlaca) %></span>
                            </div>

                            <!-- Tipo de Vehículo -->
                            <div class="form-group">
                                <label class="form-label">Tipo de Vehículo *</label>
                                <div class="vehicle-buttons">
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Carro"<%= vTipo.equals("Carro") ? " checked" : "" %>> Carro
                                    </label>
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Moto"<%= vTipo.equals("Moto") ? " checked" : "" %>> Moto
                                    </label>
                                    <label class="vehicle-btn">
                                        <input type="radio" name="tipo" value="Camioneta"<%= vTipo.equals("Camioneta") ? " checked" : "" %>> Camioneta
                                    </label>
                                </div>
                                <span class="error-message<%= errTipo != null ? " visible" : "" %>"><%= ver(errTipo) %></span>
                            </div>

                            <!-- Fecha y Hora + Cupo -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Fecha y Hora</label>
                                    <div class="input-with-icon">
                                        <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                        <input type="text" id="fechaHora" name="fechaHora" class="form-input" value="<%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %>" readonly>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Cupo Asignado *</label>
                                    <div class="input-with-icon">
                                        <svg class="input-icon-svg" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                                        <select id="cupo" name="cupo" class="form-input" style="cursor: pointer;">
                                            <% if (cuposLibres.isEmpty()) { %>
                                                <option value="" selected>No hay cupos disponibles</option>
                                            <% } else { %>
                                                <option value="" selected>Seleccionar cupo disponible</option>
                                                <% for (String c : cuposLibres) { %>
                                                    <option value="<%= ver(c) %>"<%= c.equals(vCupo) ? " selected" : "" %>><%= ver(c) %></option>
                                                <% } %>
                                            <% } %>
                                        </select>
                                    </div>
                                    <span class="error-message<%= errCupo != null ? " visible" : "" %>"><%= ver(errCupo) %></span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block">+ Registrar Ingreso</button>
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
                                            <td><strong><%= ver(ing.getPlaca()) %></strong></td>
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
    <div id="modalPlacaDuplicada" class="modal-overlay<%= clasePlaca %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Placa ya registrada</h3>
            </div>
            <div class="modal-body">
                <p>El vehículo con placa <strong id="placaDuplicada"><%= ver((String) request.getAttribute("placaDuplicada")) %></strong> ya se encuentra dentro del parqueadero.</p>
            </div>
            <div class="modal-footer">
                <a class="btn btn-secondary" href="IngresoServlet">Cerrar</a>
            </div>
        </div>
    </div>

    <div id="modalCupoOcupado" class="modal-overlay<%= claseCupo %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Cupo no disponible</h3>
            </div>
            <div class="modal-body">
                <p>El cupo <strong id="cupoNoDisponible"><%= ver((String) request.getAttribute("cupoNoDisponible")) %></strong> ya está <span id="estadoCupo"><%= ver((String) request.getAttribute("estadoCupo")) %></span>. Por favor elige otro cupo de la lista.</p>
            </div>
            <div class="modal-footer">
                <a class="btn btn-primary" href="IngresoServlet">Cerrar</a>
            </div>
        </div>
    </div>

    <div id="modalTipoIncorrecto" class="modal-overlay<%= claseTipo %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Tipo de vehículo incorrecto</h3>
            </div>
            <div class="modal-body">
                <p>No se puede asignar un(a) <strong><%= ver((String) request.getAttribute("tipoElegido")) %></strong> al cupo <strong><%= ver((String) request.getAttribute("cupoElegido")) %></strong>.</p>
                <p class="modal-hint">Los cupos M son solo para motos; los cupos A son para carros y camionetas.</p>
            </div>
            <div class="modal-footer">
                <a class="btn btn-primary" href="IngresoServlet">Entendido</a>
            </div>
        </div>
    </div>

    <div id="modalTarifaInactiva" class="modal-overlay<%= claseTarifa %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <h3>Tarifa inhabilitada</h3>
            </div>
            <div class="modal-body">
                <p>La tarifa para <strong><%= ver((String) request.getAttribute("tipoElegido")) %></strong> está inhabilitada, por eso no se puede registrar el ingreso.</p>
                <p class="modal-hint">Actívala en la pantalla Tarifas.</p>
            </div>
            <div class="modal-footer">
                <a class="btn btn-primary" href="IngresoServlet">Entendido</a>
            </div>
        </div>
    </div>

    <div id="modalExito" class="modal-overlay<%= claseExito %>">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <h3>Ingreso registrado exitosamente</h3>
            </div>
            <div class="modal-body">
                <div class="tiquete-preview">
                    <div class="tiquete-header"><strong>Parking Como en Casa</strong><span>Tiquete de Entrada</span></div>
                    <div class="tiquete-body">
                        <div class="tiquete-row"><span class="tiquete-label">Placa:</span><span class="tiquete-value" id="tiquetePlaca"><%= ver((String) request.getAttribute("tPlaca")) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Tipo:</span><span class="tiquete-value" id="tiqueteTipo"><%= ver((String) request.getAttribute("tTipo")) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Cupo:</span><span class="tiquete-value" id="tiqueteCupo"><%= ver((String) request.getAttribute("tCupo")) %></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Hora entrada:</span><span class="tiquete-value" id="tiqueteHora"><%= ver((String) request.getAttribute("tHora")) %></span></div>
                        <div class="tiquete-row tiquete-ticket"><span class="tiquete-label">Ticket:</span><span class="tiquete-value" id="tiqueteCodigo"><%= ver((String) request.getAttribute("tTicket")) %></span></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <a class="btn btn-primary" href="IngresoServlet">Cerrar</a>
            </div>
        </div>
    </div>
    
</body>
</html>
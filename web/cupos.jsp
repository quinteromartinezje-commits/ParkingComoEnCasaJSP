<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, modelo.Cupo" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "cupos";
    String tituloPagina = "Mapa de Ocupación";

    List<Cupo> cupos = (List<Cupo>) request.getAttribute("cupos");
    String zona = (String) request.getAttribute("zona");
    String buscar = (String) request.getAttribute("buscar");
    if (zona == null) zona = "todos";
    if (buscar == null) buscar = "";
    Object disp = request.getAttribute("disponibles");
    Object ocup = request.getAttribute("ocupados");
    Object resv = request.getAttribute("reservados");

    String modal = (String) request.getAttribute("modal");
    String cupoElegido = (String) request.getAttribute("cupoElegido");
    String estadoElegido = (String) request.getAttribute("estadoElegido");
    String tipoElegido = (String) request.getAttribute("tipoElegido");
    String placaElegida = (String) request.getAttribute("placaElegida");
    String ticketElegido = (String) request.getAttribute("ticketElegido");
    String mensajeModal = (String) request.getAttribute("mensajeModal");

    // Para que los enlaces recuerden la zona y la búsqueda
    String volver = "CupoServlet?zona=" + zona + "&buscar=" + java.net.URLEncoder.encode(buscar, "UTF-8");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa de Ocupación - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/cupos.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <!-- Resumen -->
                <div class="cupos-stats">
                    <div class="stat-card stat-disponible">
                        <div class="stat-icon"><svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg></div>
                        <div class="stat-content"><span class="stat-label">Disponibles</span><span class="stat-value"><%= disp %> Cupos</span></div>
                    </div>
                    <div class="stat-card stat-ocupado">
                        <div class="stat-icon"><svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M9 17V7h4a3 3 0 0 1 0 6H9"/></svg></div>
                        <div class="stat-content"><span class="stat-label">Ocupados</span><span class="stat-value"><%= ocup %> Cupos</span></div>
                    </div>
                    <div class="stat-card stat-reservado">
                        <div class="stat-icon"><svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
                        <div class="stat-content"><span class="stat-label">Reservados</span><span class="stat-value"><%= resv %> Cupos</span></div>
                    </div>
                </div>

                <!-- Zonas y búsqueda -->
                <div class="cupos-toolbar">
                    <div class="nivel-tabs">
                        <a class="nivel-tab<%= zona.equals("todos") ? " active" : "" %>" href="CupoServlet?zona=todos">Todos</a>
                        <a class="nivel-tab<%= zona.equals("A") ? " active" : "" %>" href="CupoServlet?zona=A">Zona A (Carros)</a>
                        <a class="nivel-tab<%= zona.equals("M") ? " active" : "" %>" href="CupoServlet?zona=M">Zona M (Motos)</a>
                    </div>
                    <form class="search-cupo" action="CupoServlet" method="get">
                        <input type="hidden" name="zona" value="<%= ver(zona) %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="text" name="buscar" class="mayusculas" placeholder="Buscar Cupo" value="<%= ver(buscar) %>">
                    </form>
                </div>

                <!-- Mapa -->
                <div class="card piso-mapa active">
                    <div class="card-header">
                        <h2>Distribución <%= zona.equals("A") ? "Zona A" : zona.equals("M") ? "Zona M" : "de todos los cupos" %></h2>
                    </div>
                    <div class="cupos-grid">
                        <% if (cupos == null || cupos.isEmpty()) { %>
                        <p>No se encontraron cupos.</p>
                        <% } else { for (Cupo c : cupos) {
                               String e = c.getEstado() == null ? "" : c.getEstado().toLowerCase();
                               String clase = e.equals("ocupado") ? "cupo-ocupado" : e.equals("reservado") ? "cupo-reservado" : "cupo-disponible";
                               String sigla = e.equals("ocupado") ? "OCUP" : e.equals("reservado") ? "RES" : "DISP"; %>
                        <a class="cupo-card <%= clase %>" style="text-decoration:none;" href="CupoServlet?zona=<%= ver(zona) %>&amp;buscar=<%= ver(buscar) %>&amp;cupo=<%= ver(c.getCodigo()) %>">
                            <span class="cupo-codigo"><%= ver(c.getCodigo()) %></span>
                            <span class="cupo-estado"><%= sigla %></span>
                        </a>
                        <% } } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Asignar vehículo -->
    <div class="modal-overlay<%= "asignar".equals(modal) ? " active" : "" %>">
        <div class="modal-card">
            <form action="CupoServlet" method="post">
                <input type="hidden" name="cupo" value="<%= ver(cupoElegido) %>">
                <input type="hidden" name="zona" value="<%= ver(zona) %>">
                <input type="hidden" name="buscar" value="<%= ver(buscar) %>">
                <div class="modal-header"><h3>Asignar vehículo al cupo <%= ver(cupoElegido) %></h3></div>
                <div class="modal-body">
                    <% if (mensajeModal != null) { %><div class="msg msg-error"><%= ver(mensajeModal) %></div><% } %>
                    <div class="form-group">
                        <label class="form-label">Tipo de vehículo</label>
                        <div class="radio-group horizontal">
                            <label class="radio-btn"><input type="radio" name="tipo" value="Carro" required><span>Carro</span></label>
                            <label class="radio-btn"><input type="radio" name="tipo" value="Moto"><span>Moto</span></label>
                            <label class="radio-btn"><input type="radio" name="tipo" value="Camioneta"><span>Camioneta</span></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Placa del vehículo</label>
                        <input type="text" name="placa" class="form-input mayusculas" placeholder="Ej: ABC-123" maxlength="10" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="<%= volver %>">Cancelar</a>
                    <button type="submit" class="btn btn-primary">Asignar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Celda ocupada -->
    <div class="modal-overlay<%= "ocupado".equals(modal) ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning"><h3>Celda no disponible</h3></div>
            <div class="modal-body">
                <p>El cupo <strong><%= ver(cupoElegido) %></strong> está <%= ver(estadoElegido) %>.</p>
                <p class="modal-hint">Seleccione otro cupo disponible o libere el cupo actual primero.</p>
            </div>
            <div class="modal-footer"><a class="btn btn-primary" href="<%= volver %>">Entendido</a></div>
        </div>
    </div>

    <!-- Tipo incorrecto -->
    <div class="modal-overlay<%= "tipo".equals(modal) ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning"><h3>Tipo de vehículo incorrecto</h3></div>
            <div class="modal-body">
                <p>No se puede asignar un(a) <%= ver(tipoElegido) %> al cupo <strong><%= ver(cupoElegido) %></strong>.</p>
                <p class="modal-hint">Los cupos M son para motos; los cupos A, para carros y camionetas.</p>
            </div>
            <div class="modal-footer"><a class="btn btn-primary" href="<%= volver %>">Entendido</a></div>
        </div>
    </div>

    <!-- Asignación exitosa -->
    <div class="modal-overlay<%= "exito".equals(modal) ? " active" : "" %>">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success"><h3>Asignación exitosa</h3></div>
            <div class="modal-body">
                <p>El vehículo <strong><%= ver(placaElegida) %></strong> quedó en el cupo <strong><%= ver(cupoElegido) %></strong>.</p>
                <p class="modal-hint">Ticket: <%= ver(ticketElegido) %></p>
            </div>
            <div class="modal-footer"><a class="btn btn-primary" href="<%= volver %>">Aceptar</a></div>
        </div>
    </div>
</body>
</html>

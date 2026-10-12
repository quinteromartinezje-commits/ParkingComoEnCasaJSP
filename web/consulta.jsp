<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, modelo.ConsultaFila" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "consulta";
    String tituloPagina = "Consulta de Vehículos";

    List<ConsultaFila> filas = (List<ConsultaFila>) request.getAttribute("filas");
    String buscar = (String) request.getAttribute("buscar");
    String estado = (String) request.getAttribute("estado");
    if (buscar == null) buscar = "";
    if (estado == null) estado = "todos";
    int verId = request.getAttribute("ver") == null ? 0 : (Integer) request.getAttribute("ver");
    String q = "buscar=" + java.net.URLEncoder.encode(buscar, "UTF-8") + "&amp;estado=" + ver(estado);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/consulta.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <div class="card">
                    <div class="buscador-header"><h2>Buscador General de Flota e Historial</h2></div>
                    <form class="buscador-form" action="ConsultaServlet" method="get">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Placa o Ticket</label>
                                <input type="text" name="buscar" class="form-input mayusculas" placeholder="Ej: KLY-982 o TKT-10253" value="<%= ver(buscar) %>">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Estado</label>
                                <select name="estado" class="form-input">
                                    <option value="todos"<%= estado.equals("todos") ? " selected" : "" %>>Todos</option>
                                    <option value="activo"<%= estado.equals("activo") ? " selected" : "" %>>Activo en patio</option>
                                    <option value="finalizado"<%= estado.equals("finalizado") ? " selected" : "" %>>Finalizado</option>
                                </select>
                            </div>
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn btn-primary btn-buscar">Buscar</button>
                        </div>
                    </form>
                </div>

                <div class="resultados-section">
                    <h2 class="resultados-titulo">Resultados de Búsqueda</h2>
                    <div class="card">
                        <table class="table">
                            <thead>
                                <tr><th>Placa</th><th>Tipo</th><th>Ticket</th><th>Ingreso</th><th>Salida</th><th>Duración</th><th>Monto</th><th>Estado</th></tr>
                            </thead>
                            <tbody>
                                <% if (filas == null || filas.isEmpty()) { %>
                                <tr><td colspan="8" style="text-align:center;">No se encontraron vehículos.</td></tr>
                                <% } else { for (ConsultaFila f : filas) {
                                       boolean abierta = f.id == verId;
                                       String enlace = "ConsultaServlet?" + q + (abierta ? "" : "&amp;ver=" + f.id); %>
                                <tr class="fila-principal">
                                    <td><a class="fila-enlace" href="<%= enlace %>"><span class="badge-placa"><%= ver(f.placa) %></span></a></td>
                                    <td><%= ver(f.tipo) %></td>
                                    <td><strong>#<%= f.getTicket() %></strong></td>
                                    <td><%= ver(f.ingreso) %></td>
                                    <td><%= f.enPatio() ? "Activo en patio" : ver(f.salida) %></td>
                                    <td><%= f.getDuracion() %></td>
                                    <td><strong><%= f.monto == null ? "Pendiente" : plata(f.monto) %></strong></td>
                                    <td><span class="badge <%= f.enPatio() ? "badge-en-patio" : "badge-finalizado" %>"><%= f.enPatio() ? "En Patio" : "Finalizado" %></span></td>
                                </tr>
                                <tr class="fila-detalle<%= abierta ? " abierta" : "" %>">
                                    <td colspan="8">
                                        <div class="detalle-contenido">
                                            <div class="detalle-columna">
                                                <h4>DETALLES DEL CUPO</h4>
                                                <p><strong>Zona Asignada:</strong> <%= ver(f.cupo) %></p>
                                                <p><strong>Operario Registro:</strong> <%= ver(f.operario) %></p>
                                            </div>
                                            <div class="detalle-columna">
                                                <h4>PAGO</h4>
                                                <p><strong>Medio de pago:</strong> <%= f.medioPago == null ? "Aún no ha pagado" : ver(f.medioPago) %></p>
                                            </div>
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
</body>
</html>

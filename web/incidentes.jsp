<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, modelo.Incidente" %>
<%@ include file="sesion.jspf" %>
<%!
    // Devuelve la clase de color según el tipo de incidente
    String claseTipo(String tipo) {
        if ("Daño".equals(tipo)) return "badge-dano";
        if ("Reclamo".equals(tipo)) return "badge-reclamo";
        return "badge-novedad";
    }
%>
<%
    // Datos para el menú y el título de la página
    String paginaActiva = "incidentes";
    String tituloPagina = "Registro de Incidentes";

    // Datos que envía IncidenteServlet: lista de incidentes y mensajes de resultado
    List<Incidente> incidentes = (List<Incidente>) request.getAttribute("incidentes");
    String mensajeOk = (String) request.getAttribute("mensajeOk");
    String mensajeError = (String) request.getAttribute("mensajeError");

    // Si hubo error, se vuelve a mostrar lo que la persona escribió
    String fPlaca = request.getParameter("placa") == null ? "" : request.getParameter("placa");
    String fTipo = request.getParameter("tipo") == null ? "" : request.getParameter("tipo");
    String fDesc = request.getParameter("descripcion") == null ? "" : request.getParameter("descripcion");
    String fPrio = request.getParameter("prioridad") == null ? "" : request.getParameter("prioridad");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Incidentes - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/incidentes.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <%-- Mensajes de éxito o error al registrar --%>
                <% if (mensajeOk != null) { %><div class="msg msg-ok"><%= ver(mensajeOk) %></div><% } %>
                <% if (mensajeError != null) { %><div class="msg msg-error"><%= ver(mensajeError) %></div><% } %>

                <div class="incidentes-layout">
                    <%-- Lista de incidentes recientes, con color según la prioridad --%>
                    <div class="incidentes-lista">
                        <h2>Incidentes Reportados Recientemente</h2>
                        <% if (incidentes == null || incidentes.isEmpty()) { %>
                        <p>Todavía no hay incidentes reportados.</p>
                        <% } else { for (Incidente i : incidentes) {
                               String p = i.prioridad == null ? "Baja" : i.prioridad;
                               String pc = p.equals("Alta") ? "alta" : p.equals("Media") ? "media" : "baja"; %>
                        <div class="incidente-card incidente-<%= pc %>">
                            <div class="incidente-header">
                                <span class="badge-prioridad badge-<%= pc %>"><%= ver(p) %></span>
                                <span class="incidente-titulo"><%= ver(i.titulo) %></span>
                                <span class="incidente-tiempo"><%= ver(i.cuando) %></span>
                            </div>
                            <div class="incidente-descripcion"><%= ver(i.descripcion) %></div>
                            <div class="incidente-footer">
                                <span class="incidente-reportado">Reportado por: <%= ver(i.reportadoPor) %></span>
                                <span class="badge-tipo <%= claseTipo(i.tipo) %>">Tipo: <%= ver(i.tipo) %></span>
                            </div>
                        </div>
                        <% } } %>
                    </div>

                    <div class="incidentes-form">
                        <div class="card">
                            <%-- Formulario para registrar un incidente nuevo --%>
                            <div class="card-header"><h2>Nuevo Incidente</h2></div>
                            <form action="IncidenteServlet" method="post" class="form-incidente">
                                <div class="form-group">
                                    <label class="form-label">Placa de Vehículo (opcional)</label>
                                    <input type="text" name="placa" class="form-input mayusculas" placeholder="Ej: KLY-982" maxlength="10" value="<%= ver(fPlaca) %>">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Tipo de Incidente</label>
                                    <div class="radio-group horizontal">
                                        <label class="radio-btn"><input type="radio" name="tipo" value="Daño" required<%= fTipo.equals("Daño") ? " checked" : "" %>><span>Daño</span></label>
                                        <label class="radio-btn"><input type="radio" name="tipo" value="Novedad"<%= fTipo.equals("Novedad") ? " checked" : "" %>><span>Novedad</span></label>
                                        <label class="radio-btn"><input type="radio" name="tipo" value="Reclamo"<%= fTipo.equals("Reclamo") ? " checked" : "" %>><span>Reclamo</span></label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Descripción</label>
                                    <textarea name="descripcion" class="form-input form-textarea" rows="3" maxlength="255" placeholder="Describa el incidente..." required><%= ver(fDesc) %></textarea>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Prioridad</label>
                                    <div class="radio-group horizontal">
                                        <label class="radio-btn prioridad-alta"><input type="radio" name="prioridad" value="Alta" required<%= fPrio.equals("Alta") ? " checked" : "" %>><span>Alta</span></label>
                                        <label class="radio-btn prioridad-media"><input type="radio" name="prioridad" value="Media"<%= fPrio.equals("Media") ? " checked" : "" %>><span>Media</span></label>
                                        <label class="radio-btn prioridad-baja"><input type="radio" name="prioridad" value="Baja"<%= fPrio.equals("Baja") ? " checked" : "" %>><span>Baja</span></label>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary btn-block">Registrar Incidente</button>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

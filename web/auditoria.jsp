<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, modelo.AuditoriaFila" %>
<%@ include file="sesion.jspf" %>
<%!
    // Color de la etiqueta según la acción
    String claseAccion(String accion) {
        String a = accion == null ? "" : accion.toLowerCase();
        if (a.contains("ingreso")) return "badge-accion-ingreso";
        if (a.contains("salida")) return "badge-accion-salida";
        return "badge-accion-modificar";
    }
%>
<%
    String paginaActiva = "auditoria";
    String tituloPagina = "Auditoría del Sistema";

    List<AuditoriaFila> filas = (List<AuditoriaFila>) request.getAttribute("filas");
    List<String[]> usuarios = (List<String[]>) request.getAttribute("usuarios");
    String fUsuario = (String) request.getAttribute("fUsuario");
    String fFecha = (String) request.getAttribute("fFecha");
    String fModulo = (String) request.getAttribute("fModulo");
    if (fUsuario == null) fUsuario = "";
    if (fFecha == null) fFecha = "todos";
    if (fModulo == null) fModulo = "";
    int total = request.getAttribute("total") == null ? 0 : (Integer) request.getAttribute("total");
    int pagina = request.getAttribute("pagina") == null ? 1 : (Integer) request.getAttribute("pagina");
    int paginas = request.getAttribute("paginas") == null ? 1 : (Integer) request.getAttribute("paginas");

    int porPagina = dao.AuditoriaDAO.POR_PAGINA;
    int primero = total == 0 ? 0 : (pagina - 1) * porPagina + 1;
    int ultimo = Math.min(total, pagina * porPagina);

    String[] modulos = {"Ingreso", "Salida", "Reservas", "Tarifas", "Cupos", "Usuarios", "Sesión", "Incidentes", "Perfil"};
    // Los enlaces de paginación conservan los filtros
    String filtros = "usuario=" + ver(fUsuario) + "&amp;fecha=" + ver(fFecha) + "&amp;modulo=" + java.net.URLEncoder.encode(fModulo, "UTF-8");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auditoría - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/auditoria.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <!-- Filtros: formulario GET -->
                <div class="card">
                    <form class="auditoria-filtros" action="AuditoriaServlet" method="get">
                        <div class="filtros-row">
                            <div class="form-group">
                                <label class="form-label">Usuario</label>
                                <select name="usuario" class="form-input">
                                    <option value="">Todos los usuarios</option>
                                    <% if (usuarios != null) { for (String[] u : usuarios) { %>
                                    <option value="<%= u[0] %>"<%= u[0].equals(fUsuario) ? " selected" : "" %>><%= ver(u[1]) %></option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Rango de Fechas</label>
                                <select name="fecha" class="form-input">
                                    <option value="todos"<%= fFecha.equals("todos") ? " selected" : "" %>>Todas</option>
                                    <option value="hoy"<%= fFecha.equals("hoy") ? " selected" : "" %>>Hoy</option>
                                    <option value="semana"<%= fFecha.equals("semana") ? " selected" : "" %>>Esta semana</option>
                                    <option value="mes"<%= fFecha.equals("mes") ? " selected" : "" %>>Este mes</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Módulo</label>
                                <select name="modulo" class="form-input">
                                    <option value="">Todos los módulos</option>
                                    <% for (String m : modulos) { %>
                                    <option value="<%= m %>"<%= m.equals(fModulo) ? " selected" : "" %>><%= m %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="filtros-acciones">
                            <button type="submit" class="btn btn-primary">Filtrar</button>
                            <a class="btn btn-secondary" href="AuditoriaServlet">Limpiar</a>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr><th>Fecha / Hora</th><th>Usuario</th><th>Acción</th><th>Módulo</th><th>Detalle</th><th>IP</th></tr>
                            </thead>
                            <tbody>
                                <% if (filas == null || filas.isEmpty()) { %>
                                <tr><td colspan="6" style="text-align:center;">No hay eventos con esos filtros.</td></tr>
                                <% } else { for (AuditoriaFila f : filas) { %>
                                <tr>
                                    <td><%= ver(f.fecha) %></td>
                                    <td><strong><%= ver(f.usuario) %></strong></td>
                                    <td><span class="badge <%= claseAccion(f.accion) %>"><%= ver(f.accion) %></span></td>
                                    <td><%= ver(f.modulo) %></td>
                                    <td><%= ver(f.detalle) %></td>
                                    <td><%= ver(f.ip) %></td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="paginacion">
                        <span class="paginacion-info">Mostrando <%= primero %>-<%= ultimo %> de <%= total %> eventos</span>
                        <div class="paginacion-botones">
                            <% for (int p = 1; p <= paginas; p++) { %>
                            <a class="btn-pagina<%= p == pagina ? " active" : "" %>" href="AuditoriaServlet?<%= filtros %>&amp;pagina=<%= p %>"><%= p %></a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.Perfil" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "perfil";
    String tituloPagina = "Mi Perfil";

    Perfil perfil = (Perfil) request.getAttribute("perfil");
    String modal = (String) request.getAttribute("modal");
    String mensajeOk = (String) request.getAttribute("mensajeOk");
    String mensajeError = (String) request.getAttribute("mensajeError");
    if (perfil == null) perfil = new Perfil();

    // Valores del formulario de edición (si hubo error se muestran los que escribió)
    String eNombre = request.getParameter("nombre") != null ? request.getParameter("nombre") : perfil.nombre;
    String eCorreo = request.getParameter("correo") != null ? request.getParameter("correo") : perfil.correo;
    String eDocumento = request.getParameter("documento") != null ? request.getParameter("documento") : perfil.documento;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/perfil.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <% if (mensajeOk != null) { %><div class="msg msg-ok"><%= ver(mensajeOk) %></div><% } %>

                <div class="perfil-header card">
                    <div class="perfil-header-left">
                        <div class="perfil-avatar-container">
                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            <span class="status-dot"></span>
                        </div>
                        <div class="perfil-info">
                            <h2 class="perfil-nombre"><%= ver(perfil.nombre) %></h2>
                            <span class="badge-rol"><%= ver(perfil.rol) %></span>
                            <p class="perfil-id">ID de usuario: #<%= perfil.id %></p>
                        </div>
                    </div>
                    <a class="btn btn-primary btn-editar-perfil" href="PerfilServlet?editar=1">Editar Perfil</a>
                </div>

                <div class="perfil-grid">
                    <div class="perfil-columna-izquierda">
                        <div class="card">
                            <div class="card-header"><h2>Información Personal</h2></div>
                            <div class="info-grid">
                                <div class="info-item"><span class="info-label">NOMBRE COMPLETO</span><span class="info-value"><%= ver(perfil.nombre) %></span></div>
                                <div class="info-item"><span class="info-label">CORREO ELECTRÓNICO</span><span class="info-value"><%= ver(perfil.correo) %></span></div>
                                <div class="info-item"><span class="info-label">DOCUMENTO DE IDENTIDAD</span><span class="info-value"><%= ver(perfil.documento) %></span></div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-header"><h2>Información Laboral</h2></div>
                            <div class="info-grid">
                                <div class="info-item"><span class="info-label">CARGO</span><span class="info-value"><%= ver(perfil.rol) %></span></div>
                                <div class="info-item"><span class="info-label">FECHA DE REGISTRO</span><span class="info-value"><%= ver(perfil.fechaRegistro) %></span></div>
                            </div>
                        </div>
                    </div>

                    <div class="perfil-columna-derecha">
                        <div class="stats-section">
                            <h3 class="stats-title">ESTADÍSTICAS Y ACTIVIDAD</h3>
                            <div class="stats-cards">
                                <div class="stat-mini-card"><div class="stat-mini-content"><span class="stat-mini-label">Vehículos Reg</span><span class="stat-mini-value"><%= perfil.vehiculosRegistrados %></span></div></div>
                                <div class="stat-mini-card"><div class="stat-mini-content"><span class="stat-mini-label">Acciones Realiz.</span><span class="stat-mini-value"><%= perfil.accionesRealizadas %></span></div></div>
                                <div class="stat-mini-card"><div class="stat-mini-content"><span class="stat-mini-label">Días Trabajados</span><span class="stat-mini-value"><%= perfil.diasTrabajados %></span></div></div>
                            </div>
                        </div>

                        <div class="card seguridad-card">
                            <div class="card-header"><h2>Seguridad y Accesos</h2></div>
                            <div class="seguridad-item">
                                <div class="seguridad-info">
                                    <strong>Contraseña del Sistema</strong>
                                    <span>Cámbiala cuando quieras.</span>
                                </div>
                                <a class="btn btn-secondary btn-sm" href="PerfilServlet?clave=1">Cambiar</a>
                            </div>
                            <div class="ultima-sesion">
                                <span class="ultima-sesion-label">ÚLTIMO ACCESO REGISTRADO</span>
                                <span class="ultima-sesion-value"><%= perfil.ultimoAcceso == null ? "Sin registro" : ver(perfil.ultimoAcceso) %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Editar perfil -->
    <div class="modal-overlay<%= "editar".equals(modal) ? " active" : "" %>">
        <div class="modal-card modal-edit">
            <form action="PerfilServlet" method="post">
                <input type="hidden" name="accion" value="perfil">
                <div class="modal-header"><h3>Editar Perfil</h3></div>
                <div class="modal-body">
                    <% if ("editar".equals(modal) && mensajeError != null) { %><div class="msg msg-error"><%= ver(mensajeError) %></div><% } %>
                    <div class="form-group">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" name="nombre" class="form-input" value="<%= ver(eNombre) %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Correo electrónico</label>
                        <input type="email" name="correo" class="form-input" value="<%= ver(eCorreo) %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Documento</label>
                        <input type="text" name="documento" class="form-input" value="<%= ver(eDocumento) %>" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="PerfilServlet">Cancelar</a>
                    <button type="submit" class="btn btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Cambiar contraseña -->
    <div class="modal-overlay<%= "clave".equals(modal) ? " active" : "" %>">
        <div class="modal-card modal-edit">
            <form action="PerfilServlet" method="post">
                <input type="hidden" name="accion" value="clave">
                <div class="modal-header"><h3>Cambiar contraseña</h3></div>
                <div class="modal-body">
                    <% if ("clave".equals(modal) && mensajeError != null) { %><div class="msg msg-error"><%= ver(mensajeError) %></div><% } %>
                    <div class="form-group">
                        <label class="form-label">Contraseña actual</label>
                        <input type="password" name="actual" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Contraseña nueva</label>
                        <input type="password" name="nueva" class="form-input" minlength="6" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Repite la contraseña nueva</label>
                        <input type="password" name="repetir" class="form-input" minlength="6" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="PerfilServlet">Cancelar</a>
                    <button type="submit" class="btn btn-primary">Cambiar</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

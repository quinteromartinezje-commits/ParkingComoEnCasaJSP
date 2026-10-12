<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, modelo.UsuarioFila" %>
<%@ include file="sesion.jspf" %>
<%
    String paginaActiva = "usuarios";
    String tituloPagina = "Gestión de Usuarios";

    List<UsuarioFila> usuarios = (List<UsuarioFila>) request.getAttribute("usuarios");
    UsuarioFila editar = (UsuarioFila) request.getAttribute("usuarioEditar");
    UsuarioFila eliminar = (UsuarioFila) request.getAttribute("usuarioEliminar");
    String modalGuardado = (String) request.getAttribute("modalGuardado");
    String mensajeError = (String) request.getAttribute("mensajeError");
    String correoDuplicado = (String) request.getAttribute("correoDuplicado");

    // Valores del formulario: si el usuario se está editando salen de la base de datos;
    // si hubo un error al guardar, se vuelven a mostrar los que escribió.
    String fId = "", fNombre = "", fDocumento = "", fCorreo = "", fRol = "Operario", fEstado = "Activo";
    if (editar != null) {
        fId = String.valueOf(editar.id);
        fNombre = editar.nombre;
        fDocumento = editar.documento;
        fCorreo = editar.correo;
        fRol = editar.rol;
        fEstado = editar.activo ? "Activo" : "Inactivo";
    } else if (request.getParameter("nombre") != null) {
        fId = request.getParameter("id");
        fNombre = request.getParameter("nombre");
        fDocumento = request.getParameter("documento");
        fCorreo = request.getParameter("correo");
        fRol = request.getParameter("rol");
        fEstado = request.getParameter("estado");
    }
    if (fId == null || fId.equals("0")) fId = "";

    // La ventana del formulario se abre con "+ Nuevo Usuario", con el lápiz, o si hubo un error al guardar
    boolean abrirForm = request.getParameter("nueva") != null || editar != null
            || mensajeError != null || correoDuplicado != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/usuarios.css">
    <link rel="stylesheet" href="css/ajustes.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="menu.jspf" %>

        <div class="main-content">
            <%@ include file="cabecera.jspf" %>

            <main class="content-area">
                <div class="usuarios-layout">
                    <!-- IZQUIERDA: tabla -->
                    <div class="usuarios-tabla-section">
                        <div class="section-header">
                            <h2>Directorio de Personal</h2>
                            <a class="btn btn-primary" href="UsuarioServlet?nueva=1">+ Nuevo Usuario</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr><th>ID</th><th>Nombre</th><th>Email</th><th>Rol</th><th>Estado</th><th>Acciones</th></tr>
                                </thead>
                                <tbody>
                                    <% if (usuarios == null || usuarios.isEmpty()) { %>
                                    <tr><td colspan="6" style="text-align:center;">No hay usuarios registrados.</td></tr>
                                    <% } else { for (UsuarioFila u : usuarios) {
                                           boolean esSupervisor = "Supervisor".equalsIgnoreCase(u.rol); %>
                                    <tr>
                                        <td>#<%= u.id < 10 ? "0" + u.id : String.valueOf(u.id) %></td>
                                        <td><strong><%= ver(u.nombre) %></strong></td>
                                        <td><%= ver(u.correo) %></td>
                                        <td><span class="badge <%= esSupervisor ? "badge-rol-supervisor" : "badge-rol-operario" %>"><%= ver(u.rol) %></span></td>
                                        <td><span class="badge <%= u.activo ? "badge-activo" : "badge-inactivo" %>"><%= u.activo ? "Activo" : "Inactivo" %></span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a class="btn-icon btn-edit" title="Editar" href="UsuarioServlet?editar=<%= u.id %>"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></a>
                                                <a class="btn-icon btn-delete" title="Eliminar" href="UsuarioServlet?eliminar=<%= u.id %>"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <!-- Formulario Crear / Editar usuario -->
    <div class="modal-overlay<%= abrirForm ? " active" : "" %>">
        <div class="modal-card modal-edit" style="max-width:480px;max-height:90vh;overflow-y:auto;">
            <form action="UsuarioServlet" method="post" class="form-usuario">
                                
                <div class="modal-header"><h3><%= fId.isEmpty() ? "Crear Usuario" : "Editar Usuario" %></h3></div>
                <div class="modal-body">
                    <% if (mensajeError != null) { %><div class="msg msg-error"><%= ver(mensajeError) %></div><% } %>
                    <input type="hidden" name="accion" value="guardar">
                                <input type="hidden" name="id" value="<%= ver(fId) %>">
                                <div class="form-group">
                                    <label class="form-label">Nombre Completo</label>
                                    <input type="text" name="nombre" class="form-input" placeholder="Ej: Laura Beltrán" value="<%= ver(fNombre) %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Documento</label>
                                    <input type="text" name="documento" class="form-input" placeholder="Ej: 1020304050" value="<%= ver(fDocumento) %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Correo Electrónico</label>
                                    <input type="email" name="correo" class="form-input" placeholder="ejemplo@comoencasa.com" value="<%= ver(fCorreo) %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Contrase&ntilde;a</label>
                                    <input type="password" name="clave" class="form-input" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" minlength="6" <%= fId.isEmpty() ? "required" : "" %>>
                                    <span class="form-hint"><%= fId.isEmpty() ? "Mínimo 6 caracteres" : "Déjala vacía si no quieres cambiarla" %></span>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Roles</label>
                                    <div class="radio-group">
                                        <label class="radio-btn">
                                            <input type="radio" name="rol" value="Supervisor" <%= "Supervisor".equals(fRol) ? "checked" : "" %>>
                                            <span>Supervisor</span>
                                        </label>
                                        <label class="radio-btn">
                                            <input type="radio" name="rol" value="Operario" <%= !"Supervisor".equals(fRol) ? "checked" : "" %>>
                                            <span>Operario</span>
                                        </label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Estado</label>
                                    <div class="radio-group">
                                        <label class="radio-btn">
                                            <input type="radio" name="estado" value="Activo" <%= !"Inactivo".equals(fEstado) ? "checked" : "" %>>
                                            <span>Activo</span>
                                        </label>
                                        <label class="radio-btn">
                                            <input type="radio" name="estado" value="Inactivo" <%= "Inactivo".equals(fEstado) ? "checked" : "" %>>
                                            <span>Inactivo</span>
                                        </label>
                                    </div>
                                </div>
                                </div>
                <div class="modal-footer">
                        <a class="btn btn-secondary" href="UsuarioServlet">Cancelar</a>
                        <button type="submit" class="btn btn-primary">Guardar Usuario</button>
                    </div>
                            </form>
        </div>
    </div>

    <!-- Usuario ya existe -->
    <div class="modal-overlay<%= correoDuplicado != null ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning"><h3>Usuario ya existe</h3></div>
            <div class="modal-body">
                <p>El correo <strong><%= ver(correoDuplicado) %></strong> ya está registrado en el sistema.</p>
                <p class="modal-hint">No se permite duplicar usuarios. Por favor use un correo diferente.</p>
            </div>
            <div class="modal-footer"><a class="btn btn-primary" href="UsuarioServlet">Entendido</a></div>
        </div>
    </div>

    <!-- Confirmar eliminación -->
    <div class="modal-overlay<%= eliminar != null ? " active" : "" %>">
        <div class="modal-card modal-warning">
            <form action="UsuarioServlet" method="post">
                <div class="modal-header modal-header-warning"><h3>Confirmar eliminación</h3></div>
                <div class="modal-body">
                    <% if (eliminar != null) { %>
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="id" value="<%= eliminar.id %>">
                    <p>¿Está seguro que desea eliminar a <strong><%= ver(eliminar.nombre) %></strong>?</p>
                    <% } %>
                    <p class="modal-hint">Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer">
                    <a class="btn btn-secondary" href="UsuarioServlet">Cancelar</a>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Guardado / eliminado -->
    <div class="modal-overlay<%= modalGuardado != null ? " active" : "" %>">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success"><h3>Listo</h3></div>
            <div class="modal-body"><p><%= ver(modalGuardado) %></p></div>
            <div class="modal-footer"><a class="btn btn-primary" href="UsuarioServlet">Aceptar</a></div>
        </div>
    </div>
</body>
</html>

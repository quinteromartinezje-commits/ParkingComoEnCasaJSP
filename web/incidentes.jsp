<%@ page import="modelo.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nombre = usuario.getNombre();
    String rol = usuario.getRol();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Incidentes - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/incidentes.css">
</head>
<body>
    <div class="app-container">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="sidebar-logo">
                <img src="img/logoblanco.png" alt="Logo" class="sidebar-logo-img">
                <span class="sidebar-title">Parking Como en Casa</span>
            </div>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="dashboard.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Dashboard</a></li>
                    <li><a href="ingreso.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg> Ingreso</a></li>
                    <li><a href="salida.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Salida</a></li>
                    <li><a href="tarifas.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg> Tarifas</a></li>
                    <li><a href="cupos.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Cupos</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
                    <li><a href="auditoria.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg> Auditoría</a></li>
                    <li><a href="consulta.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg> Consulta</a></li>
                    <li><a href="incidentes.jsp" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> Incidentes</a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Cerrar Sesión
                </a>
            </div>
        </aside>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="main-content">
            <header class="navbar">
                <h1 class="page-title">Registro de Incidentes</h1>
                <div class="navbar-right">
                    <button class="icon-btn" title="Notificaciones">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    </button>
                    <div class="user-info">
                        <div class="user-avatar">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        </div>
                        <div class="user-details">
    <span class="user-name"><%= nombre %></span>
    <span class="user-role"><%= rol %></span>
</div>
                    </div>
                </div>
            </header>

            <main class="content-area">
                <div class="incidentes-layout">
                    <!-- COLUMNA IZQUIERDA: INCIDENTES RECIENTES -->
                    <div class="incidentes-lista">
                        <h2>Incidentes Reportados Recientemente</h2>
                        
                        <!-- Incidente 1: Alta Prioridad -->
                        <div class="incidente-card incidente-alta">
                            <div class="incidente-header">
                                <span class="badge-prioridad badge-alta">Alta</span>
                                <span class="incidente-titulo">KLY-982</span>
                                <span class="incidente-tiempo">Hace 5 min</span>
                            </div>
                            <div class="incidente-descripcion">
                                El cliente reclama golpe leve en guardabarros trasero. Se revisan cámaras de seguridad para verificar el estado al ingreso.
                            </div>
                            <div class="incidente-footer">
                                <span class="incidente-reportado">Reportado por: Carlos Mendoza</span>
                                <span class="badge-tipo badge-reclamo">Tipo: Reclamo</span>
                            </div>
                        </div>

                        <!-- Incidente 2: Media Prioridad -->
                        <div class="incidente-card incidente-media">
                            <div class="incidente-header">
                                <span class="badge-prioridad badge-media">Media</span>
                                <span class="incidente-titulo">Infraestructura Pasillo 2</span>
                                <span class="incidente-tiempo">Hace 2 horas</span>
                            </div>
                            <div class="incidente-descripcion">
                                Lámpara LED apagada en el pasillo principal del sótano 2. Riesgo de visibilidad reducida para parqueo.
                            </div>
                            <div class="incidente-footer">
                                <span class="incidente-reportado">Reportado por: Laura Beltrán</span>
                                <span class="badge-tipo badge-novedad">Tipo: Novedad</span>
                            </div>
                        </div>

                        <!-- Incidente 3: Baja Prioridad -->
                        <div class="incidente-card incidente-baja">
                            <div class="incidente-header">
                                <span class="badge-prioridad badge-baja">Baja</span>
                                <span class="incidente-titulo">Dispensador de Tickets</span>
                                <span class="incidente-tiempo">Ayer</span>
                            </div>
                            <div class="incidente-descripcion">
                                Poco papel restante en ña tolva de entrada principal. Se programa recarga al finalizar el turno.
                            </div>
                            <div class="incidente-footer">
                                <span class="incidente-reportado">Reportado por: Pedro Gómez</span>
                                <span class="badge-tipo badge-dano">Tipo: Daño</span>
                            </div>
                        </div>
                    </div>

                    <!-- COLUMNA DERECHA: FORMULARIO NUEVO INCIDENTE -->
                    <div class="incidentes-form">
                        <div class="card">
                            <div class="card-header">
                                <h2>Nuevo Incidente</h2>
                            </div>
                            <form id="formIncidente" class="form-incidente">
                                <div class="form-group">
                                    <label class="form-label">Placa de Vehículo</label>
                                    <input type="text" id="incidentePlaca" class="form-input" placeholder="Ej: KLY-982">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Tipo de Incidente</label>
                                    <div class="radio-group horizontal">
                                        <label class="radio-btn">
                                            <input type="radio" name="tipoIncidente" value="Daño">
                                            <span>Daño</span>
                                        </label>
                                        <label class="radio-btn">
                                            <input type="radio" name="tipoIncidente" value="Novedad">
                                            <span>Novedad</span>
                                        </label>
                                        <label class="radio-btn">
                                            <input type="radio" name="tipoIncidente" value="Reclamo">
                                            <span>Reclamo</span>
                                        </label>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Descripción</label>
                                    <textarea id="incidenteDescripcion" class="form-input form-textarea" rows="3" placeholder="Describa el incidente..."></textarea>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Prioridad</label>
                                    <div class="radio-group horizontal">
                                        <label class="radio-btn prioridad-alta">
                                            <input type="radio" name="prioridad" value="Alta">
                                            <span>Alta</span>
                                        </label>
                                        <label class="radio-btn prioridad-media">
                                            <input type="radio" name="prioridad" value="Media">
                                            <span>Media</span>
                                        </label>
                                        <label class="radio-btn prioridad-baja">
                                            <input type="radio" name="prioridad" value="Baja">
                                            <span>Baja</span>
                                        </label>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Evidencia Fotográfica</label>
                                    <div class="file-upload">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                                        <span>Presione para adjuntar imagen</span>
                                        <input type="file" id="incidenteFoto" class="file-input" accept="image/*">
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block">
                                    Registrar Incidente
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/incidentes.js"></script>

</body>
</html>
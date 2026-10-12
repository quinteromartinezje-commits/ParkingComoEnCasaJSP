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
    <title>Consulta de Vehículos - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/consulta.css">
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
                    <li><a href="ReservaServlet"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Reservas</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
                    <li><a href="auditoria.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg> Auditoría</a></li>
                    <li><a href="consulta.jsp" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg> Consulta</a></li>
                    <li><a href="incidentes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> Incidentes</a></li>
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
                <h1 class="page-title">Consulta de Vehículos</h1>
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
                <!-- BUSCADOR -->
                <div class="card">
                    <div class="buscador-header">
                        <h2>Buscador General de Flota e Historial</h2>
                    </div>
                    <div class="buscador-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Placa o Ticket</label>
                                <input type="text" id="buscarPlaca" class="form-input" placeholder="Ej: KLY-982 o #TKT-10253">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Estado</label>
                                <select id="filtroEstado" class="form-input">
                                    <option value="todos">Todos</option>
                                    <option value="activo">Activo en patio</option>
                                    <option value="finalizado">Finalizado</option>
                                </select>
                            </div>
                        </div>
                      <div class="btn-group">
    <button class="btn btn-primary btn-buscar" onclick="buscarVehiculo()">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>

                            </svg>
                            Buscar
                        </button>
                    </div>
                </div>

                <!-- RESULTADOS -->
                <div class="resultados-section">
                    <h2 class="resultados-titulo">Resultados de Búsqueda</h2>
                    
                    <div class="card">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Placa</th>
                                    <th>Tipo</th>
                                    <th>Ticket</th>
                                    <th>Ingreso</th>
                                    <th>Salida</th>
                                    <th>Duración</th>
                                    <th>Monto</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Vehículo 1: Activo -->
                                <tr class="fila-principal" onclick="toggleDetalle('detalle-1')">
                                    <td><span class="badge-placa">KLY-982</span></td>
                                    <td>Camioneta</td>
                                    <td><strong>#TKT-10253</strong></td>
                                    <td>25/10/2026 - 15:28</td>
                                    <td>Activo en patio</td>
                                    <td>1h 12m</td>
                                    <td><strong>Pendiente</strong></td>
                                    <td><span class="badge badge-en-patio">En Patio</span></td>
                                </tr>
                                <tr id="detalle-1" class="fila-detalle">
                                    <td colspan="8">
                                        <div class="detalle-contenido">
                                            <div class="detalle-columna">
                                                <h4>DETALLES DEL CUPO</h4>
                                                <p><strong>Zona Asignada:</strong> A-4</p>
                                                <p><strong>Operario Registro:</strong> Carlos Mendoza</p>
                                            </div>
                                            <div class="detalle-columna">
                                                <h4>INFORMACIÓN ADICIONAL</h4>
                                                <p><strong>Convenio Comercial:</strong> Ninguno (Tarifa General)</p>
                                                <p><strong>Observaciones:</strong> Vehículo ingresa con rayón leve en puerta trasera izquierda.</p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Vehículo 2: Finalizado -->
                                <tr class="fila-principal" onclick="toggleDetalle('detalle-2')">
                                    <td><span class="badge-placa">GHB-112</span></td>
                                    <td>Carro</td>
                                    <td><strong>#TKT-10252</strong></td>
                                    <td>25/10/2026 - 13:10</td>
                                    <td>25/10/2026 - 15:15</td>
                                    <td>2h 5m</td>
                                    <td><strong>$10,000</strong></td>
                                    <td><span class="badge badge-finalizado">Finalizado</span></td>
                                </tr>
                                <tr id="detalle-2" class="fila-detalle">
                                    <td colspan="8">
                                        <div class="detalle-contenido">
                                            <div class="detalle-columna">
                                                <h4>DETALLES DEL CUPO</h4>
                                                <p><strong>Zona Asignada:</strong> A-12</p>
                                                <p><strong>Operario Registro:</strong> Laura Beltrán</p>
                                            </div>
                                            <div class="detalle-columna">
                                                <h4>INFORMACIÓN DE PAGO</h4>
                                                <p><strong>Medio de Pago:</strong> Tarjeta</p>
                                                <p><strong>Total Pagado:</strong> $10,000</p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/consulta.js"></script>

    <script>
        // Función para mostrar/ocultar detalles
        function toggleDetalle(id) {
            const detalle = document.getElementById(id);
            if (detalle.style.display === 'none' || detalle.style.display === '') {
                detalle.style.display = 'table-row';
            } else {
                detalle.style.display = 'none';
            }
        }

        // Inicializar detalles ocultos
        document.addEventListener('DOMContentLoaded', function() {
            const detalles = document.querySelectorAll('.fila-detalle');
            detalles.forEach(detalle => {
                detalle.style.display = 'none';
            });
        });

        // Función de búsqueda
        function buscarVehiculo() {
            const placa = document.getElementById('buscarPlaca').value;
            const estado = document.getElementById('filtroEstado').value;
            
            if (!placa.trim()) {
                alert('Por favor ingrese una placa o número de ticket');
                return;
            }
            
            // Aquí iría la lógica de búsqueda real
            console.log('Buscando:', placa, estado);
        }
    </script>

</body>
</html>
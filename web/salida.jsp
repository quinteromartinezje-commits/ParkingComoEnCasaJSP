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
    <title>Registro de Salida - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/salida.css">
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
                    <li><a href="salida.jsp" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg> Salida</a></li>
                    <li><a href="tarifas.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg> Tarifas</a></li>
                    <li><a href="cupos.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg> Cupos</a></li>
                    <li><a href="usuarios.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> Usuarios</a></li>
                    <li><a href="reportes.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg> Reportes</a></li>
                    <li><a href="auditoria.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg> Auditoría</a></li>
                    <li><a href="consulta.jsp"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg> Consulta</a></li>
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
                <h1 class="page-title">Registro de Salida</h1>
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
                <div class="salida-layout">
                    <!-- COLUMNA IZQUIERDA -->
                    <div class="salida-columna-izquierda">
                        <!-- BÚSQUEDA -->
                        <div class="card">
                            <div class="card-header"><h2>Búsqueda de Registro</h2></div>
                            <div class="search-box">
                                <div class="search-input-wrapper">
                                    <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"/>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                                    </svg>
                                    <input type="text" id="buscarPlaca" placeholder="Ingrese placa o número de ticket" maxlength="10">
                                    <svg class="search-check" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#3366cc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="20 6 9 17 4 12"/>
                                    </svg>
                                </div>
                                <button id="btnBuscar" class="btn btn-primary btn-search" onclick="buscarVehiculo()">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="20 6 9 17 4 12"/>
                                    </svg>
                                </button>
                            </div>
                            <p class="search-hint">Ingrese la placa del vehículo o número de ticket para el cálculo automático de tarifa.</p>
                        </div>

                        <!-- DETALLE DE ESTADÍA -->
                        <div class="card" id="cardDetalle">
                            <div class="card-header"><h2>Detalle de Estadía</h2></div>
                            <div class="detalle-grid">
                                <div class="detalle-row">
                                    <span class="detalle-label">Placa</span>
                                    <span class="detalle-value placa" id="detallePlaca">GHB-112</span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Tipo de Vehículo</span>
                                    <span class="detalle-value" id="detalleTipo">Carro Sedán</span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Ticket Asociado</span>
                                    <span class="detalle-value ticket" id="detalleTicket">#TKT-10252</span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Hora de Ingreso</span>
                                    <span class="detalle-value" id="detalleHoraIngreso">25/10/2026 - 12:15</span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Hora de Salida (Estimada)</span>
                                    <span class="detalle-value" id="detalleHoraSalida">25/10/2026 - 15:30</span>
                                </div>
                                <div class="detalle-row">
                                    <span class="detalle-label">Tiempo Transcurrido</span>
                                    <span class="detalle-value highlight" id="detalleTiempo">3 horas, 15 minutos</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- COLUMNA DERECHA -->
                    <div class="salida-columna-derecha">
                        <!-- LIQUIDACIÓN -->
                        <div class="card" id="cardLiquidacion">
                            <div class="card-header"><h2>Liquidación e Importe</h2></div>
                            <div class="liquidacion-grid">
                                <div class="liquidacion-row">
                                    <span class="liquidacion-label">Tarifa Base (Primera hora o fracción)</span>
                                    <span class="liquidacion-value" id="liqTarifaBase">$5,000</span>
                                </div>
                                <div class="liquidacion-row">
                                    <span class="liquidacion-label">Fracciones Adicionales (<span id="liqFracciones">9</span> x $1,250)</span>
                                    <span class="liquidacion-value" id="liqFraccionesTotal">$11,250</span>
                                </div>
                                <div class="liquidacion-row" id="liqRecargoRow">
                                    <span class="liquidacion-label">Recargo por Horario Nocturno</span>
                                    <span class="liquidacion-value" id="liqRecargo">$0</span>
                                </div>
                                <div class="liquidacion-row total">
                                    <span class="liquidacion-label">Total a Pagar</span>
                                    <span class="liquidacion-value total-amount" id="liqTotal">$16,250</span>
                                </div>
                            </div>

                            <!-- MEDIO DE PAGO -->
                            <div class="medio-pago-section">
                                <h3 class="medio-pago-title">Medio de Pago</h3>
                                <div class="medio-pago-buttons">
                                    <button class="medio-pago-btn active" data-medio="Efectivo">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/>
                                        </svg>
                                        Efectivo
                                    </button>
                                    <button class="medio-pago-btn" data-medio="Tarjeta">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/>
                                        </svg>
                                        Tarjeta
                                    </button>
                                    <button class="medio-pago-btn" data-medio="QR/Transferencia">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
                                        </svg>
                                        QR / Transferencia
                                    </button>
                                </div>
                            </div>

                            <!-- BOTONES -->
                            <div class="action-buttons">
                                <button id="btnCompletar" class="btn btn-primary btn-large">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
                                    </svg>
                                    Completar Pago y Registrar Salida
                                </button>
                                <button id="btnCancelar" class="btn btn-secondary btn-large">Cancelar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script src="js/salida.js"></script>

    <!-- MODALES -->
    
    <!-- MODAL: Vehículo no encontrado -->
    <div id="modalNoEncontrado" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <!-- Ícono corregido a triángulo de advertencia -->
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Vehículo no encontrado</h3>
            </div>
            <div class="modal-body">
                <p>No se encontró ningún vehículo con la placa o ticket ingresado.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalNoEncontrado')">Entendido</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Salida Exitosa -->
    <div id="modalSalidaExitosa" class="modal-overlay">
        <div class="modal-card modal-success">
            <div class="modal-header modal-header-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
                <h3>Salida registrada exitosamente</h3>
            </div>
            <div class="modal-body">
                <div class="tiquete-preview">
                    <div class="tiquete-header">
                        <strong>Parking Como en Casa</strong>
                        <span>Tiquete de Salida</span>
                    </div>
                    <div class="tiquete-body">
                        <div class="tiquete-row"><span class="tiquete-label">Placa:</span><span class="tiquete-value" id="tiquetePlaca"></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Hora Salida:</span><span class="tiquete-value" id="tiqueteHoraSalida"></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Total Pagado:</span><span class="tiquete-value" id="tiqueteTotal"></span></div>
                        <div class="tiquete-row"><span class="tiquete-label">Medio de Pago:</span><span class="tiquete-value" id="tiqueteMedioPago"></span></div>
                        <div class="tiquete-row tiquete-ticket"><span class="tiquete-label">Cupo Liberado:</span><span class="tiquete-value" id="tiqueteCupo"></span></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="cerrarModal('modalSalidaExitosa')">Cerrar</button>
                <button class="btn btn-primary" onclick="imprimirTiqueteSalida()">Imprimir</button>
            </div>
        </div>
    </div>

    <!-- MODAL: Campo vacío -->
    <div id="modalCampoVacio" class="modal-overlay">
        <div class="modal-card modal-warning">
            <div class="modal-header modal-header-warning">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <h3>Campo vacío</h3>
            </div>
            <div class="modal-body">
                <p>Por favor ingrese una placa o número de ticket para buscar el registro.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="cerrarModal('modalCampoVacio')">Entendido</button>
            </div>
        </div>
    </div>

  <!-- MODAL: Confirmar cancelación de salida -->
<div id="modalConfirmarCancelacion" class="modal-overlay">
    <div class="modal-card modal-warning">
        <div class="modal-header modal-header-warning">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                <line x1="12" y1="9" x2="12" y2="13"/>
                <line x1="12" y1="17" x2="12.01" y2="17"/>
            </svg>
            <h3>Confirmar cancelación</h3>
        </div>
        <div class="modal-body">
            <p>¿Está seguro de cancelar el registro de salida?</p>
            <p class="modal-hint">Los datos ingresados se perderán y deberá iniciar la búsqueda nuevamente.</p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="cerrarModal('modalConfirmarCancelacion')">No, continuar</button>
            <button class="btn btn-danger" onclick="confirmarCancelacion()">Sí, cancelar salida</button>
        </div>
    </div>
</div>

</body>
</html>
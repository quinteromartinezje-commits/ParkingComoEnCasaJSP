<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Parking Como en Casa</title>
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

    <div class="login-container">
        
        <!-- COLUMNA IZQUIERDA: Ilustración -->
        <div class="login-illustration">
            <img src="img/ilustracion.png" alt="Ilustración de parqueadero" class="ilustracion-img">
        </div>

        <!-- COLUMNA DERECHA: Formulario -->
        <div class="login-form-side">
            
            <img src="img/logoazulyamarillo.png" alt="Logo Parking Como en Casa" class="login-logo">
            
            <h1 class="login-title">Iniciar Sesión</h1>
            <p class="login-subtitle">Sistema de Gestión de Parqueo</p>

            <!-- Mostrar mensaje de error si existe -->
            <% String mensajeError = (String) request.getAttribute("mensajeError"); %>
            <% if (mensajeError != null) { %>
                <div class="alert alert-error" style="color: red; margin-bottom: 15px; text-align: center;">
                    <%= mensajeError %>
                </div>
            <% } %>

            <!-- Formulario conectado a Java -->
            <form action="LoginServlet" method="post" class="login-form" id="loginForm" novalidate>
    
                <div class="form-group">
                    <label for="correo">Correo electrónico</label>
                    <div class="input-wrapper">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#54595d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="4" width="20" height="16" rx="2"/>
                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                        </svg>
                        <input type="email" id="correo" name="correo" class="form-control" placeholder="admin@comoencasa.com" required>
                    </div>
                    <span class="error-message" id="error-correo">Por favor, ingresa un correo válido</span>
                </div>

                <div class="form-group">
                    <label for="password">Contraseña</label>
                    <div class="input-wrapper">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#54595d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        <button type="button" class="toggle-password" id="togglePassword">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#54595d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <span class="error-message" id="error-password">Por favor, ingresa tu contraseña</span>
                </div>

                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" id="recuerdame" name="recuerdame">
                        <span>Recuérdame</span>
                    </label>
                    <a href="#" class="forgot-link">¿Olvidaste tu contraseña?</a>
                </div>

                <button type="submit" class="btn-login">INGRESAR AL SISTEMA</button>
                
            </form>
        </div>

    </div>
            
    <script src="js/main.js"></script>
    <script src="js/login.js"></script>
</body>
</html>
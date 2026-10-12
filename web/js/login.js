document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('loginForm');
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');

    // Toggle mostrar/ocultar contraseña
    if (togglePassword && passwordInput) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
        });
    }

    // Validación de formulario
    if (form) {
        form.addEventListener('submit', function(e) {
            const correo = document.getElementById('correo');
            const password = document.getElementById('password');
            const errorCorreo = document.getElementById('error-correo');
            const errorPassword = document.getElementById('error-password');
            
            let valido = true;

            // 1. Validar correo (solo si está vacío o no tiene @)
            if (!correo.value.trim() || !correo.value.includes('@')) {
                errorCorreo.classList.add('visible');
                correo.classList.add('error');
                valido = false;
            } else {
                errorCorreo.classList.remove('visible');
                correo.classList.remove('error');
            }

            // 2. Validar contraseña (SOLO si está vacía)
            if (!password.value.trim()) {
                errorPassword.classList.add('visible');
                password.classList.add('error');
                valido = false;
            } else {
                errorPassword.classList.remove('visible');
                password.classList.remove('error');
            }

            // 3. Si NO es válido, detenemos el envío a Java
            if (!valido) {
                e.preventDefault(); 
            }
            // Si ES válido, NO hacemos preventDefault, y el formulario viaja feliz a LoginServlet
        });

        // Limpiar errores al escribir
        ['correo', 'password'].forEach(id => {
            const input = document.getElementById(id);
            if (input) {
                input.addEventListener('input', function() {
                    this.classList.remove('error');
                    const errorElement = document.getElementById('error-' + id);
                    if(errorElement) errorElement.classList.remove('visible');
                });
            }
        });
    }
});
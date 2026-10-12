document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formIngreso');
    const placaInput = document.getElementById('placa');
    const fechaHoraInput = document.getElementById('fechaHora');
    const cupoSelect = document.getElementById('cupo');
    const vehicleBtns = document.querySelectorAll('.vehicle-btn');

    // 1. Fecha y hora automática
    if (fechaHoraInput) {
        const ahora = new Date();
        fechaHoraInput.value = ahora.toLocaleString('es-CO', { 
            year: 'numeric', month: '2-digit', day: '2-digit', 
            hour: '2-digit', minute: '2-digit' 
        });
    }

    // 2. Mayúsculas en placa y ocultar error al escribir
    if (placaInput) {
        placaInput.addEventListener('input', function (e) {
            e.target.value = e.target.value.toUpperCase();
            ocultarError('error-placa', placaInput);
        });
    }

    // 3. Botones de tipo de vehículo - Agregar clase 'selected' cuando se marcan
    vehicleBtns.forEach(function(btn) {
        const radio = btn.querySelector('input[type="radio"]');
        if (radio) {
            radio.addEventListener('change', function() {
                // Quitar 'selected' de todos los botones
                vehicleBtns.forEach(function(b) {
                    b.classList.remove('selected');
                });
                // Agregar 'selected' al botón que contiene el radio marcado
                if (this.checked) {
                    btn.classList.add('selected');
                }
                // Ocultar error de tipo
                ocultarError('error-tipo', null);
            });
        }
    });

    // 4. Ocultar error de cupo al seleccionar
    if (cupoSelect) {
        cupoSelect.addEventListener('change', function() {
            ocultarError('error-cupo', cupoSelect);
        });
    }

    // 5. Validación personalizada al enviar
    if (form) {
        form.addEventListener('submit', function(e) {
            let valido = true;

            // Validar placa
            if (!placaInput || placaInput.value.trim() === '') {
                mostrarError('error-placa', placaInput);
                valido = false;
            }

            // Validar tipo
            const tipoSeleccionado = document.querySelector('input[name="tipo"]:checked');
            if (!tipoSeleccionado) {
                mostrarError('error-tipo', null);
                valido = false;
            }

            // Validar cupo
            if (!cupoSelect || cupoSelect.value === '') {
                mostrarError('error-cupo', cupoSelect);
                valido = false;
            }

            // Si algo falla, detener el envío
            if (!valido) {
                e.preventDefault();
            }
            // Si todo está bien, dejar que el formulario viaje al Servlet
        });
    }

    // Funciones auxiliares
    function mostrarError(errorId, inputElement) {
        const errorElement = document.getElementById(errorId);
        if (errorElement) {
            errorElement.classList.add('visible');
        }
        if (inputElement) {
            inputElement.classList.add('error');
        }
    }

    function ocultarError(errorId, inputElement) {
        const errorElement = document.getElementById(errorId);
        if (errorElement) {
            errorElement.classList.remove('visible');
        }
        if (inputElement) {
            inputElement.classList.remove('error');
        }
    }
});

// Funciones para modales
function cerrarModal(idModal) {
    const modal = document.getElementById(idModal);
    if (modal) modal.classList.remove('active');
}

function irAConsulta() {
    window.location.href = 'consulta.jsp';
}

function imprimirTiquete() {
    window.print();
}
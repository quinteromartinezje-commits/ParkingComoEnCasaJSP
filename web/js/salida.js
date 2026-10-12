// ============================================
// Salida de vehículos (la búsqueda y el pago los hace SalidaServlet)
// ============================================
document.addEventListener('DOMContentLoaded', function () {
    var formBuscar = document.getElementById('formBuscar');
    var buscarInput = document.getElementById('buscarPlaca');
    var btnCancelar = document.getElementById('btnCancelar');
    var medioPago = document.getElementById('medioPago');

    // Si el campo está vacío, mostramos el aviso sin ir al servidor
    if (formBuscar) {
        formBuscar.addEventListener('submit', function (e) {
            if (buscarInput.value.trim() === '') {
                e.preventDefault();
                abrirModal('modalCampoVacio');
            }
        });
    }

    // La placa o el ticket siempre en mayúsculas
    if (buscarInput) {
        buscarInput.addEventListener('input', function () {
            buscarInput.value = buscarInput.value.toUpperCase();
        });
    }

    // Selección del medio de pago: guardamos la opción en el campo oculto que se envía por POST
    document.querySelectorAll('.medio-pago-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.medio-pago-btn').forEach(function (b) { b.classList.remove('active'); });
            this.classList.add('active');
            if (medioPago) medioPago.value = this.dataset.medio;
        });
    });

    if (btnCancelar) {
        btnCancelar.addEventListener('click', function () {
            abrirModal('modalConfirmarCancelacion');
        });
    }
});

function imprimirTiqueteSalida() {
    window.print();
}

// Cancelar: volvemos a la pantalla de salida vacía
function confirmarCancelacion() {
    window.location.href = 'SalidaServlet';
}

document.addEventListener('DOMContentLoaded', function() {
    const btnBuscar = document.getElementById('btnBuscar');
    const btnCompletar = document.getElementById('btnCompletar');
    const btnCancelar = document.getElementById('btnCancelar');
    const buscarInput = document.getElementById('buscarPlaca');

    if (btnBuscar) {
        btnBuscar.addEventListener('click', buscarVehiculo);
    }

    if (btnCompletar) {
        btnCompletar.addEventListener('click', function() {
            const medioPago = document.querySelector('.medio-pago-btn.active');
            const medio = medioPago ? medioPago.dataset.medio : 'Efectivo';

            document.getElementById('tiquetePlaca').textContent = document.getElementById('detallePlaca').textContent;
            document.getElementById('tiqueteHoraSalida').textContent = new Date().toLocaleString('es-CO');
            document.getElementById('tiqueteTotal').textContent = document.getElementById('liqTotal').textContent;
            document.getElementById('tiqueteMedioPago').textContent = medio;
            document.getElementById('tiqueteCupo').textContent = 'A-12';

            abrirModal('modalSalidaExitosa');
        });
    }

    if (btnCancelar) {
    btnCancelar.addEventListener('click', function() {
        //  ANTES (confirm nativo feo):
        // if (confirm('¿Está seguro de cancelar la salida?')) {
        //     buscarInput.value = '';
        // }

        // ✅ AHORA (modal personalizado):
        abrirModal('modalConfirmarCancelacion');
    });
}

    // Selección de medio de pago
    document.querySelectorAll('.medio-pago-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.medio-pago-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
});

function buscarVehiculo() {
    const placa = document.getElementById('buscarPlaca').value.trim();
    if (!placa) {
        abrirModal('modalCampoVacio');
        return;
    }

    // Simular búsqueda
    if (placa.toUpperCase() === 'XYZ-999') {
        abrirModal('modalNoEncontrado');
    } else {
        // Mostrar datos de ejemplo
        document.getElementById('detallePlaca').textContent = placa.toUpperCase();
    }
}

function imprimirTiqueteSalida() {
    window.print();
}

function confirmarCancelacion() {
    // Limpiar el campo de búsqueda
    const buscarInput = document.getElementById('buscarPlaca');
    if (buscarInput) {
        buscarInput.value = '';
    }

    // Cerrar el modal
    cerrarModal('modalConfirmarCancelacion');

    // Opcional: mostrar mensaje de éxito
    console.log('Salida cancelada correctamente');
}
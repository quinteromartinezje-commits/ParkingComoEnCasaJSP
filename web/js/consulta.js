function toggleDetalle(id) {
    const detalle = document.getElementById(id);
    if (detalle) {
        if (detalle.style.display === 'table-row') {
            detalle.style.display = 'none';
        } else {
            detalle.style.display = 'table-row';
        }
    }
}

function buscarVehiculo() {
    const placa = document.getElementById('buscarPlaca').value.trim();
    const estado = document.getElementById('filtroEstado').value;

    if (!placa) {
        alert('Ingrese una placa o número de ticket');
        return;
    }

    alert('Buscando: ' + placa + ' (Estado: ' + estado + ')');
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.fila-detalle').forEach(d => {
        d.style.display = 'none';
    });
});
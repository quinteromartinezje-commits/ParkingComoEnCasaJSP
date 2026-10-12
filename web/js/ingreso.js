document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formIngreso');
    const btnRegistrar = document.getElementById('btnRegistrar');
    const placaInput = document.getElementById('placa');
    const fechaHoraInput = document.getElementById('fechaHora');
    const cupoInput = document.getElementById('cupo');
    const ticketCode = document.getElementById('ticketCode');

    // Establecer fecha y hora actual
    function actualizarFechaHora() {
        const ahora = new Date();
        const fecha = ahora.toLocaleDateString('es-CO');
        const hora = ahora.toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' });
        if (fechaHoraInput) fechaHoraInput.value = `${fecha} - ${hora}`;
    }
    actualizarFechaHora();

    // Generar ticket aleatorio
    function generarTicket() {
        const numero = Math.floor(Math.random() * 9000) + 1000;
        if (ticketCode) ticketCode.textContent = `#TKT-2026-${numero}`;
    }
    generarTicket();

    // Asignar cupo aleatorio
    function asignarCupo() {
        const cupos = ['A-14', 'A-22', 'M-3', 'C-7'];
        const cupo = cupos[Math.floor(Math.random() * cupos.length)];
        if (cupoInput) cupoInput.value = `${cupo} (Disponible)`;
    }
    asignarCupo();

    // Habilitar botón cuando hay datos
    function verificarFormulario() {
        const placa = placaInput?.value.trim();
        const tipo = document.querySelector('input[name="tipo"]:checked');
        if (btnRegistrar) {
            btnRegistrar.disabled = !(placa && tipo);
        }
    }

    if (placaInput) placaInput.addEventListener('input', verificarFormulario);
    document.querySelectorAll('input[name="tipo"]').forEach(r => {
        r.addEventListener('change', verificarFormulario);
    });

    // Submit del formulario
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const placa = placaInput.value.trim();
            const tipo = document.querySelector('input[name="tipo"]:checked');

            if (!placa || !tipo) {
                abrirModal('modalDatosIncompletos');
                return;
            }

            // Simular placa duplicada (ejemplo)
            if (placa.toUpperCase() === 'ABC-123') {
                document.getElementById('placaDuplicada').textContent = placa;
                abrirModal('modalPlacaDuplicada');
                return;
            }

            // Llenar tiquete
            document.getElementById('tiquetePlaca').textContent = placa;
            document.getElementById('tiqueteTipo').textContent = tipo.value;
            document.getElementById('tiqueteCupo').textContent = cupoInput.value;
            document.getElementById('tiqueteHora').textContent = fechaHoraInput.value;
            document.getElementById('tiqueteCodigo').textContent = ticketCode.textContent;

            abrirModal('modalExito');
        });
    }
});

function irAConsulta() {
    cerrarModal('modalPlacaDuplicada');
    window.location.href = 'consulta.html';
}

function imprimirTiquete() {
    window.print();
}
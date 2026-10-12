document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formUsuario');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            const nombre = document.getElementById('usuarioNombre').value;
            const email = document.getElementById('usuarioEmail').value;

            if (!nombre || !email) {
                alert('Complete todos los campos obligatorios');
                return;
            }

            // Simular usuario duplicado
            if (email === 'c.mendoza@comoencasa.com') {
                document.getElementById('emailDuplicado').textContent = email;
                abrirModal('modalUsuarioExiste');
                return;
            }

            abrirModal('modalUsuarioGuardado');
            form.reset();
        });
    }
});

function editarUsuario(id) {
    alert('Editando usuario #' + id);
}

function eliminarUsuario(id) {
    abrirModal('modalConfirmarEliminar');
}

function confirmarEliminacion() {
    cerrarModal('modalConfirmarEliminar');
    alert('Usuario eliminado');
}
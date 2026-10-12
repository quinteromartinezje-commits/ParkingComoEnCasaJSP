document.addEventListener('DOMContentLoaded', function() {
    const btnEditar = document.querySelector('.btn-editar-perfil');
    if (btnEditar) {
        btnEditar.addEventListener('click', function() {
            alert('Función de edición de perfil');
        });
    }

    const btnCambiarPass = document.querySelectorAll('.btn-sm');
    btnCambiarPass.forEach(btn => {
        btn.addEventListener('click', function() {
            alert('Cambiando configuración de seguridad');
        });
    });
});
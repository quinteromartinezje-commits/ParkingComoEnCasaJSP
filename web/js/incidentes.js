document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formIncidente');
    const fileInput = document.getElementById('incidenteFoto');
    const fileUpload = document.querySelector('.file-upload');

    if (fileUpload && fileInput) {
        fileUpload.addEventListener('click', () => fileInput.click());
        fileInput.addEventListener('change', function() {
            if (this.files.length > 0) {
                fileUpload.querySelector('span').textContent = 'Archivo: ' + this.files[0].name;
            }
        });
    }

    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            const placa = document.getElementById('incidentePlaca').value;
            const tipo = document.querySelector('input[name="tipoIncidente"]:checked');
            const descripcion = document.getElementById('incidenteDescripcion').value;
            const prioridad = document.querySelector('input[name="prioridad"]:checked');

            if (!placa || !tipo || !descripcion || !prioridad) {
                alert('Complete todos los campos obligatorios');
                return;
            }

            alert('Incidente registrado exitosamente');
            form.reset();
        });
    }
});
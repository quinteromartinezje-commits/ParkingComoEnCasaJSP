// ============================================
// FUNCIONES GLOBALES - Parking Como en Casa
// ============================================

// Abrir modal
function abrirModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.classList.add('active');
        console.log('Modal abierto:', id);
    } else {
        console.warn('Modal no encontrado:', id);
    }
}

// Cerrar modal
function cerrarModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.classList.remove('active');
        console.log('Modal cerrado:', id);
    }
}

// Cerrar modal al hacer clic fuera
document.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('active');
    }
});

// Cerrar modal con tecla ESC
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
            modal.classList.remove('active');
        });
    }
});

// ============================================
// INICIALIZACIÓN GLOBAL
// ============================================
document.addEventListener('DOMContentLoaded', function() {
    console.log('Sistema cargado correctamente');

    // 1. Botones de tipo de vehículo (Ingreso)
    document.querySelectorAll('.vehicle-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.vehicle-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            const radio = this.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
        });
    });

    // 2. Botones de medio de pago (Salida)
    document.querySelectorAll('.medio-pago-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.medio-pago-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // 3. Radio buttons genéricos (Usuarios, Incidentes)
    document.querySelectorAll('.radio-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const radio = this.querySelector('input[type="radio"]');
            if (radio) {
                const name = radio.name;
                document.querySelectorAll(`.radio-btn input[name="${name}"]`).forEach(r => {
                    r.closest('.radio-btn').classList.remove('active');
                });
                this.classList.add('active');
                radio.checked = true;
            }
        });
    });

    // 4. Botones de paginación (Auditoría)
    document.querySelectorAll('.btn-pagina').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.btn-pagina').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // 5. Tabs de nivel/piso (Cupos)
    document.querySelectorAll('.nivel-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.nivel-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // 6. Botones de editar/eliminar (Tarifas, Usuarios)
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            console.log('Editar clicked');
        });
    });

    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            console.log('Eliminar clicked');
        });
    });
});
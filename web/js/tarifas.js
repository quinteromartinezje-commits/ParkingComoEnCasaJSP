// ============================================
// GESTIÓN DE TARIFAS - Parking Como en Casa
// ============================================

document.addEventListener('DOMContentLoaded', function() {
    const btnNuevaTarifa = document.getElementById('btnNuevaTarifa');
    if (btnNuevaTarifa) {
        btnNuevaTarifa.addEventListener('click', function() {
            // Limpiar formulario antes de abrir
            limpiarFormularioNuevaTarifa();
            abrirModal('modalNuevaTarifa');
        });
    }
});

// ============================================
// FUNCIÓN: Guardar nueva tarifa
// ============================================
function guardarTarifa() {
    const tipo = document.getElementById('tarifaTipo').value;
    const precio = parseFloat(document.getElementById('tarifaPrecio').value);
    const fraccion = parseFloat(document.getElementById('tarifaFraccion').value);
    const recargo = parseFloat(document.getElementById('tarifaRecargo').value);

    // Validación 1: Tipo de vehículo seleccionado
    if (!tipo) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Por favor seleccione un tipo de vehículo.';
        return;
    }

    // Validación 2: Valores negativos o nulos (CU 1a)
    if (isNaN(precio) || precio <= 0) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Valor inválido: La tarifa por hora debe ser mayor a $0.';
        return;
    }

    if (isNaN(fraccion) || fraccion <= 0) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Valor inválido: La tarifa por fracción debe ser mayor a $0.';
        return;
    }

    if (isNaN(recargo) || recargo < 0) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Valor inválido: El recargo nocturno no puede ser negativo.';
        return;
    }

    // Simulación de guardado (CU 2b - Error de base de datos)
    // En un sistema real, aquí harías una petición al servidor
    const simulacionExito = Math.random() > 0.2; // 80% de éxito, 20% de error

    if (simulacionExito) {
        cerrarModal('modalNuevaTarifa');
        abrirModal('modalExito');
        console.log('Tarifa guardada:', { tipo, precio, fraccion, recargo });
    } else {
        // CU 2b: Error de guardado - mantener tarifa anterior
        abrirModal('modalErrorGuardado');
        console.warn('Error al guardar la tarifa. Se mantiene la configuración anterior.');
    }
}

// ============================================
// FUNCIÓN: Editar tarifa
// ============================================
function editarTarifa(id) {
    // Simular datos de la tarifa según el ID
    const tarifas = {
        1: { tipo: 'Carro', precio: 5000, fraccion: 1250, recargo: 1500 },
        2: { tipo: 'Moto', precio: 2500, fraccion: 625, recargo: 800 },
        3: { tipo: 'Camioneta', precio: 6500, fraccion: 1625, recargo: 2000 }
    };

    const tarifa = tarifas[id];
    if (tarifa) {
        document.getElementById('editTarifaTipo').value = tarifa.tipo;
        document.getElementById('editTarifaPrecio').value = tarifa.precio;
        document.getElementById('editTarifaFraccion').value = tarifa.fraccion;
        document.getElementById('editTarifaRecargo').value = tarifa.recargo;
        
        // Guardar el ID para usarlo al actualizar
        document.getElementById('editTarifaTipo').dataset.id = id;
        
        abrirModal('modalEditarTarifa');
    }
}

// ============================================
// FUNCIÓN: Actualizar tarifa existente
// ============================================
function actualizarTarifa() {
    const id = document.getElementById('editTarifaTipo').dataset.id;
    const tipo = document.getElementById('editTarifaTipo').value;
    const precio = parseFloat(document.getElementById('editTarifaPrecio').value);
    const fraccion = parseFloat(document.getElementById('editTarifaFraccion').value);
    const recargo = parseFloat(document.getElementById('editTarifaRecargo').value);

    // Validación: Valores negativos o nulos (CU 1a)
    if (isNaN(precio) || precio <= 0) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Valor inválido: La tarifa por hora debe ser mayor a $0.';
        return;
    }

    if (isNaN(fraccion) || fraccion <= 0) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Valor inválido: La tarifa por fracción debe ser mayor a $0.';
        return;
    }

    if (isNaN(recargo) || recargo < 0) {
        abrirModal('modalValorInvalido');
        document.getElementById('mensajeError').textContent = 'Valor inválido: El recargo nocturno no puede ser negativo.';
        return;
    }

    // Simulación de actualización (CU 2b)
    const simulacionExito = Math.random() > 0.2;

    if (simulacionExito) {
        cerrarModal('modalEditarTarifa');
        abrirModal('modalExito');
        console.log('Tarifa actualizada:', { id, tipo, precio, fraccion, recargo });
    } else {
        // CU 2b: Error de guardado - mantener tarifa anterior
        abrirModal('modalErrorGuardado');
        console.warn('Error al actualizar la tarifa. Se mantiene la configuración anterior.');
    }
}

// ============================================
// FUNCIÓN: Eliminar tarifa
// ============================================
function eliminarTarifa(id) {
    // Guardar el ID para usarlo en la confirmación
    document.getElementById('btnConfirmarEliminar').dataset.id = id;
    abrirModal('modalConfirmarEliminar');
}

function confirmarEliminacion() {
    const id = document.getElementById('btnConfirmarEliminar').dataset.id;
    
    // Simulación de eliminación (CU 2b)
    const simulacionExito = Math.random() > 0.2;

    if (simulacionExito) {
        cerrarModal('modalConfirmarEliminar');
        abrirModal('modalExito');
        document.querySelector('#modalExito .modal-body p').textContent = 'La tarifa ha sido eliminada correctamente.';
        console.log('Tarifa eliminada:', id);
    } else {
        abrirModal('modalErrorGuardado');
        console.warn('Error al eliminar la tarifa. Se mantiene la configuración anterior.');
    }
}

// ============================================
// FUNCIÓN AUXILIAR: Limpiar formulario
// ============================================
function limpiarFormularioNuevaTarifa() {
    document.getElementById('tarifaTipo').value = '';
    document.getElementById('tarifaPrecio').value = '';
    document.getElementById('tarifaFraccion').value = '';
    document.getElementById('tarifaRecargo').value = '';
}
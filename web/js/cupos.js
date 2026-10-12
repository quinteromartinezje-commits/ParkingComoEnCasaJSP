// ============================================
// GESTIÓN DE CUPOS - Parking Como en Casa
// ============================================

// Estado actual de TODOS los cupos (Piso 1, Piso 2 y Piso 3 Motos)
const estadoCupos = {
    // Piso 1
    'P1-1': { estado: 'disponible', tipo: 'carro' },
    'P1-2': { estado: 'disponible', tipo: 'carro' },
    'P1-3': { estado: 'ocupado', tipo: 'carro'    },
    'P1-4': { estado: 'disponible', tipo: 'carro' },
    'P1-5': { estado: 'disponible', tipo: 'carro' },
    'P1-6': { estado: 'reservado', tipo: 'carro' },
    'P1-7': { estado: 'disponible', tipo: 'carro' },
    'P1-8': { estado: 'disponible', tipo: 'carro' },
    'P1-9': { estado: 'ocupado', tipo: 'carro' },
    'P1-10': { estado: 'disponible', tipo: 'carro' },
    
    // Piso 2
    'P2-1': { estado: 'reservado', tipo: 'carro' },
    'P2-2': { estado: 'disponible', tipo: 'carro' },
    'P2-3': { estado: 'disponible', tipo: 'carro' },
    'P2-4': { estado: 'disponible', tipo: 'carro' },
    'P2-5': { estado: 'ocupado', tipo: 'carro' },
    'P2-6': { estado: 'disponible', tipo: 'carro' },
    'P2-7': { estado: 'disponible', tipo: 'carro' },
    'P2-8': { estado: 'disponible', tipo: 'carro' },
    'P2-9': { estado: 'ocupado', tipo: 'carro' },
    'P2-10': { estado: 'reservado', tipo: 'carro' },
    'P2-11': { estado: 'disponible', tipo: 'carro' },
    'P2-12': { estado: 'disponible', tipo: 'carro' },
    'P2-13': { estado: 'ocupado', tipo: 'carro' },
    'P2-14': { estado: 'disponible', tipo: 'carro' },
    'P2-15': { estado: 'disponible', tipo: 'carro' },
    'P2-16': { estado: 'disponible', tipo: 'carro' },
    'P2-17': { estado: 'ocupado', tipo: 'carro' },
    'P2-18': { estado: 'disponible', tipo: 'carro' },
    'P2-19': { estado: 'reservado', tipo: 'carro' },
    'P2-20': { estado: 'disponible', tipo: 'carro' },
    'P2-21': { estado: 'ocupado', tipo: 'carro' },
    'P2-22': { estado: 'disponible', tipo: 'carro' },
    'P2-23': { estado: 'disponible', tipo: 'carro' },
    'P2-24': { estado: 'disponible', tipo: 'carro' },
    'P2-25': { estado: 'ocupado', tipo: 'carro' },
    'P2-26': { estado: 'disponible', tipo: 'carro' },
    'P2-27': { estado: 'disponible', tipo: 'carro' },
    'P2-28': { estado: 'reservado', tipo: 'carro' },
    'P2-29': { estado: 'ocupado', tipo: 'carro' },
    'P2-30': { estado: 'disponible', tipo: 'carro' },
    'P2-31': { estado: 'disponible', tipo: 'carro' },
    'P2-32': { estado: 'disponible', tipo: 'carro' },
    'P2-33': { estado: 'ocupado', tipo: 'carro' },
    'P2-34': { estado: 'disponible', tipo: 'carro' },
    'P2-35': { estado: 'disponible', tipo: 'carro' },
    'P2-36': { estado: 'disponible', tipo: 'carro' },

    // Piso 3 - Motos
    'M-1': { estado: 'disponible', tipo: 'moto' },
    'M-2': { estado: 'ocupado', tipo: 'moto' },
    'M-3': { estado: 'disponible', tipo: 'moto' },
    'M-4': { estado: 'disponible', tipo: 'moto' },
    'M-5': { estado: 'reservado', tipo: 'moto' },
    'M-6': { estado: 'disponible', tipo: 'moto' },
    'M-7': { estado: 'disponible', tipo: 'moto' },
    'M-8': { estado: 'ocupado', tipo: 'moto' }
};

let cupoActual = null;

document.addEventListener('DOMContentLoaded', function() {
    console.log('Cupos.js cargado correctamente');
    
    // Click en los cupos
    document.querySelectorAll('.cupo-card').forEach(cupo => {
        cupo.addEventListener('click', function() {
            const codigo = this.dataset.codigo;
            const info = estadoCupos[codigo];
            
            if (!info) return;
            
            if (info.estado === 'disponible') {
                cupoActual = codigo;
                document.getElementById('cupoSeleccionado').textContent = codigo;
                document.getElementById('placaVehiculo').value = '';
                document.querySelectorAll('input[name="tipoVehiculo"]').forEach(r => r.checked = false);
                document.querySelectorAll('.radio-btn').forEach(b => b.classList.remove('active'));
                abrirModal('modalAsignarVehiculo');
            } else if (info.estado === 'ocupado') {
                document.getElementById('mensajeCeldaOcupada').innerHTML = 
                    `El cupo <strong>${codigo}</strong> ya está ocupado por el vehículo con placa <strong>${info.placa}</strong>.`;
                abrirModal('modalCeldaOcupada');
            } else if (info.estado === 'reservado') {
                document.getElementById('mensajeCeldaOcupada').innerHTML = 
                    `El cupo <strong>${codigo}</strong> está reservado.`;
                abrirModal('modalCeldaOcupada');
            }
        });
    });

    // Búsqueda de cupo
    const searchInput = document.getElementById('buscarCupo');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const valor = this.value.toUpperCase();
            document.querySelectorAll('.cupo-card').forEach(cupo => {
                const codigo = cupo.dataset.codigo;
                cupo.style.display = codigo.includes(valor) ? 'flex' : 'none';
            });
        });
    }
});

// ============================================
// CONFIRMAR ASIGNACIÓN
// ============================================
function confirmarAsignacion() {
    const tipoRadio = document.querySelector('input[name="tipoVehiculo"]:checked');
    const placa = document.getElementById('placaVehiculo').value.trim().toUpperCase();
    
    if (!tipoRadio) {
        alert('Por favor seleccione un tipo de vehículo');
        return;
    }
    
    if (!placa) {
        alert('Por favor ingrese la placa del vehículo');
        return;
    }
    
    const tipoVehiculo = tipoRadio.value;
    const info = estadoCupos[cupoActual];
    
    // Validación CU 2b: Tipo de vehículo incorrecto
    if (info.tipo === 'moto' && tipoVehiculo === 'carro') {
        document.getElementById('mensajeTipoIncorrecto').innerHTML = 
            `No se puede asignar un <strong>carro</strong> al cupo <strong>${cupoActual}</strong> porque es un cupo exclusivo para <strong>motos</strong>.`;
        cerrarModal('modalAsignarVehiculo');
        abrirModal('modalTipoIncorrecto');
        return;
    }
    
    if (info.tipo === 'carro' && tipoVehiculo === 'moto') {
        document.getElementById('mensajeTipoIncorrecto').innerHTML = 
            `No se puede asignar una <strong>moto</strong> al cupo <strong>${cupoActual}</strong> porque es un cupo exclusivo para <strong>carros</strong>.`;
        cerrarModal('modalAsignarVehiculo');
        abrirModal('modalTipoIncorrecto');
        return;
    }
    
    // Asignar el vehículo
    estadoCupos[cupoActual] = {
        estado: 'ocupado',
        tipo: tipoVehiculo,
        placa: placa
    };
    
    // Actualizar visualmente
    const cupoElement = document.querySelector(`[data-codigo="${cupoActual}"]`);
if (cupoElement) {
    cupoElement.classList.remove('cupo-disponible');
    cupoElement.classList.add('cupo-ocupado');
    cupoElement.querySelector('.cupo-estado').textContent = 'OCUP';
}
    
    document.getElementById('mensajeAsignacionExitosa').innerHTML = 
        `Vehículo <strong>${placa}</strong> asignado exitosamente al cupo <strong>${cupoActual}</strong>.`;
    
    cerrarModal('modalAsignarVehiculo');
    abrirModal('modalAsignacionExitosa');
}

// ============================================
// CAMBIO DE PISOS (TABS)
// ============================================
document.querySelectorAll('.nivel-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        // 1. Quitar active de todos los tabs
        document.querySelectorAll('.nivel-tab').forEach(t => t.classList.remove('active'));
        
        // 2. Agregar active al tab clickeado
        this.classList.add('active');
        
        // 3. Ocultar todos los mapas
        document.querySelectorAll('.piso-mapa').forEach(mapa => {
            mapa.classList.remove('active');
        });
        
        // 4. Mostrar el mapa correspondiente
        const textoTab = this.textContent.trim();
        
        if (textoTab === 'Piso 1') {
            document.getElementById('mapa-piso-1').classList.add('active');
        } else if (textoTab === 'Nivel / Piso 2') {
            document.getElementById('mapa-piso-2').classList.add('active');
        } else if (textoTab === 'Piso 3 (Motos)') {
            document.getElementById('mapa-piso-3').classList.add('active');
        }
    });
});
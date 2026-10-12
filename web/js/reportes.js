document.addEventListener('DOMContentLoaded', function() {
    const btnPDF = document.querySelector('.btn-pdf');
    const btnExcel = document.querySelector('.btn-excel');

    if (btnPDF) {
        btnPDF.addEventListener('click', function() {
            const desde = document.getElementById('fechaDesde').value;
            const hasta = document.getElementById('fechaHasta').value;
            const hoy = new Date().toISOString().split('T')[0];

            if (hasta > hoy) {
                abrirModal('modalFechaInvalida');
                return;
            }

            if (!desde || !hasta) {
                abrirModal('modalSinDatos');
                return;
            }

            alert('Exportando PDF del ' + desde + ' al ' + hasta);
        });
    }

    if (btnExcel) {
        btnExcel.addEventListener('click', function() {
            alert('Exportando a Excel...');
        });
    }
});

function exportarPDF() {
    alert('Generando PDF...');
}

function exportarExcel() {
    alert('Generando Excel...');
}
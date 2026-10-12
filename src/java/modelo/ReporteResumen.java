package modelo;

import java.util.ArrayList;
import java.util.List;

/** Todo lo que muestra la pantalla de Reportes para un rango de fechas. */
public class ReporteResumen {
    public double totalRecaudado;
    public double promedioDiario;
    public int vehiculosAtendidos;
    // Cambio en % frente al período anterior (null si no hay con qué comparar)
    public Integer cambioTotal;
    public Integer cambioPromedio;
    public Integer cambioVehiculos;
    public List<Barra> barras = new ArrayList<>();
    public List<Categoria> categorias = new ArrayList<>();

    public boolean sinDatos() {
        return totalRecaudado == 0 && vehiculosAtendidos == 0;
    }
}

package modelo;

// Datos de las tarjetas del dashboard.
public class DashboardResumen {
    private int vehiculosHoy;      // ingresos de hoy
    private int salidasHoy;        // salidas de hoy
    private Integer variacion;     // % frente a ayer (null si ayer no hubo ingresos)
    private int totalCupos;
    private int cuposDisponibles;
    private int cuposOcupados;
    private int cuposReservados;
    private int reservasActivas;
    private double recaudadoHoy;
    private int incidentesHoy;

    public int getVehiculosHoy() { return vehiculosHoy; }
    public void setVehiculosHoy(int vehiculosHoy) { this.vehiculosHoy = vehiculosHoy; }

    public int getSalidasHoy() { return salidasHoy; }
    public void setSalidasHoy(int salidasHoy) { this.salidasHoy = salidasHoy; }

    public Integer getVariacion() { return variacion; }
    public void setVariacion(Integer variacion) { this.variacion = variacion; }

    public int getTotalCupos() { return totalCupos; }
    public void setTotalCupos(int totalCupos) { this.totalCupos = totalCupos; }

    public int getCuposDisponibles() { return cuposDisponibles; }
    public void setCuposDisponibles(int cuposDisponibles) { this.cuposDisponibles = cuposDisponibles; }

    public int getCuposOcupados() { return cuposOcupados; }
    public void setCuposOcupados(int cuposOcupados) { this.cuposOcupados = cuposOcupados; }

    public int getCuposReservados() { return cuposReservados; }
    public void setCuposReservados(int cuposReservados) { this.cuposReservados = cuposReservados; }

    public int getReservasActivas() { return reservasActivas; }
    public void setReservasActivas(int reservasActivas) { this.reservasActivas = reservasActivas; }

    public double getRecaudadoHoy() { return recaudadoHoy; }
    public void setRecaudadoHoy(double recaudadoHoy) { this.recaudadoHoy = recaudadoHoy; }

    public int getIncidentesHoy() { return incidentesHoy; }
    public void setIncidentesHoy(int incidentesHoy) { this.incidentesHoy = incidentesHoy; }
}

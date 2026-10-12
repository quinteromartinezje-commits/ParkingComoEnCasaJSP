package modelo;

/**
 * Datos de un vehículo que está dentro del parqueadero y quiere salir,
 * más lo que debe pagar.
 */
public class Salida {
    private int idRegistro;
    private String placa;
    private String tipo;
    private int idEspacio;
    private String cupo;
    private String horaIngreso;
    private String horaSalida;
    private long minutos;        // minutos que estuvo dentro
    private double tarifaHora;   // valor de una hora
    private int horas;           // horas que se cobran (mínimo 1)
    private double total;

    // Calcula cuántas horas se cobran y el total.
    // Ejemplo: 61 minutos -> 2 horas (se cobra la hora o fracción).
    public void calcular() {
        horas = (int) Math.ceil(minutos / 60.0);
        if (horas < 1) {
            horas = 1;
        }
        total = horas * tarifaHora;
    }

    public String getTicket() {
        return "TKT-" + idRegistro;
    }

    // Horas después de la primera
    public int getHorasAdicionales() {
        return horas - 1;
    }

    public double getTotalAdicionales() {
        return getHorasAdicionales() * tarifaHora;
    }

    // Texto como "2 h 5 min"
    public String getTiempoTexto() {
        return (minutos / 60) + " h " + (minutos % 60) + " min";
    }

    public int getIdRegistro() { return idRegistro; }
    public void setIdRegistro(int idRegistro) { this.idRegistro = idRegistro; }
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public int getIdEspacio() { return idEspacio; }
    public void setIdEspacio(int idEspacio) { this.idEspacio = idEspacio; }
    public String getCupo() { return cupo; }
    public void setCupo(String cupo) { this.cupo = cupo; }
    public String getHoraIngreso() { return horaIngreso; }
    public void setHoraIngreso(String horaIngreso) { this.horaIngreso = horaIngreso; }
    public String getHoraSalida() { return horaSalida; }
    public void setHoraSalida(String horaSalida) { this.horaSalida = horaSalida; }
    public long getMinutos() { return minutos; }
    public void setMinutos(long minutos) { this.minutos = minutos; }
    public double getTarifaHora() { return tarifaHora; }
    public void setTarifaHora(double tarifaHora) { this.tarifaHora = tarifaHora; }
    public int getHoras() { return horas; }
    public double getTotal() { return total; }
}

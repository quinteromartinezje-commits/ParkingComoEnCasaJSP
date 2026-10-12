package modelo;

/** Un vehículo encontrado en la pantalla Consulta. */
public class ConsultaFila {
    public int id;
    public String placa;
    public String tipo;
    public String ingreso;
    public String salida;     // null si todavía está dentro
    public long minutos;
    public Double monto;      // null si todavía no ha pagado
    public String cupo;
    public String operario;
    public String medioPago;

    public boolean enPatio() { return salida == null; }
    public String getTicket() { return "TKT-" + id; }
    public String getDuracion() { return (minutos / 60) + "h " + (minutos % 60) + "m"; }
}

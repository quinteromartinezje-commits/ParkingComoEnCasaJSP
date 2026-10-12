package modelo;

/**
 * Una reserva (suscripción mensual) de un cupo.
 */
public class Reserva {
    private int id;
    private String cliente;
    private String documento;
    private String placa;
    private String cupo;
    private String fechaInicio;
    private String fechaFin;
    private double valor;
    private String estado;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCliente() { return cliente; }
    public void setCliente(String cliente) { this.cliente = cliente; }
    public String getDocumento() { return documento; }
    public void setDocumento(String documento) { this.documento = documento; }
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public String getCupo() { return cupo; }
    public void setCupo(String cupo) { this.cupo = cupo; }
    public String getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(String fechaInicio) { this.fechaInicio = fechaInicio; }
    public String getFechaFin() { return fechaFin; }
    public void setFechaFin(String fechaFin) { this.fechaFin = fechaFin; }
    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}

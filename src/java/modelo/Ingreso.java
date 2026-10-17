package modelo;

// Guarda los datos de un ingreso de vehículo al parqueadero.
// Los atributos coinciden con lo que se muestra en el formulario y en la tabla de Ingreso.
public class Ingreso {
    private int id;
    private String placa;
    private String tipo;
    private String cupo;
    private String fechaHora;
    private String ticket;

    // Constructor vacío (lo usa el DAO al leer de la base de datos)
    public Ingreso() {}

    // Constructor con los datos que llegan del formulario
    public Ingreso(String placa, String tipo, String cupo, String fechaHora, String ticket) {
        this.placa = placa;
        this.tipo = tipo;
        this.cupo = cupo;
        this.fechaHora = fechaHora;
        this.ticket = ticket;
    }

    // Getters y setters de cada atributo
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getCupo() { return cupo; }
    public void setCupo(String cupo) { this.cupo = cupo; }
    public String getFechaHora() { return fechaHora; }
    public void setFechaHora(String fechaHora) { this.fechaHora = fechaHora; }
    public String getTicket() { return ticket; }
    public void setTicket(String ticket) { this.ticket = ticket; }
}
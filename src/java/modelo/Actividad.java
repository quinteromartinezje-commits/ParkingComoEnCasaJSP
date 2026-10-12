package modelo;

/**
 * Una línea de la lista "Actividad reciente".
 */
public class Actividad {
    private final String tipo;     // ingreso, salida, reserva o incidente
    private final String titulo;   // texto grande
    private final String detalle;  // texto pequeño
    private final long minutos;    // hace cuántos minutos pasó (sirve para ordenar)

    public Actividad(String tipo, String titulo, String detalle, long minutos) {
        this.tipo = tipo;
        this.titulo = titulo;
        this.detalle = detalle;
        this.minutos = minutos;
    }

    public String getTipo() { return tipo; }
    public String getTitulo() { return titulo; }
    public String getDetalle() { return detalle; }
    public long getMinutos() { return minutos; }

    // Color del punto en el dashboard
    public String getColor() {
        if ("salida".equals(tipo)) return "green";
        if ("reserva".equals(tipo)) return "yellow";
        if ("incidente".equals(tipo)) return "red";
        return "blue";
    }
}

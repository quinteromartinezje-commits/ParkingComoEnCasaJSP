package modelo;

/** Un incidente reportado. */
public class Incidente {
    public String titulo;
    public String descripcion;
    public String tipo;        // Daño, Novedad, Reclamo
    public String prioridad;   // Alta, Media, Baja
    public String reportadoPor;
    public String cuando;      // "Hace 5 min"
}

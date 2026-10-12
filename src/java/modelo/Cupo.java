package modelo;

// Un cupo del mapa de ocupación.
public class Cupo {
    private final String codigo;
    private final String estado;

    public Cupo(String codigo, String estado) {
        this.codigo = codigo;
        this.estado = estado;
    }

    public String getCodigo() { return codigo; }
    public String getEstado() { return estado; }

    // Color que usa dashboard.css: blue = disponible, gray = ocupado, yellow = reservado
    public String getColor() {
        String e = estado == null ? "" : estado.toLowerCase();
        if (e.equals("ocupado")) return "gray";
        if (e.equals("reservado")) return "yellow";
        return "blue";
    }
}

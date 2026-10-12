package modelo;

/** Las tarifas vigentes de un tipo de vehículo. */
public class Tarifa {
    public int idTipo;
    public String tipo;
    public double hora;
    public double fraccion;
    public double recargo;
    public boolean activo = true;   // si está inhabilitada no se pueden registrar ingresos de ese tipo
}

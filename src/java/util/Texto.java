package util;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

/**
 * Pequeñas ayudas para mostrar texto en las páginas JSP.
 */
public class Texto {

    // Evita que lo que escribe el usuario se interprete como HTML (seguridad básica).
    public static String escapar(String texto) {
        if (texto == null) {
            return "";
        }
        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    // Convierte 16250 en "$16.250" (formato colombiano).
    public static String dinero(double valor) {
        DecimalFormat formato = new DecimalFormat("#,##0",
                DecimalFormatSymbols.getInstance(Locale.forLanguageTag("es-CO")));
        return "$" + formato.format(valor);
    }

    // Convierte minutos en un texto como "3 horas, 15 minutos".
    public static String duracion(long minutos) {
        if (minutos < 0) {
            minutos = 0;
        }
        long horas = minutos / 60;
        long resto = minutos % 60;
        String h = horas + (horas == 1 ? " hora" : " horas");
        String m = resto + (resto == 1 ? " minuto" : " minutos");
        if (horas == 0) {
            return m;
        }
        return h + ", " + m;
    }

    // Convierte minutos en "Hace 5 min", "Hace 2 h", "Hace 3 d".
    public static String hace(long minutos) {
        if (minutos < 1) return "Hace instantes";
        if (minutos < 60) return "Hace " + minutos + " min";
        if (minutos < 1440) return "Hace " + (minutos / 60) + " h";
        return "Hace " + (minutos / 1440) + " d";
    }
}

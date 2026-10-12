package util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import modelo.Usuario;

/**
 * Pequeña ayuda para saber quién inició sesión.
 * Todos los servlets la usan: si devuelve null, mandan al login.
 */
public class Sesion {

    public static Usuario usuario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object dato = session.getAttribute("usuario");
        if (dato instanceof Usuario) {
            return (Usuario) dato;
        }
        return null;
    }
}

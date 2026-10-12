package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import dao.PerfilDAO;
import modelo.Usuario;
import util.Sesion;

// Perfil del usuario. POST: guarda los datos (accion=perfil) o cambia la clave (accion=clave).
@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (request.getParameter("editar") != null) {
            request.setAttribute("modal", "editar");
        } else if (request.getParameter("clave") != null) {
            request.setAttribute("modal", "clave");
        }
        String ok = request.getParameter("ok");
        if ("perfil".equals(ok)) {
            request.setAttribute("mensajeOk", "Perfil actualizado correctamente.");
        } else if ("clave".equals(ok)) {
            request.setAttribute("mensajeOk", "Contraseña cambiada correctamente.");
        }
        mostrar(request, response, usuarioActual(request));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Usuario usuario = Sesion.usuario(request);
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        PerfilDAO dao = new PerfilDAO();
        String accion = request.getParameter("accion");

        // ---- Cambiar la contraseña ----
        if ("clave".equals(accion)) {
            String actual = limpiar(request.getParameter("actual"));
            String nueva = limpiar(request.getParameter("nueva"));
            String repetir = limpiar(request.getParameter("repetir"));

            String problema = null;
            if (actual.isEmpty() || nueva.isEmpty()) {
                problema = "Escribe la contraseña actual y la nueva.";
            } else if (nueva.length() < 6) {
                problema = "La contraseña nueva debe tener mínimo 6 caracteres.";
            } else if (!nueva.equals(repetir)) {
                problema = "La contraseña nueva y su confirmación no coinciden.";
            } else if (!dao.cambiarClave(usuario.getId(), actual, nueva)) {
                problema = dao.getError();
            }
            if (problema != null) {
                request.setAttribute("modal", "clave");
                request.setAttribute("mensajeError", problema);
                mostrar(request, response, usuario);
                return;
            }
            AuditoriaDAO.registrar(usuario.getId(), "Cambiar Contraseña", "Perfil", "Cambio de contraseña", request.getRemoteAddr());
            response.sendRedirect("PerfilServlet?ok=clave");
            return;
        }

        // ---- Editar nombre, correo y documento ----
        String nombre = limpiar(request.getParameter("nombre"));
        String correo = limpiar(request.getParameter("correo")).toLowerCase();
        String documento = limpiar(request.getParameter("documento"));

        String problema = null;
        if (nombre.isEmpty() || correo.isEmpty() || documento.isEmpty()) {
            problema = "Completa nombre, correo y documento.";
        } else if (!correo.contains("@")) {
            problema = "El correo no es válido.";
        } else if (!dao.actualizar(usuario.getId(), nombre, correo, documento)) {
            problema = dao.getError();
        }
        if (problema != null) {
            request.setAttribute("modal", "editar");
            request.setAttribute("mensajeError", problema);
            mostrar(request, response, usuario);
            return;
        }

        // Actualizamos también lo que está guardado en la sesión (el nombre del encabezado)
        usuario.setNombre(nombre);
        usuario.setCorreo(correo);
        AuditoriaDAO.registrar(usuario.getId(), "Modificar Perfil", "Perfil", "Datos personales actualizados", request.getRemoteAddr());
        response.sendRedirect("PerfilServlet?ok=perfil");
    }

    private Usuario usuarioActual(HttpServletRequest request) {
        return Sesion.usuario(request);
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        request.setAttribute("perfil", new PerfilDAO().buscar(usuario.getId()));
        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }

    private String limpiar(String texto) {
        return texto == null ? "" : texto.trim();
    }
}

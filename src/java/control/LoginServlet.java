package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.AuditoriaDAO;
import dao.UsuarioDAO;
import modelo.Usuario;

// Login. POST valida correo y clave. Con ?salir=1 cierra la sesión.
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Lo que escribió el usuario en login.jsp
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        if (correo == null) correo = "";
        if (password == null) password = "";
        correo = correo.trim();

        // 2. Validaciones sencillas (antes lo hacía JavaScript)
        if (correo.isEmpty() || !correo.contains("@")) {
            volverAlLogin(request, response, "Por favor, ingresa un correo válido.");
            return;
        }
        if (password.isEmpty()) {
            volverAlLogin(request, response, "Por favor, ingresa tu contraseña.");
            return;
        }

        // 3. Le preguntamos al DAO si el usuario existe
        Usuario usuarioValido = new UsuarioDAO().validarUsuario(correo, password);

        if (usuarioValido != null) {
            // Guardamos al usuario en la sesión (así el sistema recuerda que ya entró)
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuarioValido);
            new UsuarioDAO().registrarAcceso(usuarioValido.getId());
            AuditoriaDAO.registrar(usuarioValido.getId(), "Iniciar Sesión", "Login",
                    "Inicio de sesión de " + usuarioValido.getCorreo(), request.getRemoteAddr());
            response.sendRedirect("DashboardServlet");
        } else {
            volverAlLogin(request, response, "Correo o contraseña incorrectos. Intenta de nuevo.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ?salir=1 -> cerrar sesión
        if ("1".equals(request.getParameter("salir"))) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
        }
        response.sendRedirect("login.jsp");
    }

    private void volverAlLogin(HttpServletRequest request, HttpServletResponse response, String mensaje)
            throws ServletException, IOException {
        request.setAttribute("mensajeError", mensaje);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}

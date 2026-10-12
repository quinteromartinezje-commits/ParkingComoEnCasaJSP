package control;

import dao.UsuarioDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Usuario;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Recoger los datos que el usuario escribió en el login.jsp
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
           System.out.println(">>> DATOS QUE LLEGAN: Correo=" + correo + " | Contraseña=" + password);
        
        // 2. Llamar al detective (DAO) para que valide los datos
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuarioValido = dao.validarUsuario(correo, password);
        
        // 3. Tomar la decisión
        if (usuarioValido != null) {
            // ¡El usuario existe! Creamos una "sesión" para recordar que ya inició sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuarioValido);
            
            // Lo mandamos al dashboard (la página principal)
            response.sendRedirect("dashboard.jsp"); 
        } else {
            // El usuario o contraseña están mal
            // Guardamos un mensaje de error para mostrarlo en el login
            request.setAttribute("mensajeError", "Correo o contraseña incorrectos. Intenta de nuevo.");
            
            // Lo devolvemos a la página de login
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // Este método se activa si alguien entra directo a la dirección del Servlet por GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si llegan por GET, simplemente los mandamos al login
        response.sendRedirect("login.jsp");
    }
}
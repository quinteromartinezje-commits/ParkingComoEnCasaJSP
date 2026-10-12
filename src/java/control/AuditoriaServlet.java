package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import util.Sesion;

// Muestra la tabla de auditoría (quién hizo qué). Los filtros llegan por GET.
@WebServlet("/AuditoriaServlet")
public class AuditoriaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String usuario = valor(request.getParameter("usuario"));
        String fecha = valor(request.getParameter("fecha"));
        String modulo = valor(request.getParameter("modulo"));
        if (fecha.isEmpty()) {
            fecha = "todos";
        }
        // El id de usuario tiene que ser un número
        if (!usuario.matches("\\d*")) {
            usuario = "";
        }

        AuditoriaDAO dao = new AuditoriaDAO();
        int total = dao.contar(usuario, fecha, modulo);
        int paginas = Math.max(1, (int) Math.ceil(total / (double) AuditoriaDAO.POR_PAGINA));

        int pagina = 1;
        try {
            pagina = Integer.parseInt(request.getParameter("pagina"));
        } catch (Exception e) {
            pagina = 1;
        }
        pagina = Math.min(Math.max(1, pagina), paginas);

        request.setAttribute("filas", dao.listar(usuario, fecha, modulo, pagina));
        request.setAttribute("usuarios", dao.usuarios());
        request.setAttribute("fUsuario", usuario);
        request.setAttribute("fFecha", fecha);
        request.setAttribute("fModulo", modulo);
        request.setAttribute("total", total);
        request.setAttribute("pagina", pagina);
        request.setAttribute("paginas", paginas);
        request.getRequestDispatcher("auditoria.jsp").forward(request, response);
    }

    private String valor(String texto) {
        return texto == null ? "" : texto.trim();
    }
}

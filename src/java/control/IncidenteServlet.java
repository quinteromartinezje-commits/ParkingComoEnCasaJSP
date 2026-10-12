package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import dao.IncidenteDAO;
import modelo.Usuario;
import util.Sesion;

// Incidentes. GET: lista + formulario. POST: guarda uno nuevo.
@WebServlet("/IncidenteServlet")
public class IncidenteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if ("1".equals(request.getParameter("ok"))) {
            request.setAttribute("mensajeOk", "Incidente registrado exitosamente.");
        }
        mostrar(request, response);
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

        String placa = limpiar(request.getParameter("placa")).toUpperCase();
        String tipo = limpiar(request.getParameter("tipo"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        String prioridad = limpiar(request.getParameter("prioridad"));

        if (tipo.isEmpty() || descripcion.isEmpty() || prioridad.isEmpty()) {
            request.setAttribute("mensajeError", "Complete todos los campos obligatorios (tipo, descripción y prioridad).");
            mostrar(request, response);
            return;
        }
        if (descripcion.length() > 255) {
            request.setAttribute("mensajeError", "La descripción es muy larga (máximo 255 caracteres).");
            mostrar(request, response);
            return;
        }

        IncidenteDAO dao = new IncidenteDAO();
        if (!dao.guardar(usuario.getId(), placa, tipo, descripcion, prioridad)) {
            request.setAttribute("mensajeError", dao.getError());
            mostrar(request, response);
            return;
        }

        AuditoriaDAO.registrar(usuario.getId(), "Registrar Incidente", "Incidentes",
                tipo + " (" + prioridad + "): " + descripcion, request.getRemoteAddr());
        response.sendRedirect("IncidenteServlet?ok=1");
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("incidentes", new IncidenteDAO().recientes());
        request.getRequestDispatcher("incidentes.jsp").forward(request, response);
    }

    private String limpiar(String texto) {
        return texto == null ? "" : texto.trim();
    }
}

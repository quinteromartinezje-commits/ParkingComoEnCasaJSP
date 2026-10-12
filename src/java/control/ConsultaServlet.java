package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ConsultaDAO;
import util.Sesion;

// Busca vehículos por placa o ticket. Con ?ver=ID muestra el detalle de esa fila.
@WebServlet("/ConsultaServlet")
public class ConsultaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String buscar = request.getParameter("buscar");
        if (buscar == null) {
            buscar = "";
        }
        buscar = buscar.trim();

        String estado = request.getParameter("estado");
        if (estado == null || !(estado.equals("activo") || estado.equals("finalizado"))) {
            estado = "todos";
        }

        int ver = 0;
        try {
            ver = Integer.parseInt(request.getParameter("ver"));
        } catch (Exception e) {
            ver = 0;
        }

        request.setAttribute("buscar", buscar);
        request.setAttribute("estado", estado);
        request.setAttribute("ver", ver);
        request.setAttribute("filas", new ConsultaDAO().buscar(buscar, estado));
        request.getRequestDispatcher("consulta.jsp").forward(request, response);
    }
}

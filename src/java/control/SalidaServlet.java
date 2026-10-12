package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.SalidaDAO;
import modelo.Salida;
import modelo.Usuario;

/**
 * Registro de salida de vehículos.
 *  - GET  : busca el vehículo (por placa o ticket) y muestra el cobro.
 *  - POST : confirma el pago, registra la salida y libera el cupo.
 */
@WebServlet("/SalidaServlet")
public class SalidaServlet extends HttpServlet {

    // GET: buscar un vehículo. Ejemplo: SalidaServlet?buscar=ABC-123
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!haySesion(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String buscar = request.getParameter("buscar");
        if (buscar != null) {
            if (buscar.trim().isEmpty()) {
                request.setAttribute("campoVacio", "true");
            } else {
                Salida detalle = new SalidaDAO().buscar(buscar);
                if (detalle == null) {
                    request.setAttribute("noEncontrado", "true");
                } else {
                    request.setAttribute("detalle", detalle);
                }
                request.setAttribute("textoBuscado", buscar.trim());
            }
        }
        request.getRequestDispatcher("salida.jsp").forward(request, response);
    }

    // POST: confirmar el pago y registrar la salida
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!haySesion(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String medioPago = request.getParameter("medioPago");
        if (medioPago == null || medioPago.trim().isEmpty()) {
            medioPago = "Efectivo";
        }

        int idRegistro;
        try {
            idRegistro = Integer.parseInt(request.getParameter("idRegistro"));
        } catch (NumberFormatException e) {
            request.setAttribute("mensajeError", "Primero busca el vehículo que va a salir.");
            request.getRequestDispatcher("salida.jsp").forward(request, response);
            return;
        }

        try {
            Salida salida = new SalidaDAO().registrarSalida(idRegistro, medioPago);
            request.setAttribute("modalExito", "true");
            request.setAttribute("salidaOk", salida);
            request.setAttribute("medioPagoOk", medioPago);
        } catch (IllegalStateException e) {
            request.setAttribute("mensajeError", e.getMessage());
        }
        request.getRequestDispatcher("salida.jsp").forward(request, response);
    }

    private boolean haySesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("usuario") instanceof Usuario;
    }
}

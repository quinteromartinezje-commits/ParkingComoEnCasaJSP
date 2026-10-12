package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.ReservaDAO;
import modelo.Usuario;

/**
 * Reservas de cupo.
 *  - GET  : muestra el formulario y la lista de reservas activas.
 *  - POST : crea una reserva (accion=crear) o la cancela (accion=cancelar).
 */
@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    // GET: abrir la página de reservas
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!haySesion(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Mensajes de éxito que llegan en la dirección (después de guardar)
        String ok = request.getParameter("ok");
        if ("creada".equals(ok)) {
            request.setAttribute("mensajeOk", "Reserva creada correctamente. El cupo quedó reservado.");
        } else if ("cancelada".equals(ok)) {
            request.setAttribute("mensajeOk", "Reserva cancelada. El cupo quedó disponible.");
        }
        mostrar(request, response);
    }

    // POST: crear o cancelar
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!haySesion(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        ReservaDAO dao = new ReservaDAO();
        String accion = request.getParameter("accion");

        try {
            if ("cancelar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("idReserva"));
                dao.cancelar(id);
                response.sendRedirect("ReservaServlet?ok=cancelada");
                return;
            }

            // accion = crear
            String nombre = limpiar(request.getParameter("nombre"));
            String documento = limpiar(request.getParameter("documento"));
            String telefono = limpiar(request.getParameter("telefono"));
            String correo = limpiar(request.getParameter("correo"));
            String placa = limpiar(request.getParameter("placa")).toUpperCase();
            String tipo = limpiar(request.getParameter("tipo"));
            String cupo = limpiar(request.getParameter("cupo"));
            String medioPago = limpiar(request.getParameter("medioPago"));
            String valorTexto = limpiar(request.getParameter("valor"));

            if (nombre.isEmpty() || documento.isEmpty() || placa.isEmpty()
                    || tipo.isEmpty() || cupo.isEmpty() || medioPago.isEmpty() || valorTexto.isEmpty()) {
                throw new IllegalStateException("Completa todos los campos obligatorios (*).");
            }
            if (!placa.matches("[A-Z0-9-]{3,10}")) {
                throw new IllegalStateException("La placa solo puede tener letras, números y guion (3 a 10 caracteres).");
            }
            double valor;
            try {
                valor = Double.parseDouble(valorTexto);
            } catch (NumberFormatException e) {
                throw new IllegalStateException("El valor de la mensualidad debe ser un número.");
            }
            if (valor <= 0) {
                throw new IllegalStateException("El valor de la mensualidad debe ser mayor que cero.");
            }

            dao.crear(nombre, documento, telefono, correo, placa, tipo, cupo, valor, medioPago);
            response.sendRedirect("ReservaServlet?ok=creada");

        } catch (IllegalStateException | NumberFormatException e) {
            String mensaje = (e instanceof NumberFormatException) ? "Datos no válidos." : e.getMessage();
            request.setAttribute("mensajeError", mensaje);
            mostrar(request, response);
        }
    }

    // Carga las listas y abre reservas.jsp
    private void mostrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ReservaDAO dao = new ReservaDAO();
        request.setAttribute("reservas", dao.getReservasActivas());
        request.setAttribute("cuposLibres", dao.getCuposDisponibles());
        request.setAttribute("tipos", dao.getTiposVehiculo());
        request.setAttribute("metodos", dao.getMetodosPago());
        request.getRequestDispatcher("reservas.jsp").forward(request, response);
    }

    private String limpiar(String texto) {
        return texto == null ? "" : texto.trim();
    }

    private boolean haySesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("usuario") instanceof Usuario;
    }
}

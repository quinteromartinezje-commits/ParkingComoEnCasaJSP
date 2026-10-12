package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.AuditoriaDAO;
import dao.ReservaDAO;
import util.Sesion;
import modelo.Usuario;

// Reservas. GET: formulario y lista. POST: crea o cancela una reserva.
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
        // ?cancelar=ID -> se muestra la ventana para confirmar la cancelación
        String cancelar = request.getParameter("cancelar");
        if (cancelar != null && cancelar.matches("\\d+")) {
            request.setAttribute("cancelarId", Integer.parseInt(cancelar));
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

        // ---- Cancelar una reserva ----
        if ("cancelar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idReserva"));
            if (dao.cancelar(id)) {
                AuditoriaDAO.registrar(Sesion.usuario(request).getId(), "Cancelar Reserva", "Reservas",
                        "Se canceló la reserva #" + id, request.getRemoteAddr());
                response.sendRedirect("ReservaServlet?ok=cancelada");
            } else {
                request.setAttribute("mensajeError", dao.getError());
                mostrar(request, response);
            }
            return;
        }

        // ---- Crear una reserva: leemos lo que escribió el usuario ----
        String nombre = limpiar(request.getParameter("nombre"));
        String documento = limpiar(request.getParameter("documento"));
        String telefono = limpiar(request.getParameter("telefono"));
        String correo = limpiar(request.getParameter("correo"));
        String placa = limpiar(request.getParameter("placa")).toUpperCase();
        String tipo = limpiar(request.getParameter("tipo"));
        String cupo = limpiar(request.getParameter("cupo"));
        String medioPago = limpiar(request.getParameter("medioPago"));
        String valorTexto = limpiar(request.getParameter("valor"));

        // Validaciones sencillas
        if (nombre.isEmpty() || documento.isEmpty() || placa.isEmpty()
                || tipo.isEmpty() || cupo.isEmpty() || medioPago.isEmpty() || valorTexto.isEmpty()) {
            request.setAttribute("mensajeError", "Completa todos los campos obligatorios (*).");
            mostrar(request, response);
            return;
        }

        double valor = 0;
        try {
            valor = Double.parseDouble(valorTexto);
        } catch (NumberFormatException e) {
            valor = 0;
        }
        if (valor <= 0) {
            request.setAttribute("mensajeError", "El valor de la mensualidad debe ser un número mayor que cero.");
            mostrar(request, response);
            return;
        }

        // Guardamos. Si sale bien, redirigimos; si no, mostramos el error.
        if (dao.crear(nombre, documento, telefono, correo, placa, tipo, cupo, valor, medioPago)) {
            AuditoriaDAO.registrar(Sesion.usuario(request).getId(), "Crear Reserva", "Reservas",
                    "Reserva de la placa " + placa + " en el cupo " + cupo, request.getRemoteAddr());
            response.sendRedirect("ReservaServlet?ok=creada");
        } else {
            request.setAttribute("mensajeError", dao.getError());
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

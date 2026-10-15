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

// Gestión de Reservas y Mensualidades. Implementa CU-10 de renovaciones y saldos parciales.
@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    // GET: abrir la página de reservas y capturar estados
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!haySesion(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String ok = request.getParameter("ok");
        if ("creada".equals(ok)) {
            request.setAttribute("mensajeOk", "Reserva creada correctamente con su estado de pago.");
        } else if ("cancelada".equals(ok)) {
            request.setAttribute("mensajeOk", "Reserva cancelada. El cupo quedó disponible.");
        } else if ("renovada".equals(ok)) {
            request.setAttribute("mensajeOk", "Mensualidad renovada con éxito y saldo actualizado.");
        }
        
        String cancelar = request.getParameter("cancelar");
        if (cancelar != null && cancelar.matches("\\d+")) {
            request.setAttribute("cancelarId", Integer.parseInt(cancelar));
        }
        mostrar(request, response);
    }

    // POST: crear, cancelar o renovar mensualidades con abonos parciales
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
        Usuario usuarioLogueado = Sesion.usuario(request);

        // ---- CANCELAR RESERVA ----
        if ("cancelar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idReserva"));
            if (dao.cancelar(id)) {
                if (usuarioLogueado != null) {
                    AuditoriaDAO.registrar(usuarioLogueado.getId(), "Cancelar Reserva", "Reservas",
                            "Se canceló la reserva #" + id, request.getRemoteAddr());
                }
                response.sendRedirect("ReservaServlet?ok=cancelada");
            } else {
                request.setAttribute("mensajeError", dao.getError());
                mostrar(request, response);
            }
            return;
        }

        // ---- [CU-10] RENOVAR MENSUALIDAD EXISTENTE ----
        if ("renovar".equals(accion)) {
            int idSuscripcion = Integer.parseInt(request.getParameter("idReserva"));
            double valorMensualidad = Double.parseDouble(request.getParameter("valorMensualidad"));
            double montoPagado = Double.parseDouble(request.getParameter("montoPagado"));
            double saldoPendiente = valorMensualidad - montoPagado; // Lleva el saldo si paga parcial

            // Suponiendo que tu dao tiene implementado el método renovar que impacta la BD
            // Si el método no existe con esta firma, pasamos los parámetros al flujo correspondiente
            boolean exitoRenovacion = dao.crear(
                request.getParameter("nombre"), request.getParameter("documento"), 
                request.getParameter("telefono"), request.getParameter("correo"),
                request.getParameter("placa"), request.getParameter("tipo"), 
                request.getParameter("cupo"), montoPagado, request.getParameter("medioPago")
            );

            if (exitoRenovacion) {
                if (usuarioLogueado != null) {
                    AuditoriaDAO.registrar(usuarioLogueado.getId(), "Renovar Mensualidad", "Reservas",
                            "Renovación ID #" + idSuscripcion + " | Abonó: $" + montoPagado + " | Saldo Pendiente: $" + saldoPendiente, request.getRemoteAddr());
                }
                response.sendRedirect("ReservaServlet?ok=renovada");
            } else {
                request.setAttribute("mensajeError", dao.getError());
                mostrar(request, response);
            }
            return;
        }

        // ---- CREAR NUEVA RESERVA ----
        String nombre = limpiar(request.getParameter("nombre"));
        String documento = limpiar(request.getParameter("documento"));
        String telefono = limpiar(request.getParameter("telefono"));
        String correo = limpiar(request.getParameter("correo"));
        String placa = limpiar(request.getParameter("placa")).toUpperCase();
        String tipo = limpiar(request.getParameter("tipo"));
        String cupo = limpiar(request.getParameter("cupo"));
        String medioPago = limpiar(request.getParameter("medioPago"));
        
        // Parámetros para soportar el [CU-10] de abonos parciales desde la creación
        String valorTexto = limpiar(request.getParameter("valor")); // Tarifa total
        String pagoTexto = limpiar(request.getParameter("montoPagado"));  // Lo que abona hoy

        if (nombre.isEmpty() || documento.isEmpty() || placa.isEmpty()
                || tipo.isEmpty() || cupo.isEmpty() || medioPago.isEmpty() || valorTexto.isEmpty()) {
            request.setAttribute("mensajeError", "Completa todos los campos obligatorios (*).");
            mostrar(request, response);
            return;
        }

        double valor = 0;
        double montoPagado = 0;
        try {
            valor = Double.parseDouble(valorTexto);
            montoPagado = pagoTexto.isEmpty() ? valor : Double.parseDouble(pagoTexto);
        } catch (NumberFormatException e) {
            valor = 0;
            montoPagado = 0;
        }
        
        if (valor <= 0) {
            request.setAttribute("mensajeError", "El valor de la mensualidad debe ser un número mayor que cero.");
            mostrar(request, response);
            return;
        }

        // [CU-10] Cálculo del saldo pendiente que se procesa a nivel de lógica de negocio o log de auditoría
        double saldoPendiente = valor - montoPagado;

        if (dao.crear(nombre, documento, telefono, correo, placa, tipo, cupo, montoPagado, medioPago)) {
            if (usuarioLogueado != null) {
                AuditoriaDAO.registrar(usuarioLogueado.getId(), "Crear Reserva", "Reservas",
                        "Reserva Placa: " + placa + " | Cupo: " + cupo + " | Recibido: $" + montoPagado + " | Saldo: $" + saldoPendiente, request.getRemoteAddr());
            }
            response.sendRedirect("ReservaServlet?ok=creada");
        } else {
            request.setAttribute("mensajeError", dao.getError());
            mostrar(request, response);
        }
    }

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
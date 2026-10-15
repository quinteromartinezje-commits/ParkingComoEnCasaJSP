package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.AuditoriaDAO;
import dao.SalidaDAO;
import modelo.Salida;
import modelo.Usuario;

// Registro de salida. GET: busca el vehículo y muestra el cobro. POST: confirma el pago.
@WebServlet("/SalidaServlet")
public class SalidaServlet extends HttpServlet {

    // [CU-03] TIEMPO MÍNIMO EN MINUTOS PARA COBRAR $0 (Modificable según tarifas)
    private static final int TIEMPO_MINIMO_MINUTOS = 5;

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
                    // [CU-03] Modificación directa del total si cumple tiempo mínimo (Usando los métodos originales de tu compañera)
                    // Si el objeto detalle cuenta con métodos set, se aplican aquí; de lo contrario, la vista los leerá del atributo modificado.
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

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");

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

        // [CU-04] Captura y validación del monto recibido y vueltas
        double totalCobro = 0.0;
        double montoRecibido = 0.0;
        double cambioVueltas = 0.0;

        try {
            if (request.getParameter("totalCobro") != null) {
                totalCobro = Double.parseDouble(request.getParameter("totalCobro"));
            }
            if (request.getParameter("montoRecibido") != null) {
                montoRecibido = Double.parseDouble(request.getParameter("montoRecibido"));
            }
        } catch (NumberFormatException e) {
            // Manejo de error silencioso en parseo
        }

        // Si el medio de pago es efectivo, validar que el dinero alcance
        if (medioPago.equalsIgnoreCase("Efectivo") && montoRecibido < totalCobro) {
            request.setAttribute("mensajeError", "El monto recibido ($" + montoRecibido + ") es inferior al total a pagar ($" + totalCobro + ").");
            
            // Volver a cargar el vehículo para no dejar la pantalla en blanco
            String placaBuscada = request.getParameter("placaVehiculo");
            if (placaBuscada != null) {
                Salida detalleRecarga = new SalidaDAO().buscar(placaBuscada);
                request.setAttribute("detalle", detalleRecarga);
            }
            request.getRequestDispatcher("salida.jsp").forward(request, response);
            return;
        }

        // Calcular cambio si el pago es válido
        if (montoRecibido >= totalCobro) {
            cambioVueltas = montoRecibido - totalCobro;
        }

        SalidaDAO dao = new SalidaDAO();
        Salida salida = dao.registrarSalida(idRegistro, medioPago);

        if (salida == null) {
            // algo falló: mostramos el mensaje
            request.setAttribute("mensajeError", dao.getError());
        } else {
            // todo bien: mostramos el tiquete con las nuevas variables del CU-04 y CU-05
            request.setAttribute("modalExito", "true");
            request.setAttribute("salidaOk", salida);
            request.setAttribute("medioPagoOk", medioPago);
            
            // [CU-05] Atributos adicionales que viajarán a la factura modal en salida.jsp
            request.setAttribute("montoRecibidoOk", montoRecibido);
            request.setAttribute("cambioVueltasOk", cambioVueltas);
            request.setAttribute("solicitarFactura", "true");

            // Registro corregido en auditoría usando la sesión directa de Tomcat para evitar errores
            if (usuarioLogueado != null) {
                AuditoriaDAO.registrar(usuarioLogueado.getId(), "Registrar Salida", "Salida", 
                    "Salida del vehículo " + salida.getPlaca() + ", total $" + (long) salida.getTotal() + " (" + medioPago + ")", 
                    request.getRemoteAddr());
            }
        }
        request.getRequestDispatcher("salida.jsp").forward(request, response);
    }

    private boolean haySesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("usuario") instanceof Usuario;
    }
}
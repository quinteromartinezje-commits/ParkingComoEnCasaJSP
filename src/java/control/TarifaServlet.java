package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import dao.TarifaDAO;
import modelo.Tarifa;
import modelo.Usuario;
import util.Sesion;

// Tarifas. GET: tabla (y ventanas con ?nueva, ?editar, ?eliminar). POST: guardar, actualizar o eliminar.
@WebServlet("/TarifaServlet")
public class TarifaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        TarifaDAO dao = new TarifaDAO();

        if (request.getParameter("nueva") != null) {
            request.setAttribute("abrir", "nueva");
        }
        String editar = request.getParameter("editar");
        if (editar != null) {
            Tarifa t = dao.buscar(aNumero(editar));
            if (t != null) {
                request.setAttribute("abrir", "editar");
                request.setAttribute("tarifaEditar", t);
            }
        }
        String eliminar = request.getParameter("eliminar");
        if (eliminar != null) {
            Tarifa t = dao.buscar(aNumero(eliminar));
            if (t != null) {
                request.setAttribute("abrir", "eliminar");
                request.setAttribute("tarifaEliminar", t);
            }
        }
        String ok = request.getParameter("ok");
        if ("guardada".equals(ok)) {
            request.setAttribute("mensajeExito", "La tarifa ha sido guardada correctamente.");
        } else if ("desactivada".equals(ok)) {
            request.setAttribute("mensajeExito", "Tarifa inhabilitada con éxito.");
        } else if ("eliminada".equals(ok)) {
            request.setAttribute("mensajeExito", "La tarifa ha sido eliminada correctamente.");
        }
        mostrar(request, response, dao);
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

        TarifaDAO dao = new TarifaDAO();
        String accion = request.getParameter("accion");
        int idTipo = aNumero(request.getParameter("idTipo"));

        // ---- Eliminar ----
        if ("eliminar".equals(accion)) {
            String tipo = dao.nombreTipo(idTipo);
            if (dao.eliminar(idTipo)) {
                AuditoriaDAO.registrar(usuario.getId(), "Eliminar Tarifa", "Tarifas",
                        "Se eliminó la tarifa de " + tipo, request.getRemoteAddr());
                response.sendRedirect("TarifaServlet?ok=eliminada");
            } else {
                request.setAttribute("errorGuardado", "true");
                mostrar(request, response, dao);
            }
            return;
        }

        // ---- Guardar (nueva) o actualizar: se validan los valores ----
        double hora = aDecimal(request.getParameter("hora"));
        double fraccion = aDecimal(request.getParameter("fraccion"));
        double recargo = aDecimal(request.getParameter("recargo"));
        boolean activo = !"Inactivo".equals(request.getParameter("estado"));

        String problema = null;
        if (idTipo == 0) {
            problema = "Por favor seleccione un tipo de vehículo.";
        } else if (hora <= 0) {
            problema = "Valor inválido: La tarifa por hora debe ser mayor a $0.";
        } else if (fraccion <= 0) {
            problema = "Valor inválido: La tarifa por fracción debe ser mayor a $0.";
        } else if (recargo < 0) {
            problema = "Valor inválido: El recargo nocturno no puede ser negativo.";
        }
        if (problema != null) {
            request.setAttribute("valorInvalido", problema);
            request.setAttribute("volverA", "actualizar".equals(accion) ? "editar=" + idTipo : "nueva=1");
            mostrar(request, response, dao);
            return;
        }

        if (dao.guardar(idTipo, hora, fraccion, recargo, activo)) {
            String detalle = "Tarifa de " + dao.nombreTipo(idTipo) + ": hora $" + (long) hora
                    + ", fracción $" + (long) fraccion + ", recargo $" + (long) recargo + ", estado " + (activo ? "Activo" : "Inactivo");
            AuditoriaDAO.registrar(usuario.getId(), "Modificar Tarifa", "Tarifas", detalle, request.getRemoteAddr());
            response.sendRedirect("TarifaServlet?ok=" + (activo ? "guardada" : "desactivada"));
        } else {
            request.setAttribute("errorGuardado", "true");
            mostrar(request, response, dao);
        }
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response, TarifaDAO dao)
            throws ServletException, IOException {
        request.setAttribute("tarifas", dao.listar());
        request.setAttribute("tipos", dao.tiposVehiculo());
        request.getRequestDispatcher("tarifas.jsp").forward(request, response);
    }

    private int aNumero(String texto) {
        try {
            return Integer.parseInt(texto.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    private double aDecimal(String texto) {
        try {
            return Double.parseDouble(texto.trim());
        } catch (Exception e) {
            return -1;
        }
    }
}

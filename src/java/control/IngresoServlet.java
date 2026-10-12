package control;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.IngresoDAO;
import modelo.Usuario;

/**
 * Registro de ingreso de vehículos.
 *  - GET  : muestra el formulario con los cupos libres y los últimos ingresos.
 *  - POST : recibe el formulario y guarda el ingreso.
 */
@WebServlet("/IngresoServlet")
public class IngresoServlet extends HttpServlet {

    // GET: abrir la página de ingreso
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (obtenerUsuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        cargarListas(request, new IngresoDAO());
        request.getRequestDispatcher("ingreso.jsp").forward(request, response);
    }

    // POST: guardar un ingreso
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Usuario admin = obtenerUsuario(request);
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String placaParam = request.getParameter("placa");
        String tipo = request.getParameter("tipo");
        String cupo = request.getParameter("cupo");

        IngresoDAO dao = new IngresoDAO();

        // 0. Validar que lleguen los datos
        if (placaParam == null || placaParam.trim().isEmpty() || tipo == null || cupo == null) {
            enviarError(request, response, dao, "❌ Faltan datos: placa, tipo de vehículo o cupo.");
            return;
        }
        String placa = placaParam.toUpperCase().trim();
        if (!placa.matches("[A-Z0-9-]{3,10}")) {
            enviarError(request, response, dao, "❌ La placa solo puede tener letras, números y guion (3 a 10 caracteres).");
            return;
        }

        // 1. ¿Ya está dentro?
        if (dao.existeVehiculoEnParqueo(placa)) {
            request.setAttribute("modalError", "true");
            request.setAttribute("placaDuplicada", placa);
            cargarListas(request, dao);
            request.getRequestDispatcher("ingreso.jsp").forward(request, response);
            return;
        }

        // 2. Tipo de vehículo
        int idTipo = dao.getIdTipoVehiculo(tipo);
        if (idTipo == 0) {
            enviarError(request, response, dao,
                    "❌ No se encontró el tipo de vehículo '" + tipo + "' en la base de datos. Verifica la tabla tipo_vehiculo.");
            return;
        }

        // 3. El cupo debe existir y estar disponible
        int idEspacio = dao.getIdEspacio(cupo);
        if (idEspacio == 0) {
            enviarError(request, response, dao,
                    "❌ No se encontró el cupo '" + cupo + "' en la base de datos. Verifica la tabla espacio_parqueo.");
            return;
        }
        String estadoCupo = dao.getEstadoEspacio(idEspacio);
        if (!"disponible".equalsIgnoreCase(estadoCupo)) {
            // Se muestra una alerta (modal) en la página y la lista de cupos se actualiza
            request.setAttribute("modalCupo", "true");
            request.setAttribute("cupoNoDisponible", cupo);
            request.setAttribute("estadoCupo", estadoCupo);
            cargarListas(request, dao);
            request.getRequestDispatcher("ingreso.jsp").forward(request, response);
            return;
        }

        // 4. Registrar el vehículo si es nuevo
        if (!dao.existeVehiculo(placa)) {
            if (!dao.registrarVehiculo(placa, idTipo)) {
                enviarError(request, response, dao,
                        "❌ No se pudo registrar el vehículo '" + placa + "'. Revisa la consola del servidor.");
                return;
            }
        }

        // 5. Guardar el registro
        LocalDateTime ahora = LocalDateTime.now();
        String fechaHora = ahora.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        int idRegistro = dao.guardarRegistro(placa, admin.getId(), idEspacio, fechaHora);

        if (idRegistro == 0) {
            enviarError(request, response, dao,
                    "❌ El registro NO se guardó. id_usuario=" + admin.getId() + ", id_espacio=" + idEspacio
                    + ". Revisa en la consola del servidor la línea 'ERROR REAL DE LA BASE DE DATOS'.");
            return;
        }

        // 6. Solo ahora el cupo pasa a ocupado
        dao.marcarOcupado(idEspacio);

        // 7. Preparar el mensaje de éxito
        request.setAttribute("modalExito", "true");
        request.setAttribute("tPlaca", placa);
        request.setAttribute("tTipo", tipo);
        request.setAttribute("tCupo", cupo);
        request.setAttribute("tHora", ahora.format(DateTimeFormatter.ofPattern("HH:mm")));
        request.setAttribute("tTicket", "TKT-" + idRegistro);
        cargarListas(request, dao);

        request.getRequestDispatcher("ingreso.jsp").forward(request, response);
    }

    private Usuario obtenerUsuario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (Usuario) session.getAttribute("usuario") : null;
    }

    // Datos que necesita ingreso.jsp: últimos ingresos y cupos libres
    private void cargarListas(HttpServletRequest request, IngresoDAO dao) {
        request.setAttribute("listaIngresos", dao.getUltimosIngresos());
        request.setAttribute("cuposLibres", dao.getCuposDisponibles());
    }

    private void enviarError(HttpServletRequest request, HttpServletResponse response,
                             IngresoDAO dao, String mensaje) throws ServletException, IOException {
        request.setAttribute("errorDebug", mensaje);
        cargarListas(request, dao);
        request.getRequestDispatcher("ingreso.jsp").forward(request, response);
    }
}

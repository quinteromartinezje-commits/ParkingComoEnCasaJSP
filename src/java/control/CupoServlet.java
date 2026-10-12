package control;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import dao.CupoDAO;
import dao.IngresoDAO;
import modelo.Usuario;
import util.Sesion;

// Mapa de cupos. GET: muestra los cupos (y abre la ventana si pulsan uno). POST: asigna un vehículo al cupo.
@WebServlet("/CupoServlet")
public class CupoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String cupo = request.getParameter("cupo");
        if (cupo != null && !cupo.isEmpty()) {
            IngresoDAO ingreso = new IngresoDAO();
            int idEspacio = ingreso.getIdEspacio(cupo);
            String estado = idEspacio == 0 ? "" : ingreso.getEstadoEspacio(idEspacio);

            if ("disponible".equalsIgnoreCase(estado)) {
                request.setAttribute("modal", "asignar");
                request.setAttribute("cupoElegido", cupo);
            } else if (!estado.isEmpty()) {
                request.setAttribute("modal", "ocupado");
                request.setAttribute("cupoElegido", cupo);
                request.setAttribute("estadoElegido", estado);
            }
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

        String cupo = limpiar(request.getParameter("cupo"));
        String tipo = limpiar(request.getParameter("tipo"));
        String placa = limpiar(request.getParameter("placa")).toUpperCase();
        request.setAttribute("cupoElegido", cupo);

        // 1. Datos obligatorios
        if (tipo.isEmpty() || placa.isEmpty()) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "Selecciona el tipo de vehículo y escribe la placa.");
            mostrar(request, response);
            return;
        }
        if (!placa.matches("[A-Z0-9-]{3,10}")) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "La placa solo puede tener letras, números y guion (3 a 10 caracteres).");
            mostrar(request, response);
            return;
        }

        IngresoDAO dao = new IngresoDAO();

        // 2. El cupo tiene que existir y estar disponible
        int idEspacio = dao.getIdEspacio(cupo);
        String estado = idEspacio == 0 ? "" : dao.getEstadoEspacio(idEspacio);
        if (!"disponible".equalsIgnoreCase(estado)) {
            request.setAttribute("modal", "ocupado");
            request.setAttribute("estadoElegido", estado.isEmpty() ? "no disponible" : estado);
            mostrar(request, response);
            return;
        }

        // 3. El tipo de vehículo debe ir con la zona: motos en M, carros y camionetas en A
        boolean cupoDeMotos = cupo.toUpperCase().startsWith("M");
        boolean esMoto = tipo.equalsIgnoreCase("Moto");
        if (cupoDeMotos != esMoto) {
            request.setAttribute("modal", "tipo");
            request.setAttribute("tipoElegido", tipo);
            mostrar(request, response);
            return;
        }

        // 3.1 La tarifa de ese tipo no puede estar inhabilitada
        if (dao.tarifaInactiva(tipo)) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "La tarifa de " + tipo + " está inhabilitada. Actívala en Tarifas.");
            mostrar(request, response);
            return;
        }

        // 4. La placa no puede estar ya dentro
        if (dao.existeVehiculoEnParqueo(placa)) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "La placa " + placa + " ya se encuentra dentro del parqueadero.");
            mostrar(request, response);
            return;
        }

        // 5. Guardar: vehículo (si es nuevo), registro de ingreso y cupo ocupado
        int idTipo = dao.getIdTipoVehiculo(tipo);
        if (idTipo == 0) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "El tipo de vehículo '" + tipo + "' no existe en la base de datos.");
            mostrar(request, response);
            return;
        }
        if (!dao.existeVehiculo(placa) && !dao.registrarVehiculo(placa, idTipo)) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "No se pudo registrar el vehículo. Revisa la consola.");
            mostrar(request, response);
            return;
        }
        String ahora = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        int idRegistro = dao.guardarRegistro(placa, usuario.getId(), idEspacio, ahora);
        if (idRegistro == 0) {
            request.setAttribute("modal", "asignar");
            request.setAttribute("mensajeModal", "El ingreso no se guardó. Revisa la consola.");
            mostrar(request, response);
            return;
        }
        dao.marcarOcupado(idEspacio);

        AuditoriaDAO.registrar(usuario.getId(), "Asignar Cupo", "Cupos",
                "Vehículo " + placa + " asignado al cupo " + cupo + " (TKT-" + idRegistro + ")", request.getRemoteAddr());

        request.setAttribute("modal", "exito");
        request.setAttribute("placaElegida", placa);
        request.setAttribute("ticketElegido", "TKT-" + idRegistro);
        mostrar(request, response);
    }

    // Prepara el mapa y abre cupos.jsp
    private void mostrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String zona = request.getParameter("zona");
        if (zona == null || (!zona.equals("A") && !zona.equals("M") && !zona.equals("todos"))) {
            zona = "A";
        }
        String buscar = limpiar(request.getParameter("buscar")).toUpperCase();

        CupoDAO dao = new CupoDAO();
        request.setAttribute("zona", zona);
        request.setAttribute("buscar", buscar);
        request.setAttribute("cupos", dao.listar(zona.equals("todos") ? "" : zona, buscar));
        request.setAttribute("disponibles", dao.contar("disponible"));
        request.setAttribute("ocupados", dao.contar("ocupado"));
        request.setAttribute("reservados", dao.contar("reservado"));
        request.getRequestDispatcher("cupos.jsp").forward(request, response);
    }

    private String limpiar(String texto) {
        return texto == null ? "" : texto.trim();
    }
}

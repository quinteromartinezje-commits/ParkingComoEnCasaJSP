package control;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.IngresoDAO;
import modelo.Ingreso;
import modelo.Usuario;

@WebServlet("/IngresoServlet")
public class IngresoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String placa = request.getParameter("placa").toUpperCase().trim();
        String tipo = request.getParameter("tipo");
        String cupo = request.getParameter("cupo");

        HttpSession session = request.getSession();
        Usuario admin = (Usuario) session.getAttribute("usuario");
        
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        IngresoDAO dao = new IngresoDAO();

        // 1. Validar si ya está dentro
        if (dao.existeVehiculoEnParqueo(placa)) {
            request.setAttribute("modalError", "true");
            request.setAttribute("placaDuplicada", placa);
            request.setAttribute("listaIngresos", dao.getUltimosIngresos());
            request.getRequestDispatcher("ingreso.jsp").forward(request, response);
            return;
        }

        // 2. Validaciones visibles
        int idTipo = dao.getIdTipoVehiculo(tipo);
        if (idTipo == 0) {
            request.setAttribute("errorDebug", "❌ No se encontró el tipo de vehículo '" + tipo + "' en la base de datos. Verifica la tabla tipo_vehiculo.");
            request.setAttribute("listaIngresos", dao.getUltimosIngresos());
            request.getRequestDispatcher("ingreso.jsp").forward(request, response);
            return;
        }

        if (!dao.existeVehiculo(placa)) {
            dao.registrarVehiculo(placa, idTipo);
        }
        
        int idEspacio = dao.ocuparEspacio(cupo);
        if (idEspacio == 0) {
            request.setAttribute("errorDebug", "❌ No se encontró el cupo '" + cupo + "' en la base de datos. Verifica la tabla espacio_parqueo.");
            request.setAttribute("listaIngresos", dao.getUltimosIngresos());
            request.getRequestDispatcher("ingreso.jsp").forward(request, response);
            return;
        }
        
        LocalDateTime ahora = LocalDateTime.now();
        String fechaHora = ahora.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String ticket = "TKT-" + (int)(Math.random() * 90000 + 10000);
        
        boolean guardado = dao.guardarRegistro(placa, admin.getId(), idEspacio, fechaHora, ticket);
        
        if (!guardado) {
            request.setAttribute("errorDebug", "❌ El registro NO se guardó. Error de llave foránea. id_usuario=" + admin.getId() + ", id_espacio=" + idEspacio + ". Revisa que existan en sus tablas.");
            request.setAttribute("listaIngresos", dao.getUltimosIngresos());
            request.getRequestDispatcher("ingreso.jsp").forward(request, response);
            return;
        }

        // 3. Preparar éxito
        request.setAttribute("modalExito", "true");
        request.setAttribute("tPlaca", placa);
        request.setAttribute("tTipo", tipo);
        request.setAttribute("tCupo", cupo);
        request.setAttribute("tHora", ahora.format(DateTimeFormatter.ofPattern("HH:mm")));
        request.setAttribute("tTicket", ticket);
        request.setAttribute("listaIngresos", dao.getUltimosIngresos());

        request.getRequestDispatcher("ingreso.jsp").forward(request, response);
    }
}
package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.AuditoriaDAO;
import dao.UsuarioAdminDAO;
import modelo.Usuario;
import modelo.UsuarioFila;
import util.Sesion;

// Usuarios. GET: lista (y ventanas con ?nueva, ?editar, ?eliminar). POST: guardar o eliminar.
@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (Sesion.usuario(request) == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UsuarioAdminDAO dao = new UsuarioAdminDAO();

        String editar = request.getParameter("editar");
        if (editar != null) {
            request.setAttribute("usuarioEditar", dao.buscar(aNumero(editar)));
        }
        String eliminar = request.getParameter("eliminar");
        if (eliminar != null) {
            request.setAttribute("usuarioEliminar", dao.buscar(aNumero(eliminar)));
        }

        String ok = request.getParameter("ok");
        if ("guardado".equals(ok)) {
            request.setAttribute("modalGuardado", "El usuario ha sido creado/actualizado correctamente.");
        } else if ("eliminado".equals(ok)) {
            request.setAttribute("modalGuardado", "El usuario ha sido eliminado.");
        } else if ("desactivado".equals(ok)) {
            request.setAttribute("modalGuardado", "Este usuario ya tiene movimientos registrados, por eso no se borró: su cuenta quedó inactiva.");
        }
        mostrar(request, response, dao);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Usuario sesion = Sesion.usuario(request);
        if (sesion == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UsuarioAdminDAO dao = new UsuarioAdminDAO();
        String accion = request.getParameter("accion");

        // ---- Eliminar ----
        if ("eliminar".equals(accion)) {
            int id = aNumero(request.getParameter("id"));
            UsuarioFila u = dao.buscar(id);
            if (id == sesion.getId()) {
                request.setAttribute("mensajeError", "No puedes eliminar tu propio usuario.");
                mostrar(request, response, dao);
                return;
            }
            String resultado = dao.eliminar(id);
            if (resultado.equals("error")) {
                request.setAttribute("mensajeError", dao.getError());
                mostrar(request, response, dao);
                return;
            }
            AuditoriaDAO.registrar(sesion.getId(), "Eliminar Usuario", "Usuarios",
                    (u != null ? u.correo : "usuario " + id) + " (" + resultado + ")", request.getRemoteAddr());
            response.sendRedirect("UsuarioServlet?ok=" + resultado);
            return;
        }

        // ---- Guardar (crear o actualizar) ----
        int id = aNumero(request.getParameter("id"));
        String nombre = limpiar(request.getParameter("nombre"));
        String documento = limpiar(request.getParameter("documento"));
        String correo = limpiar(request.getParameter("correo")).toLowerCase();
        String clave = limpiar(request.getParameter("clave"));
        String rol = limpiar(request.getParameter("rol"));
        boolean activo = !"Inactivo".equals(request.getParameter("estado"));

        // Validaciones sencillas (antes las hacía JavaScript)
        String problema = null;
        if (nombre.isEmpty() || documento.isEmpty() || correo.isEmpty() || rol.isEmpty()) {
            problema = "Complete todos los campos obligatorios.";
        } else if (!correo.contains("@")) {
            problema = "El correo no es válido.";
        } else if (id == 0 && clave.length() < 6) {
            problema = "La contraseña debe tener mínimo 6 caracteres.";
        } else if (id != 0 && !clave.isEmpty() && clave.length() < 6) {
            problema = "La contraseña debe tener mínimo 6 caracteres.";
        } else if (dao.existeDocumento(documento, id)) {
            problema = "Ya existe una persona con ese documento.";
        }
        if (problema != null) {
            request.setAttribute("mensajeError", problema);
            mostrar(request, response, dao);
            return;
        }

        // Correo repetido -> ventana "Usuario ya existe"
        if (dao.existeCorreo(correo, id)) {
            request.setAttribute("correoDuplicado", correo);
            mostrar(request, response, dao);
            return;
        }

        boolean guardado;
        if (id == 0) {
            guardado = dao.crear(nombre, documento, correo, clave, rol, activo);
        } else {
            guardado = dao.actualizar(id, nombre, documento, correo, clave, rol, activo);
        }
        if (!guardado) {
            request.setAttribute("mensajeError", dao.getError());
            mostrar(request, response, dao);
            return;
        }

        AuditoriaDAO.registrar(sesion.getId(), id == 0 ? "Crear Usuario" : "Modificar Usuario", "Usuarios",
                nombre + " (" + correo + "), rol " + rol, request.getRemoteAddr());
        response.sendRedirect("UsuarioServlet?ok=guardado");
    }

    private void mostrar(HttpServletRequest request, HttpServletResponse response, UsuarioAdminDAO dao)
            throws ServletException, IOException {
        request.setAttribute("usuarios", dao.listar());
        request.getRequestDispatcher("usuarios.jsp").forward(request, response);
    }

    private int aNumero(String texto) {
        try {
            return Integer.parseInt(texto.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    private String limpiar(String texto) {
        return texto == null ? "" : texto.trim();
    }
}

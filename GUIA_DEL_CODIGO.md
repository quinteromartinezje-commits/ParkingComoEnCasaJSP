# Guía del código — Parking Como en Casa

Esta guía está escrita para entender el proyecto sin saber mucho de código.
La idea es poder explicar con tus palabras qué hace cada parte.

---

## 1. La idea general: cómo viaja la información

Cada pantalla del parqueadero funciona igual, con **tres piezas**:

```
 JSP (lo que se ve)  →  Servlet (el que decide)  →  DAO (el que habla con la base de datos)
```

| Pieza | Qué es | Ejemplo |
|-------|--------|---------|
| **JSP** | La página: el HTML que ve el usuario, con un poquito de Java adentro | `ingreso.jsp` |
| **Servlet** | Recibe lo que el usuario hizo (clic, formulario), revisa que esté bien y le pide al DAO que guarde o consulte | `IngresoServlet.java` |
| **DAO** | Solo se encarga de escribir y leer en MySQL | `IngresoDAO.java` |
| **Modelo** | Una "ficha" con los datos de algo (un vehículo, una reserva) | `Reserva.java` |

Piensa en un restaurante: el JSP es el menú y la mesa, el Servlet es el mesero y el DAO es el cocinero.

---

## 2. GET y POST (lo que pide la evidencia)

- **GET** = *pedir* una página o buscar algo. Los datos viajan en la dirección.
  Ejemplo: `SalidaServlet?buscar=ABC-123` busca esa placa.
  En el código es el método `doGet`.
- **POST** = *enviar* datos para guardarlos (un formulario). Los datos no se ven en la dirección.
  Ejemplo: al darle "Registrar Ingreso". En el código es el método `doPost`.

Regla fácil: **GET para mirar, POST para guardar.**

---

## 3. Módulo por módulo

### Login — `LoginServlet`
1. El usuario escribe correo y clave en `login.jsp` (POST).
2. El servlet le pregunta a `UsuarioDAO` si existen en la base de datos.
3. Si existen, guarda al usuario en la **sesión** (como una "manilla" que dice que ya entró) y lo manda al dashboard.
4. Si no, vuelve al login con un mensaje.

### Ingreso — `IngresoServlet` + `IngresoDAO`
- **GET:** muestra el formulario con los cupos libres y la lista de últimos ingresos.
- **POST:** revisa que la placa sea válida, que no esté ya dentro y que el cupo esté libre.
  - Si el cupo está ocupado, aparece la ventana "Cupo no disponible".
  - Si todo está bien: guarda el vehículo, guarda el ingreso y marca el cupo como `ocupado`.

### Salida — `SalidaServlet` + `SalidaDAO`
- **GET** (`?buscar=...`): busca el vehículo que sigue dentro y calcula cuánto debe pagar.
- **POST:** confirma el pago. El DAO hace tres cosas, en orden:
  1. Guarda la hora de salida.
  2. Guarda el pago (comprobante).
  3. Deja el cupo `disponible` otra vez.
- **¿Cómo se cobra?** Por hora o fracción, mínimo una hora. Ejemplo: 61 minutos con tarifa de $4.000 → se cobran 2 horas = $8.000.
  Ese cálculo está en el método `calcular()` de `Salida.java`.

### Reservas — `ReservaServlet` + `ReservaDAO`
- **GET:** muestra el formulario y la lista de reservas activas.
- **POST con `accion=crear`:** valida los datos y el DAO guarda cliente, vehículo, la reserva (por un mes) y el pago. El cupo queda `reservado` (amarillo en el dashboard).
- **POST con `accion=cancelar`:** la reserva queda `cancelada` y el cupo vuelve a `disponible`.

### Dashboard — `DashboardServlet` + `DashboardDAO`
- Cada tarjeta es **una consulta** a la base de datos. Por ejemplo, "Ingresos Hoy" cuenta los registros de parqueo con la fecha de hoy.
- Por eso se actualiza solo: cada vez que cargas la página, vuelve a preguntar.
- Colores del mapa de cupos: azul = disponible, gris = ocupado, amarillo = reservado.

### Pantallas de administración (todas con la misma idea)

| Pantalla | Servlet (+ DAO) | Qué hace |
|---|---|---|
| Tarifas | `TarifaServlet` + `TarifaDAO` | Ver, crear, editar y eliminar tarifas (hora, fracción, recargo). `?editar=ID` abre la ventana de edición. |
| Cupos | `CupoServlet` + `CupoDAO` | Mapa de cupos por zona (A carros, M motos). Al pulsar un cupo libre se abre la ventana para asignar un vehículo. |
| Usuarios | `UsuarioServlet` + `UsuarioAdminDAO` | Crear, editar y eliminar personal. Si el usuario ya tiene movimientos, no se borra: queda inactivo. |
| Reportes | `ReporteServlet` + `ReporteDAO` | Totales, barras y categorías de un rango de fechas. `exportar=csv` descarga un archivo para Excel. |
| Auditoría | `AuditoriaServlet` + `AuditoriaDAO` | Lista de quién hizo qué, con filtros y páginas de 10. Los servlets llaman a `AuditoriaDAO.registrar(...)`. |
| Consulta | `ConsultaServlet` + `ConsultaDAO` | Busca por placa o ticket; `?ver=ID` muestra el detalle de esa fila. |
| Incidentes | `IncidenteServlet` + `IncidenteDAO` | Registra y lista incidentes (necesita `actualizacion_java.sql`). |
| Perfil | `PerfilServlet` + `PerfilDAO` | Ver y editar los datos propios y cambiar la contraseña. |

**¿Y los modales sin JavaScript?** El servlet manda un dato (por ejemplo `abrir = "editar"`) y la página pone la clase `active` solo a esa ventana:
`<div class="modal-overlay<%= "editar".equals(abrir) ? " active" : "" %>">`. Para cerrarla hay un enlace que vuelve al servlet.

### Pedazos compartidos (`.jspf`)
- `sesion.jspf`: revisa que haya sesión y define `ver()` y `plata()`.
- `menu.jspf`: el menú lateral (marca la opción activa con la variable `paginaActiva`).
- `cabecera.jspf`: la barra de arriba con el título (`tituloPagina`) y el usuario.
Se pegan en cada página con `<%@ include file="menu.jspf" %>` (directiva de inclusión).

---

## 4. Elementos JSP que se usan (por si te preguntan)

| Elemento | Cómo se ve | Para qué sirve |
|----------|-----------|----------------|
| **Directiva** | `<%@ page import="modelo.Salida" %>` | Configurar la página e importar clases |
| **Scriptlet** | `<% for (Tarifa t : tarifas) { ... } %>` | Escribir código Java normal dentro del JSP |
| **Expresión** | `<%= nombre %>` | Mostrar un valor en la página |
| **Declaración** | `<%! String ver(String t) { ... } %>` | Crear una función para usarla en esa página |
| **Inclusión** | `<%@ include file="menu.jspf" %>` | Pegar un pedazo que se repite (menú, encabezado) |

Las funciones de ayuda (están en `sesion.jspf`):
- `ver(texto)`: si el texto viene vacío no muestra la palabra "null", y cambia los signos `< > "` para que lo que escriba el usuario no dañe la página.
- `plata(valor)`: convierte `16250` en `$16.250`.

---

## 5. La conexión a la base de datos

`util/ConexionBD.java` guarda el usuario, la contraseña y la dirección de MySQL. Todos los DAO la usan así:

```java
Connection conn = ConexionBD.getConnection();
PreparedStatement ps = conn.prepareStatement("SELECT ... WHERE placa = ?");
ps.setString(1, placa);          // aquí se pone el valor del "?"
ResultSet rs = ps.executeQuery(); // el resultado
while (rs.next()) { ... }         // recorrer fila por fila
```

Se usa `?` en vez de pegar el texto directamente para que nadie pueda colar comandos SQL por el formulario.

---

## 6. Qué pasa cuando algo falla

Los DAO no muestran errores raros al usuario: guardan un mensaje en una variable (`error`) y el Servlet lo muestra en pantalla.
El error técnico completo sale en la pestaña **Output** de NetBeans (busca `ERROR`).

---

## 7. Para probar rápido

1. Ejecuta en Workbench `database/actualizacion_dashboard.sql` y luego `database/datos_de_prueba.sql`.
2. Entra con `admin@comoencasa.com` / `admin123`.
3. Registra un ingreso → mira el dashboard.
4. Registra la salida de esa placa → mira cómo suben "Salidas Hoy" y "Recaudado".
5. Crea una reserva → el cupo se pone amarillo.

---

## 8. Cosas simples a propósito (y cómo mejorarlas después)

- Las contraseñas se guardan como texto normal en la base de datos. En un proyecto real se guardan cifradas.
- Cada guardado (por ejemplo la salida) hace 3 pasos seguidos. Si falla justo en el medio podría quedar a medias. Una mejora futura son las *transacciones*.

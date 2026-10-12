# Parking Como en Casa

Aplicación web para administrar un parqueadero: registrar ingresos y salidas de vehículos, cobrar el tiempo de
estadía, reservar cupos y ver todo en un dashboard que se actualiza solo.

Proyecto de la evidencia **GA7-220501096-AA2-EV02 – Módulos de software codificados y probados**.

Hecho con **Java (Servlets), JSP, HTML, CSS y MySQL**. No usa JavaScript: toda la lógica está en Java, en NetBeans con Tomcat.

---

## ¿Qué hace cada pantalla?

| Pantalla | Qué hace | Servlet que la atiende |
|---|---|---|
| **Login** | Inicia sesión con correo y contraseña | `LoginServlet` |
| **Dashboard** | Muestra ingresos, salidas, cupos, reservas, recaudo e incidentes del día, el mapa de cupos y la actividad reciente. Se refresca cada 30 segundos | `DashboardServlet` |
| **Ingreso** | Registra la entrada de un vehículo y le asigna un cupo libre | `IngresoServlet` |
| **Salida** | Busca el vehículo por placa o ticket, calcula cuánto debe pagar, registra el pago y libera el cupo | `SalidaServlet` |
| **Reservas** | Reserva un cupo por un mes para un cliente y permite cancelarla | `ReservaServlet` |

### ¿Cómo se actualiza el dashboard?

El dashboard no tiene números escritos a mano: todo lo calcula `DashboardDAO` con consultas a la base de datos.

- **Registrar un ingreso** → sube "Ingresos Hoy", baja "Cupos Disponibles", el cupo se pinta gris y aparece en "Actividad Reciente".
- **Registrar una salida** → sube "Salidas Hoy" y "Recaudado Diario", el cupo vuelve a azul.
- **Crear una reserva** → sube "Reservas Activas" y "Recaudado Diario" (se paga la mensualidad), y el cupo se pinta amarillo.
- **Cancelar una reserva** → el cupo queda disponible otra vez.

---

## Cómo se cumple cada punto de la lista de chequeo

**1. Formularios HTML con servlets**
- `ingreso.jsp` → formulario hacia `IngresoServlet`
- `salida.jsp` → formularios hacia `SalidaServlet`
- `reservas.jsp` → formularios hacia `ReservaServlet`
- `login.jsp` → formulario hacia `LoginServlet`
- `tarifas.jsp`, `cupos.jsp`, `usuarios.jsp`, `reportes.jsp`, `auditoria.jsp`, `consulta.jsp`, `incidentes.jsp`, `perfil.jsp`
  → formularios hacia `TarifaServlet`, `CupoServlet`, `UsuarioServlet`, `ReporteServlet`, `AuditoriaServlet`, `ConsultaServlet`, `IncidenteServlet` y `PerfilServlet`

**2. Métodos GET y POST**
- **GET** (pedir o consultar datos): `DashboardServlet` (abrir el dashboard), `IngresoServlet` (abrir el formulario con cupos libres),
  `SalidaServlet?buscar=ABC-123` (buscar un vehículo), `ReservaServlet` (ver las reservas).
- **POST** (enviar datos que se guardan): `LoginServlet`, `IngresoServlet` (guardar ingreso), `SalidaServlet` (confirmar pago y salida),
  `ReservaServlet` (crear o cancelar una reserva).

**3. Elementos de JSP**
- Directivas: `<%@ page contentType=... %>` y `<%@ page import=... %>`
- Scriptlets: `<% ... %>` (recorrer listas con `for`, condiciones con `if`)
- Declaraciones: `<%! ... %>` (las funciones de ayuda `ver()`, `plata()` y `activo()`)
- Inclusión: `<%@ include file="menu.jspf" %>` (el menú, el encabezado y la revisión de sesión se escriben una sola vez)
- Expresiones: `<%= ... %>` (mostrar nombre, cupos, totales)
- Objetos de JSP: `session`, `request` y `response`

**4. Versionamiento**
- El proyecto está en Git y se sube a GitHub. El enlace está en `ENLACE_REPOSITORIO.txt`.

---

## Cómo está organizado el código

```
src/java/
  control/   Servlets (reciben lo que envía la página)
  dao/       Consultas a la base de datos (cada archivo se ocupa de un tema)
  modelo/    Clases simples que llevan datos de un lado a otro
  util/      ConexionBD (conexión a MySQL)
web/
  *.jsp      Páginas que ve el usuario
  *.jspf     Pedazos que se repiten (sesion, menu, cabecera)
  css/ img/  (no hay carpeta js: el proyecto no usa JavaScript)
database/
  actualizacion_dashboard.sql   Datos y columnas que necesita el proyecto
  actualizacion_java.sql        Columnas de incidentes y roles (ejecutar una vez)
  datos_de_prueba.sql           Datos de ejemplo
```

Cada pantalla sigue la misma idea: **la página (JSP) → el servlet → el DAO → la base de datos**, y de vuelta.

---

## Cómo ejecutarlo

1. Tener instalados **NetBeans**, **Tomcat**, **Java** y **MySQL**.
2. En MySQL debe existir la base `mydb` con las tablas del proyecto y un usuario con acceso
   (por defecto `jess` / `1234`; se cambia en `src/java/util/ConexionBD.java`).
3. Abrir en MySQL Workbench el archivo `database/actualizacion_dashboard.sql` y ejecutarlo **una sola vez**.
   Carga los medios de pago, las tarifas por hora y las columnas para las reservas.
   Después ejecutar también `database/actualizacion_java.sql` (columnas de la pantalla Incidentes y los roles).
4. Abrir el proyecto en NetBeans. Si aparece algún icono rojo en **Libraries**, agregar el conector de MySQL
   (`mysql-connector-j`) y la librería Java EE API.
5. Clic derecho sobre el proyecto → **Clean and Build** → **Run**.
6. Entrar con `admin@comoencasa.com` / `admin123`.

## Cómo probarlo (recorrido de 2 minutos)

1. Entrar al **Dashboard** y fijarse en los números.
2. Ir a **Ingreso**, registrar un vehículo (por ejemplo placa `ABC-123`, Carro, cupo `A-03`).
3. Volver al **Dashboard**: subieron los ingresos, el cupo `A-03` está en gris y aparece en la actividad.
4. Ir a **Reservas**, reservar el cupo `A-05` para un cliente. En el dashboard `A-05` se ve amarillo.
5. Ir a **Salida**, buscar `ABC-123`, elegir el medio de pago y **Completar Pago**.
6. Volver al **Dashboard**: sube "Salidas Hoy" y "Recaudado Diario", y `A-03` vuelve a azul.

## Cómo se calcula el cobro

- Se cobra por **hora o fracción** (mínimo una hora), según la tarifa vigente del tipo de vehículo (tabla `tarifas`).
- Ejemplo con tarifa de $4.000: 50 minutos → $4.000; 1 hora 10 minutos → $8.000; 3 horas 15 minutos → $16.000.
- Todo el cálculo lo hace el servidor; la página solo muestra el resultado.

## Detalles de seguridad que se tuvieron en cuenta

- Las consultas usan `PreparedStatement` (los datos se pasan como parámetros, no pegados al texto SQL).
- Lo que escribe el usuario se limpia antes de mostrarse (función `ver()` dentro de cada JSP) para que no se interprete como HTML.
- Cada página y servlet comprueba que haya una sesión iniciada.
- La salida y las reservas usan **transacciones**: si un paso falla, no se guarda nada a medias.

## ¿Cómo funciona sin JavaScript?

- Las ventanas emergentes (modales) las decide el servidor: el servlet envía un dato y la página escribe `class="modal-overlay active"` solo si toca mostrarla. Se cierran con un enlace que vuelve al servlet.
- Editar y eliminar funcionan con enlaces (`TarifaServlet?editar=3`) y el servlet vuelve a pintar la página con el formulario lleno.
- Las validaciones las hacen el navegador (`required`, `type="email"`, `min`) y, sobre todo, el servlet.
- Las placas en mayúsculas: CSS (`text-transform`) en pantalla y `toUpperCase()` en el servlet.
- Los filtros (Auditoría, Reportes, Consulta, Cupos) son formularios GET normales.

## Limitaciones conocidas
- Reportes se exporta a CSV (abre en Excel); no hay PDF.
- Incidentes no sube fotos de evidencia.
- Las contraseñas están en texto plano en la base de datos (simple a propósito).

## Para entender el código
Lee `GUIA_DEL_CODIGO.md`: explica en palabras sencillas cómo funciona cada módulo.

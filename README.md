# Parking Como en Casa

Proyecto del SENA (ficha 3336184) para administrar un parqueadero: registrar ingresos y salidas de vehículos, cobrar por el tiempo, manejar cupos, reservas y tarifas, y consultar reportes.

Lo hicimos entre Katherine Ramírez, Jesika Quintero y Luis Manuel Robelto, con el instructor Eduer Pabón.

## Con qué está hecho

- Java con Servlets y JSP
- Servidor Apache Tomcat
- Base de datos MySQL (la base se llama `mydb`)
- HTML y CSS para las pantallas
- NetBeans para programar y Git/GitHub para guardar el proyecto

## Cómo correrlo

1. Abrir el proyecto en NetBeans (File > Open Project).
2. En MySQL, crear la base `mydb` con las tablas del diseño y luego ejecutar los scripts de la carpeta `database`: primero `actualizacion_dashboard.sql`, después `actualizacion_java.sql` y por último `datos_de_prueba.sql`.
3. Agregar al proyecto el driver de MySQL (el archivo mysql-connector-j .jar) en Libraries > Add JAR.
4. Abrir `src/java/util/ConexionBD.java` y poner el usuario y la clave de MySQL de su computador.
5. Hacer Clean and Build y darle Run. Se abre la pantalla de inicio de sesión en el navegador.

Los usuarios de prueba están en `database/datos_de_prueba.sql`.

## Pantallas

Inicio de sesión, Dashboard, Ingreso, Salida, Reservas, Cupos (mapa de ocupación), Tarifas, Usuarios, Reportes, Auditoría, Consulta de vehículos, Incidentes y Mi Perfil.

## Cómo está organizado

- `src/java/control`: los Servlets, uno por pantalla.
- `src/java/dao`: las clases que hacen las consultas a la base de datos.
- `src/java/modelo`: las clases que guardan los datos (Ingreso, Salida, Tarifa, etc.).
- `src/java/util`: la conexión a la base y ayudas de sesión.
- `web`: las pantallas (`.jsp`), el menú y la cabecera (`.jspf`), los estilos en `css` y las imágenes.
- `database`: los scripts SQL.

## Algunas reglas del sistema

- Los cupos que empiezan por M son solo para motos y los que empiezan por A son para carros y camionetas.
- El cobro es por hora o fracción, con un mínimo de una hora.
- Una tarifa inhabilitada no se puede usar para nuevos ingresos.

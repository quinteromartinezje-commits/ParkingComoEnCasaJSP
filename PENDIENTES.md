# Pendientes del proyecto — Parking Como en Casa

Lo que ya funciona está en el `README.md`. Esto es lo que falta, para que lo tome el resto del equipo.
Los números CU-XX son los de la plantilla de casos de uso.

## Falta construir (pantallas)

- [ ] **CU-10 Registrar pagos mensuales.** Buscar al cliente por nombre o placa, ver su estado y fecha de vencimiento,
      registrar el pago del mes y extender el vencimiento. Si el pago es parcial, guardar el saldo pendiente.
      Hoy `Reservas` solo crea la mensualidad; no la renueva.
- [ ] **CU-05 Solicitar factura.** Página con el comprobante de un servicio ya pagado (fecha, placa, tiempo, valor)
      y marcarlo como "facturado". Hoy solo existe el tiquete que sale en el modal de Salida.

## Falta completar (flujos alternativos de los CU)

- [ ] **CU-04 Pago insuficiente.** En Salida pedir el "monto recibido" y avisar cuánto falta si no alcanza.
- [ ] **CU-03 Tiempo de gracia.** Si el vehículo sale antes del tiempo mínimo, el valor es $0 (hoy se cobra mínimo una hora).
- [ ] **CU-01 / CU-02 Parqueadero lleno.** Mostrar "parqueadero lleno" / "no hay celdas disponibles" cuando no hay cupos.
- [ ] **CU-01 Disponibilidad por tipo.** Mostrar cuántos cupos hay de carros y cuántos de motos.
- [ ] **CU-12 Exportar a PDF** en Reportes (hoy solo CSV para Excel).
- [ ] **Incidentes:** subir foto de evidencia (hoy no se guarda ninguna imagen).

## Mejoras técnicas

- [ ] Guardar las contraseñas cifradas (hoy están en texto normal en `credenciales_acceso`).
- [ ] Usar transacciones en los guardados de varios pasos (por ejemplo, la salida).
- [ ] Separar los roles: que el Operario no vea Usuarios, Tarifas ni Auditoría.
- [ ] Pasar el cliente como actor (CU-01, 03, 05, 06): hoy solo usa el sistema el personal del parqueadero.
- [ ] Probar con más datos y revisar que todas las pantallas se vean bien en pantalla pequeña.

## Para probar

Ejecutar `database/actualizacion_dashboard.sql` y `database/actualizacion_java.sql` una sola vez (más la línea de
`tarifas.estado` que está al final de este último). Los datos de ejemplo están en `database/datos_de_prueba.sql`.

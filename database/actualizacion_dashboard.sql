-- ============================================================
--  Parking Como en Casa - Actualización de la base de datos
--  Ejecutar UNA SOLA VEZ en MySQL Workbench (base: mydb)
--  Sirve para que el dashboard, la salida y las reservas funcionen.
-- ============================================================
USE mydb;

-- 1) Medios de pago que aparecen en la pantalla de Salida y Reservas
INSERT IGNORE INTO metodo_pago (nombre_metodo) VALUES
  ('Efectivo'), ('Tarjeta'), ('QR/Transferencia');

-- 2) Tarifas por hora (valores de ejemplo en pesos colombianos; puedes cambiarlos)
INSERT INTO tarifas (id_tipo_vehiculo, modalidad, valor_unidad, tarifa_vigente)
SELECT id, 'Hora', 4000, 1 FROM tipo_vehiculo
WHERE nombre_tipo = 'Carro'
  AND NOT EXISTS (SELECT 1 FROM tarifas WHERE id_tipo_vehiculo = tipo_vehiculo.id AND modalidad = 'Hora');

INSERT INTO tarifas (id_tipo_vehiculo, modalidad, valor_unidad, tarifa_vigente)
SELECT id, 'Hora', 2000, 1 FROM tipo_vehiculo
WHERE nombre_tipo = 'Moto'
  AND NOT EXISTS (SELECT 1 FROM tarifas WHERE id_tipo_vehiculo = tipo_vehiculo.id AND modalidad = 'Hora');

INSERT INTO tarifas (id_tipo_vehiculo, modalidad, valor_unidad, tarifa_vigente)
SELECT id, 'Hora', 5000, 1 FROM tipo_vehiculo
WHERE nombre_tipo = 'Camioneta'
  AND NOT EXISTS (SELECT 1 FROM tarifas WHERE id_tipo_vehiculo = tipo_vehiculo.id AND modalidad = 'Hora');

-- 3) Reservas: cada reserva (suscripción mensual) guarda su cupo y la fecha en que se creó
ALTER TABLE suscripciones_mensuales
  ADD COLUMN id_espacio_parqueo INT NULL AFTER id_placa,
  ADD COLUMN fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD CONSTRAINT fk_suscripciones_espacio
      FOREIGN KEY (id_espacio_parqueo) REFERENCES espacio_parqueo (id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

-- 4) Limpieza: libera los cupos que quedaron "ocupado" por las pruebas anteriores
--    sin ningún vehículo dentro.
SET SQL_SAFE_UPDATES = 0;
UPDATE espacio_parqueo
SET estado_actual = 'disponible'
WHERE LOWER(estado_actual) = 'ocupado'
  AND id NOT IN (SELECT id_espacio_parqueo FROM registros_parqueo
                 WHERE fecha_hora_salida IS NULL AND id_espacio_parqueo IS NOT NULL);
SET SQL_SAFE_UPDATES = 1;

-- Si dos vehículos aparecen dentro del mismo cupo (pasó en las pruebas), registra la
-- salida de uno desde la pantalla "Salida" o muévelo a otro cupo, por ejemplo:
--   UPDATE registros_parqueo SET id_espacio_parqueo = 3 WHERE id = 13;
--   UPDATE espacio_parqueo SET estado_actual = 'ocupado' WHERE id = 3;

-- 5) Revisión rápida
SELECT * FROM metodo_pago;
SELECT * FROM tarifas;
SELECT id, codigo_espacio, estado_actual FROM espacio_parqueo;

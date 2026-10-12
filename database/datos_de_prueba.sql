-- ============================================================
--  Parking Como en Casa - DATOS DE PRUEBA
--  Ejecutar DESPUÉS de actualizacion_dashboard.sql
--  Ejecutar UNA SOLA VEZ (si lo repites, los tickets duplicados darán error, es normal)
--  Las fechas usan NOW(), así el dashboard siempre muestra datos "de hoy".
-- ============================================================
USE mydb;

-- 1. Roles y usuarios --------------------------------------------------
INSERT IGNORE INTO rol (id, nombre) VALUES (2, 'Operario'), (3, 'Cliente');

INSERT INTO usuario (id_rol, nombre_completo, documento, fecha_registro)
SELECT 2, 'Carlos Pérez', '1010101010', NOW()
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE documento = '1010101010');

INSERT INTO credenciales_acceso (id_usuario, correo, clave, cuenta_activa, nombre, rol)
SELECT u.id, 'operario@comoencasa.com', 'operario123', 1, 'Carlos Pérez', 'operario'
FROM usuario u
WHERE u.documento = '1010101010'
  AND NOT EXISTS (SELECT 1 FROM credenciales_acceso WHERE correo = 'operario@comoencasa.com');

-- 2. Clientes ----------------------------------------------------------
INSERT IGNORE INTO cliente (nombre_completo, documento, telefono, correo) VALUES
 ('Laura Gómez',   '1020304050', '3001112233', 'laura.gomez@correo.com'),
 ('Andrés Ruiz',   '1098765432', '3104445566', 'andres.ruiz@correo.com'),
 ('María Torres',  '52123456',   '3207778899', 'maria.torres@correo.com');

-- 3. Vehículos ---------------------------------------------------------
INSERT IGNORE INTO vehiculos (placa, id_tipo_vehiculo, marca, modelo, color) VALUES
 ('ABC123', 1, 'Mazda',   '2019', 'Rojo'),
 ('XYZ789', 1, 'Renault', '2020', 'Gris'),
 ('KLM456', 1, 'Chevrolet','2018','Negro'),
 ('MOT45A', 2, 'Yamaha',  '2021', 'Azul'),
 ('MOT88B', 2, 'Honda',   '2022', 'Blanco'),
 ('CAM321', 3, 'Toyota',  '2017', 'Verde'),
 ('RES001', 3, 'Ford',    '2020', 'Plateado');

-- 4. Ingresos que YA SALIERON hoy (con su pago) ------------------------
-- Carro XYZ789: estuvo 2 horas en A-03 -> 2 x 4000 = 8000
INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso, fecha_hora_salida, tiempo_permanencia)
SELECT 'XYZ789', 1, e.id, NOW() - INTERVAL 180 MINUTE, NOW() - INTERVAL 60 MINUTE, 120
FROM espacio_parqueo e WHERE e.codigo_espacio = 'A-03';
SET @r1 = LAST_INSERT_ID();
INSERT INTO comprobantes_pago (id_registro_parqueo, id_metodo_pago, numero_ticket, subtotal, impuestos, total_pagado, fecha_hora_pago)
SELECT @r1, m.id, CONCAT('TKT-', @r1), 8000, 0, 8000, NOW() - INTERVAL 60 MINUTE
FROM metodo_pago m WHERE m.nombre_metodo = 'Efectivo';

-- Moto MOT45A: estuvo 90 min en M-01 -> 2 horas (fracción) x 2000 = 4000
INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso, fecha_hora_salida, tiempo_permanencia)
SELECT 'MOT45A', 1, e.id, NOW() - INTERVAL 120 MINUTE, NOW() - INTERVAL 30 MINUTE, 90
FROM espacio_parqueo e WHERE e.codigo_espacio = 'M-01';
SET @r2 = LAST_INSERT_ID();
INSERT INTO comprobantes_pago (id_registro_parqueo, id_metodo_pago, numero_ticket, subtotal, impuestos, total_pagado, fecha_hora_pago)
SELECT @r2, m.id, CONCAT('TKT-', @r2), 4000, 0, 4000, NOW() - INTERVAL 30 MINUTE
FROM metodo_pago m WHERE m.nombre_metodo = 'Tarjeta';

-- 5. Movimientos de AYER (para que la tarjeta muestre la variación) ----
INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso, fecha_hora_salida, tiempo_permanencia)
SELECT 'KLM456', 1, e.id, NOW() - INTERVAL 1 DAY - INTERVAL 300 MINUTE, NOW() - INTERVAL 1 DAY - INTERVAL 120 MINUTE, 180
FROM espacio_parqueo e WHERE e.codigo_espacio = 'A-05';
SET @r3 = LAST_INSERT_ID();
INSERT INTO comprobantes_pago (id_registro_parqueo, id_metodo_pago, numero_ticket, subtotal, impuestos, total_pagado, fecha_hora_pago)
SELECT @r3, m.id, CONCAT('TKT-', @r3), 12000, 0, 12000, NOW() - INTERVAL 1 DAY - INTERVAL 120 MINUTE
FROM metodo_pago m WHERE m.nombre_metodo = 'Efectivo';

-- 6. Vehículos que están DENTRO ahora (cupos ocupados) -----------------
INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso)
SELECT 'ABC123', 1, e.id, NOW() - INTERVAL 90 MINUTE FROM espacio_parqueo e WHERE e.codigo_espacio = 'A-04';
INSERT INTO registros_parqueo (id_placa, id_usuario, id_espacio_parqueo, fecha_hora_ingreso)
SELECT 'MOT88B', 1, e.id, NOW() - INTERVAL 20 MINUTE FROM espacio_parqueo e WHERE e.codigo_espacio = 'M-02';
UPDATE espacio_parqueo SET estado_actual = 'ocupado' WHERE codigo_espacio IN ('A-04', 'M-02');

-- 7. Una reserva (mensualidad activa) en el cupo A-10 ------------------
INSERT INTO suscripciones_mensuales (id_cliente, id_placa, fecha_inicio, fecha_fin, valor_mensualidad, estado_suscripcion, id_espacio_parqueo)
SELECT c.id, 'RES001', CURDATE(), CURDATE() + INTERVAL 1 MONTH, 150000, 'activa', e.id
FROM cliente c, espacio_parqueo e
WHERE c.documento = '1020304050' AND e.codigo_espacio = 'A-10';
SET @s1 = LAST_INSERT_ID();
INSERT INTO comprobantes_pago (id_suscripcion, id_metodo_pago, numero_ticket, subtotal, impuestos, total_pagado, fecha_hora_pago)
SELECT @s1, m.id, CONCAT('RES-', @s1), 150000, 0, 150000, NOW()
FROM metodo_pago m WHERE m.nombre_metodo = 'Transferencia';
UPDATE espacio_parqueo SET estado_actual = 'reservado' WHERE codigo_espacio = 'A-10';

-- 8. Incidente y apertura de caja del día ------------------------------
INSERT INTO incidentes (id_usuario, descripcion, ubicacion, fecha_hora)
VALUES (1, 'Puerta de acceso con falla', 'Entrada principal', NOW() - INTERVAL 45 MINUTE);

INSERT INTO cajas (id_usuario, fecha_hora_apertura, monto_inicial)
VALUES (1, CURDATE() + INTERVAL 6 HOUR, 50000);

INSERT INTO auditoria (id_usuario, accion_realizada, tabla_afectada, descripcion_detalle, fecha_hora_accion, direccion_ip)
VALUES (1, 'Datos de prueba cargados', 'registros_parqueo', 'Carga inicial para pruebas del dashboard', NOW(), '127.0.0.1');

-- 9. Revisión rápida ---------------------------------------------------
SELECT estado_actual, COUNT(*) AS cupos FROM espacio_parqueo GROUP BY estado_actual;

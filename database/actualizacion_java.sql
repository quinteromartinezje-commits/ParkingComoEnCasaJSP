-- =====================================================================
-- ACTUALIZACIÓN PARA LA VERSIÓN "PURO JAVA" (sin JavaScript)
-- Ejecútalo UNA vez en MySQL Workbench sobre la base de datos mydb.
-- Si algún ALTER dice "Duplicate column name", esa columna ya existe: sigue con el siguiente.
-- =====================================================================
USE mydb;

-- 1) Incidentes: ahora guardan placa, tipo (Daño/Novedad/Reclamo) y prioridad
ALTER TABLE incidentes ADD COLUMN placa VARCHAR(10) NULL;
ALTER TABLE incidentes ADD COLUMN tipo VARCHAR(20) NULL;
ALTER TABLE incidentes ADD COLUMN prioridad VARCHAR(10) NULL;

-- 2) Roles que usa la pantalla Usuarios (si ya existen no pasa nada)
INSERT IGNORE INTO rol (nombre) VALUES ('Supervisor'), ('Operario');

-- 3) Tarifas: columna "estado" (1 = activa, 0 = inhabilitada)
ALTER TABLE tarifas ADD COLUMN estado TINYINT(1) NOT NULL DEFAULT 1;

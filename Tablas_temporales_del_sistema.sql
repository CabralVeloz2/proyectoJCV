--Activo la base de datos
USE CampingJCV2
GO
--Controla la existencia de la tabla
DROP TABLE IF EXISTS Cliente2
GO
--Creo la tabla reserva_clase
CREATE TABLE Cliente2
( ID_cliente INTEGER IDENTITY(1,1) PRIMARY KEY,
  DNI CHAR(9),
  Nombre VARCHAR(30),
  Apellido VARCHAR(30),
  Telefono CHAR(9),
  SysStartTime datetime2 generated always as row start not null, 
  SysEndTime datetime2 generated always as row end not null,
             period for System_time (SysStartTime,SysEndTime) ) 
  with (System_Versioning = ON (History_Table = dbo.Client_history) 
) -- Activa el versionado del sistema y le pone el nombre a la tabla que va a almacenar los datos de las versiones
GO
-- Comprabamos ambas tablas, a�n no contienen datos 
SELECT * FROM Cliente2
GO
SELECT * FROM Client_history
GO-- Insertamos datos-- Insertar datos en la tabla de cliente2
INSERT INTO Cliente2 (DNI, Nombre, Apellido, Telefono)
VALUES 
  ('123456789', 'Juan', 'P�rez', '987654321'),
  ('987654321', 'Mar�a', 'G�mez', '123456789'),
  ('111223344', 'Carlos', 'L�pez', '555555555'),
  ('555111222', 'Ana', 'Mart�nez', '777888999'),
  ('999888777', 'Pedro', 'Garc�a', '111222333');
--(5 rows affected)

-- Comprobamos la fecha y hora 
PRINT GETUTCDATE()
GO-- Nov 27 2023 10:43PM-- Consultamos nuevamnete, la tabla Cliente2 debe tener datos, pero Cllient_history no.SELECT * FROM Cliente2
GO
SELECT * FROM Client_history
GO







-- Modifico
-- Actualizar los DNI de Ana y Pedro en la tabla de clientes
UPDATE Cliente2
SET DNI = '123456789'
WHERE Nombre = 'Ana';

UPDATE Cliente2
SET DNI = '987654321'
WHERE Nombre = 'Pedro';

--(1 row affected)
--(1 row affected)
--Completion time: 2023-11-27T23:49:11.2113128+01:00

-- Consulto 
SELECT * FROM Cliente2
GO

-- Consulto la Tabla Historial,  nos muestra la fecha que se hizo la actualizacion.
-- Vemos que muestra el contenido antiguo. 
SELECT * FROM Client_history
GO


-- Realizamos otra modificaci�n
-- Actualizar los nombres de Ana y Pedro en la tabla de clientes
UPDATE Cliente2
SET Nombre = 'Jose'
WHERE Nombre = 'Ana';

UPDATE Cliente2
SET Nombre = 'Daniel'
WHERE Nombre = 'Pedro';

--(1 row affected)
--(1 row affected)
--Completion time: 2023-11-27T23:56:02.2865404+01:00

-- Consulto 
SELECT * FROM Cliente2
GO

SELECT * FROM Client_history
GO


-- Hago una �ltima actualizaci�n 
-- Actualizar los n�meros de tel�fono de Jose y Daniel en la tabla de clientes
UPDATE Cliente2
SET Telefono = '999999999'
WHERE Nombre = 'Jose';

UPDATE Cliente2
SET Telefono = '111111111'
WHERE Nombre = 'Daniel';

--(1 row affected)
--(1 row affected)
--Completion time: 2023-11-28T00:01:07.6285369+01:00

-- Consulto 
SELECT * FROM Cliente2
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999


SELECT * FROM Client_history
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--4	555111222	Ana	Mart�nez	777888999	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--5	999888777	Pedro	Garc�a	111222333	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--4	123456789	Ana	Mart�nez	777888999	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--5	987654321	Pedro	Garc�a	111222333	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369





-- Borrar clientes con apellido 'Mart�nez' de la tabla
DELETE FROM Cliente2
WHERE Apellido = 'Mart�nez';

-- Consulto
SELECT * FROM Cliente2
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999

-- Consulto a la tabla historico y muestra los valores anteriores
SELECT * FROM Client_history
GO--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--4	555111222	Ana	Mart�nez	777888999	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--5	999888777	Pedro	Garc�a	111222333	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--4	123456789	Ana	Mart�nez	777888999	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--5	987654321	Pedro	Garc�a	111222333	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227


-- Inserto un nuevo registro en la tabla de Cliente2
INSERT INTO Cliente2 (DNI, Nombre, Apellido, Telefono)
VALUES ('777444333', 'Nuevo', 'Cliente', '555666777');

-- Consulto tabla Cliente2
SELECT * FROM Cliente2
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999
--6	777444333	Nuevo	Cliente	555666777	2023-11-27 23:12:57.1362998	9999-12-31 23:59:59.9999999

-- Consulto tabla Client_history
SELECT * FROM Client_history
GO
ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--4	555111222	Ana	Mart�nez	777888999	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--5	999888777	Pedro	Garc�a	111222333	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--4	123456789	Ana	Mart�nez	777888999	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--5	987654321	Pedro	Garc�a	111222333	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227

-- Lo borramos y pasa lo contario, lo vemos en la tabla Hisotrial pero no en la tabla Principal.
-- Borramos el �ltimo registro de la tabla de Cliente2
DELETE FROM Cliente2
WHERE DNI = '777444333';
--(1 row affected)

-- Consulto tabla Cliente2. No vemos el cliente con ID_cliente 6
SELECT * FROM Cliente2
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999

-- Consulto tabla Client_history. Si vemos el cliente con ID_cliente 6
SELECT * FROM Client_history
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--4	555111222	Ana	Mart�nez	777888999	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--5	999888777	Pedro	Garc�a	111222333	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--4	123456789	Ana	Mart�nez	777888999	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--5	987654321	Pedro	Garc�a	111222333	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227
--6	777444333	Nuevo	Cliente	555666777	2023-11-27 23:12:57.1362998	2023-11-27 23:21:44.7551151


--Tipos de consultas
--AS OF <date_time>
--FROM <start_date_time> TO <end_date_time>
--BETWEEN <start_date_time> AND <end_date_time>
--CONTAINED IN (<start_date_time> , <end_date_time>)
--ALL
--Las subclausulas m�s utilizadas son FROM y BETWEEN




SELECT * FROM Cliente2
FOR SYSTEM_TIME AS OF '2023-11-28 12:00:00';
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999

SELECT * FROM Cliente2
FOR SYSTEM_TIME FROM '2023-11-27 23:01:07' TO '2023-11-27 23:59:59';
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227
--6	777444333	Nuevo	Cliente	555666777	2023-11-27 23:12:57.1362998	2023-11-27 23:21:44.7551151




SELECT * FROM Cliente2
FOR SYSTEM_TIME BETWEEN '2023-11-27 23:01:07' AND '2023-12-31 23:59:59';
GO
--DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999
--123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227
--777444333	Nuevo	Cliente	555666777	2023-11-27 23:12:57.1362998	2023-11-27 23:21:44.7551151





SELECT * FROM Cliente2
FOR SYSTEM_TIME CONTAINED IN ('2023-01-01 00:00:00', '2023-12-31 23:59:59');
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--4	555111222	Ana	Mart�nez	777888999	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--5	999888777	Pedro	Garc�a	111222333	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--4	123456789	Ana	Mart�nez	777888999	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--5	987654321	Pedro	Garc�a	111222333	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227
--6	777444333	Nuevo	Cliente	555666777	2023-11-27 23:12:57.1362998	2023-11-27 23:21:44.7551151





SELECT * FROM Cliente2
FOR SYSTEM_TIME ALL;
GO
--ID_cliente	DNI	Nombre	Apellido	Telefono	SysStartTime	SysEndTime
--1	123456789	Juan	P�rez	987654321	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--2	987654321	Mar�a	G�mez	123456789	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--3	111223344	Carlos	L�pez	555555555	2023-11-27 22:42:26.3886316	9999-12-31 23:59:59.9999999
--5	987654321	Daniel	Garc�a	111111111	2023-11-27 23:01:07.6285369	9999-12-31 23:59:59.9999999
--4	555111222	Ana	Mart�nez	777888999	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--5	999888777	Pedro	Garc�a	111222333	2023-11-27 22:42:26.3886316	2023-11-27 22:49:11.2113128
--4	123456789	Ana	Mart�nez	777888999	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--5	987654321	Pedro	Garc�a	111222333	2023-11-27 22:49:11.2113128	2023-11-27 22:56:02.2865404
--4	123456789	Jose	Mart�nez	777888999	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--5	987654321	Daniel	Garc�a	111222333	2023-11-27 22:56:02.2865404	2023-11-27 23:01:07.6285369
--4	123456789	Jose	Mart�nez	999999999	2023-11-27 23:01:07.6285369	2023-11-27 23:05:01.5162227
--6	777444333	Nuevo	Cliente	555666777	2023-11-27 23:12:57.1362998	2023-11-27 23:21:44.7551151


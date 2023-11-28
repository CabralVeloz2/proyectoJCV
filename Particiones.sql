--Creo una base de datos llamada ‘CampingJCV_Particiones’:

-- Crear una base de datos
USE master;
GO
DROP DATABASE IF EXISTS CampingJCV_Particion;
GO
-- Crear la base de datos
CREATE DATABASE CampingJCV_particion;
GO

-- Cambiar a la base de datos
USE CampingJCV_particion;

-- Crear cuatro grupos de archivos
ALTER DATABASE CampingJCV_particion
ADD FILEGROUP Historico_2019;

ALTER DATABASE CampingJCV_particion
ADD FILEGROUP Historico_2020;

ALTER DATABASE CampingJCV_particion
ADD FILEGROUP Historico_2021;

ALTER DATABASE CampingJCV_particion
ADD FILEGROUP Historico_2022;


-- Asignar archivos a cada grupo de archivos
ALTER DATABASE CampingJCV_particion
ADD FILE
(
    NAME = 'Historico_2019_File',
    FILENAME = 'C:\CampingJCV_particiones\Historico_2020_Data.ndf'
)
TO FILEGROUP Historico_2019;

ALTER DATABASE CampingJCV_particion
ADD FILE
(
    NAME = 'Historico_2020_File',
    FILENAME = 'C:\CampingJCV_particiones\Historico_2021_Data.ndf'
)
TO FILEGROUP Historico_2020;

ALTER DATABASE CampingJCV_particion
ADD FILE
(
    NAME = 'Historico_2021_File',
    FILENAME = 'C:\CampingJCV_particiones\Historico_2022_Data.ndf'
)
TO FILEGROUP Historico_2021;

ALTER DATABASE CampingJCV_particion
ADD FILE
(
    NAME = 'Historico_2022_File',
    FILENAME = 'C:\CampingJCV_particiones\Historico_2023_Data.ndf'
)
TO FILEGROUP Historico_2022;

-- Crear un esquema de partición por rango basado en una columna de fecha
CREATE PARTITION FUNCTION ParticionPorFecha (DATE)
AS RANGE RIGHT
FOR VALUES ('2020-01-01', '2021-01-01');

-- Crear un esquema de partición para asignar grupos de archivos
CREATE PARTITION SCHEME EsquemaParticionPorFecha
AS PARTITION ParticionPorFecha
TO (
    Historico_2019,
    Historico_2020,
    Historico_2021,
    Historico_2022
);

-- Crear una tabla particionada con grupos de archivos asignados
DROP TABLE IF EXISTS Reserva_partition
GO
CREATE TABLE Reserva_partition
(   ID_reserva INT IDENTITY (1,1),
	Numero_personas INT,
	Fecha DATE )
	ON EsquemaParticionPorFecha -- esquema de particion
	(Fecha) -- la columna para aplicar la función dentro del esquema
GO
-- Insertamos datos
INSERT INTO Reserva_partition
VALUES ('5','2019-01-10'),
	   ('1','2019-02-11'),
       ('4','2019-03-12'),
       ('2','2019-04-13')
GO--Compruebo con:
SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Partition
FROM Reserva_partition
GO-- Nuevos datos-- Insertamos datos
INSERT INTO Reserva_partition
VALUES ('3','2020-01-10'),
	   ('1','2020-02-11'),
       ('1','2020-03-12'),
       ('1','2020-04-13')
GO--Compruebo con:
SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Partition
FROM Reserva_partition
GO




-- Nuevos datos-- Insertamos datos
INSERT INTO Reserva_partition
VALUES ('2','2021-01-10'),
	   ('2','2021-02-11'),
       ('2','2021-03-12'),
       ('2','2021-04-13')
GO--Compruebo con:
SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Partition
FROM Reserva_partition
GO-- Nuevos datos-- Insertamos datos
INSERT INTO Reserva_partition
VALUES ('1','2022-01-10'),
	   ('1','2022-02-11'),
       ('1','2022-03-12'),
       ('1','2022-04-13')
GO--Compruebo con:
SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Partition
FROM Reserva_partition
GO
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- SPLIT

ALTER PARTITION FUNCTION ParticionPorFecha()
SPLIT RANGE ('2022-01-01');
GO


SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Particion
FROM Reserva_partition
GO


-- MERGE

-- Fusionar particiones en la función de partición
ALTER PARTITION FUNCTION ParticionPorFecha()
MERGE RANGE ('2020-01-01');
GO

SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Particion
FROM Reserva_partition
GO


-- SWITCH
-- Creamos una tabla donde moveremos los datos
DROP TABLE IF EXISTS Reserva_partition_nueva
GO
CREATE TABLE Reserva_partition_nueva
(   ID_reserva INT IDENTITY (1,1),
	Numero_personas INT,
	Fecha DATE )
	ON EsquemaParticionPorFecha 
	(Fecha) 
GO

-- Intercambiar la partición entre las dos tablas
ALTER TABLE Reserva_partition SWITCH PARTITION 1 TO Reserva_partition_nueva PARTITION 1;
GO

-- Consulto la tabla
SELECT * FROM Reserva_partition_nueva
GO



-- TRUNCATE
TRUNCATE TABLE Reserva_partition
WITH (PARTITIONS (1));
GO

-- Consulto
SELECT *,$Partition.ParticionPorFecha(Fecha)
AS Particion
FROM Reserva_partition
GO
-- Crear la Base de Datos
DROP DATABASE IF EXISTS Camping_IN_MEMORY;
GO
CREATE DATABASE Camping_IN_MEMORY;
GO

-- Cambiarse a la Base de Datos recién creada
USE Camping_IN_MEMORY;
GO

-- Habilitar la Opción de Optimización en Memoria para la Base de Datos
ALTER DATABASE Camping_IN_MEMORY
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;
GO

-- Crear un Grupo de Archivos para Tablas en Memoria
ALTER DATABASE Camping_IN_MEMORY
ADD FILEGROUP Camping_IN_MEMORY_MOD CONTAINS MEMORY_OPTIMIZED_DATA;
GO

-- Agregar un Contenedor de Datos para el Grupo de Archivos de Tablas en Memoria
ALTER DATABASE Camping_IN_MEMORY
ADD FILE (name='Camping_IN_MEMORY_mod1', filename='C:\Camping_IN_MEMORY_mod1') 
TO FILEGROUP Camping_IN_MEMORY_MOD;
GO

-- Crear una Tabla en Memoria
CREATE TABLE Clientes3
(
    ClienteID INT NOT NULL PRIMARY KEY NONCLUSTERED,
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Edad INT
)
WITH (MEMORY_OPTIMIZED = ON);
GO



--EJEMPLO BÁSICO
-- Insertamos datos en la tabla Clientes3
INSERT INTO Clientes3 (ClienteID, Nombre, Apellido, Edad)
VALUES (1, 'Juan', 'Perez', 30),
       (2, 'Maria', 'Gomez', 25),
       (3, 'Carlos', 'Rodriguez', 35);
GO
-- Seleccionamos todos los clientes
SELECT * FROM Clientes3;
--ClienteID	Nombre	Apellido	Edad
--3	        Carlos	Rodriguez	35
--1	        Juan	Perez		30
--2	        Maria	Gomez		25

-- Actualizamos la edad de Juan Perez
UPDATE Clientes3 SET Edad = 31 WHERE ClienteID = 1;
GO

-- Seleccionamos todos los clientes después de la actualización
SELECT * FROM Clientes3;
GO
--ClienteID	Nombre	Apellido	Edad
--3			Carlos	Rodriguez	35
--2			Maria	Gomez		25
--1			Juan	Perez		31

-- Eliminamos a Carlos Rodriguez de la tabla
DELETE FROM Clientes3 WHERE ClienteID = 3;
GO

-- Seleccionamos todos los clientes después de la eliminación
SELECT * FROM Clientes3;
GO
--ClienteID	Nombre	Apellido	Edad
--2			Maria	Gomez		25
--1			Juan	Perez		31
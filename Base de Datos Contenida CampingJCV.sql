-- Bases de Datos Contenidas

USE master
GO
EXEC sp_configure
GO
--A uno se activan opciones avanzadas / provoca que haga el cambio
EXEC sp_configure 'show advanced options', 1 --Activa 1 Desactiva 0
GO
--Actualizamos el valor
RECONFIGURE
GO
--Activamos la caracteristicas
EXEC sp_configure 'contained database authentication', 1
GO
--Actualizamos de nuevo
RECONFIGURE
GO
--Hasta aqui preparamos el entorno para lo que vamos a ejecutar--Creamos la base de datos ‘Contenida_CampingJCV’ siempre controlando su existencia y la activamos, también creamos un usuario
--'Joel_Camping', le damos el rol de dbo_owner y permisos para que se pueda conectar.DROP DATABASE IF EXISTS Contenida_CampingJCV
GO
CREATE DATABASE Contenida_CampingJCV
CONTAINMENT=PARTIAL
GO
--Una vez creada la activamos la base de datos
USE Contenida_CampingJCV
GO
--Creo usuario con nuestras iniciales, asocio esquema ddb
--Compruebo su existencia
DROP USER IF EXISTS Joel_camping
GO
--Creo al usuario
CREATE USER Joel_camping
WITH PASSWORD='Abc123.',
DEFAULT_SCHEMA=[dbo]
GO
--Añadimos el usuario AQL_Surf el rol dbo_owner
--Deprecated / esta en desuso
EXEC sp_addrolemember 'db_owner', 'Joel_camping'
GO
--Esta es la nueva
ALTER ROLE db_owner
ADD MEMBER Joel_camping
GO
--Damos permisos de GRSNT para que el usuario AQL_Surf se pueda conectar
GRANT CONNECT TO Joel_camping
GO
--Desde Transact-SQL
EXEC sp_configure 'show advanced options', 1 --Activa 1 Desactiva 0
GO
RECONFIGURE;
GO
EXEC sp_configure 'Agent XPs', 1
GO
RECONFIGURE;
GO--Se ha cambiado la opción de configuración 'show advanced options' de 1 a 1. Ejecute la instrucción RECONFIGURE para instalar.
--Se ha cambiado la opción de configuración 'Agent XPs' de 1 a 1. Ejecute la instrucción RECONFIGURE para instalar.
--Completion time: 2023-11-04T09:03:29.5703537+01:00
-- Creo una tablaCREATE TABLE Cliente (
 ID INT IDENTITY (1,1),
 Nombre VARCHAR (20),
 Apellido VARCHAR (20),
 DNI CHAR (9)
 ) ON [PRIMARY]
 GO
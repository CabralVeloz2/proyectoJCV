
-- CREAR UN SP(STORED PROCEDURE PROCEDIMIENTO ALMACENADO) PARA REALIZAR EL BACKUP DE ALGUNA O TODAS LAS BD DEL INSTANCIA

-- PROCEDIMIENTOS ALMACENADOS - PARAMETRO DE ENTRADA
-- TABLA TEMPORAL  #NOMBRETABLA
-- VARIABLES : DECLARACIÓN DECLARE - ASIGNACIÓN SET o SELECT
-- ESTRUCTURA REPETITIVA WHILE - CONTADOR



USE master
GO
DROP PROCEDURE IF EXISTS BACKUP_ALL_DB_PARENTRADA_JCV
GO
-- PATH = RUTA

CREATE OR ALTER PROC BACKUP_ALL_DB_PARENTRADA_JCV
	@path VARCHAR(256) -- PARAMETRO DE ENTRADA PARA DAR RUTA
AS
-- Declarando variables
DECLARE @name VARCHAR(50), -- database name
-- @path VARCHAR(256), -- path for backup files
@fileName VARCHAR(256), -- filename for backup
@fileDate VARCHAR(20), -- used for file name
@backupCount INT

-- TABLA TEMPORAL #tempBackup 

CREATE TABLE [dbo].#tempBackup 
	(intID INT IDENTITY (1, 1), 
	name VARCHAR(200))

-- OTRA POSIBILIDAD. ASIGNAR LA RUTA A UNA VARIABLE la Carpeta Backup
-- SET @path = 'C:\Backup\'

-- INCLUIR LA FECHA EN EL NOMBRE DE FICHERO RESULTANTE
-- Includes the date in the filename
SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

-- INCLUIR LA FECHA Y LA HOARA EN EL NOMBRE DE FICHERO RESULTANTE
-- Includes the date and time in the filename
-- SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(20), GETDATE(), 108), ':', '')

INSERT INTO [dbo].#tempBackup (name)
	SELECT name
	FROM master.dbo.sysdatabases
	WHERE name in ( 'CampingJCV','CampingJCV2')
-- WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')

SELECT TOP 1 @backupCount = intID 
FROM [dbo].#tempBackup 
ORDER BY intID DESC

-- Utilidad: PARA COMPROBAR NUMERO DE Backups a realizar. SOLO PARA DEPURACIÓN LUGO LO BORRARÍA.
print @backupCount

-- COMPROBAR QUE HAY ALGUNA BD A LA CUAL REALIZARLE EL BACKUP
IF ((@backupCount IS NOT NULL) AND (@backupCount > 0))
BEGIN
	DECLARE @currentBackup INT
	SET @currentBackup = 1 -- ASIGNACIÓN DEL VALOR INICIAL
	WHILE (@currentBackup <= @backupCount) -- MIENTRAS QUE SE CUMPLA LA CONDICIÓN SE EJECUTA EL BUCLE
		BEGIN
			SELECT
				@name = name,
				@fileName = @path + name + '_' + @fileDate + '.BAK' -- Unique FileName
				--@fileName = @path + @name + '.BAK' -- Non-Unique Filename
				FROM [dbo].#tempBackup
				WHERE intID = @currentBackup

			-- Utilidad: Solo Comprobaci n Nombre Backup
			print @fileName
			
			-- SIN INIT NO SOBREESCRIBE EL FICHERO. MEJOR USAR WITH INIT
			-- does not overwrite the existing file
				BACKUP DATABASE @name TO DISK = @fileName
			-- overwrites the existing file (Note: remove @fileDate from the fileName so they are no longer unique
			--BACKUP DATABASE @name TO DISK = @fileName WITH INIT

				SET @currentBackup = @currentBackup + 1 -- CONTADOR
		END
END

-- Utilidad: Solo ComprobaciÓn Mirar panel de Resultados Autonumerico y Nombre BD
SELECT * FROM [dbo].#tempBackup
-- 
DROP TABLE [dbo].#tempBackup

GO


-- Ejecutar Procedimiento
-- Input Parameter 'C:\Backup\'
EXEC BACKUP_ALL_DB_PARENTRADA_JCV 'C:\BackupJCV\'
GO

-- RESULTADO

-- Results

--intID	name
--1	Northwind
--2	pubs


-- Messages


--(2 rows affected)
--2
--C:\Backup\Pubs_20230927.BAK
--Processed 752 pages for database 'Pubs', file 'pubs' on file 1.
--Processed 1 pages for database 'Pubs', file 'pubs_log' on file 1.
--BACKUP DATABASE successfully processed 753 pages in 0.049 seconds (119.927 MB/sec).
--C:\Backup\Northwind_20230927.BAK
--Processed 1264 pages for database 'Northwind', file 'Northwind' on file 1.
--Processed 1 pages for database 'Northwind', file 'Northwind_log' on file 1.
--BACKUP DATABASE successfully processed 1265 pages in 0.061 seconds (161.909 MB/sec).

--(2 rows affected)

-- MIRAR
-- Check Out
-- Folder C:\Backup\

-- Northwind_20230927.bak
-- Pubs_20230927.bak

-------------------------------------------------------------------------------

-- DBCC CLONEDATABASE

-- https://support.microsoft.com/en-us/help/3177838/how-to-use-dbcc-clonedatabase-to-generate-a-schema-and-statistics-only
-- https://docs.microsoft.com/es-es/sql/t-sql/database-console-commands/dbcc-clonedatabase-transact-sql?view=sql-server-2017


-- Generate the clone of Pubs database.    
DBCC CLONEDATABASE (Pubs, Pubs_Clone);    
GO 

-- SQL Server 2016 without service pack 

--Msg 2526, Level 16, State 3, Line 116
--Incorrect DBCC statement. Check the documentation for the correct DBCC syntax and options.


--Crear un clon de una base de datos que se comprueba para su uso en producci n que incluye una copia de seguridad de la base de datos clonada
--En el ejemplo siguiente se crea un clon de solo esquema de la base de datos AdventureWorks sin datos de estad sticas ni de almac n de consultas que se comprueba para su uso como base de datos de producci n. Tambi n se crear  una copia de seguridad comprobada de la base de datos clonada ( SQL Server 2016 (13.x) SP2 y versiones posteriores).

DBCC CLONEDATABASE (AdventureWorks2014, AdventureWorks_Clone) WITH VERIFY_CLONEDB, BACKUP_CLONEDB;    
GO
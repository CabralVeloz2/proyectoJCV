USE master
GO
EXEC sp_configure filestream_access_level, 2
RECONFIGURE
--Creo la base de datos con filegroup para el filestream
--le doy la ruta
DROP DATABASE IF EXISTS CampingJCV_filetable
GO
CREATE DATABASE CampingJCV_filetable
ON PRIMARY(
NAME = CampingJCV_filetable_data,
FILENAME = 'C:\CampingJCV_filetable\FT.mdf'
),
FILEGROUP FileStreamFG CONTAINS FILESTREAM
(
NAME = CampingJCV_filetable,
FILENAME = 'C:\CampingJCV_filetable\FT_Container'
)
LOG ON
(
NAME = CampingJCV_filetable_Log,
FILENAME = 'C:\CampingJCV_filetable\FT_Log.ldf'
)
WITH FILESTREAM
(
NON_TRANSACTED_ACCESS = FULL,
DIRECTORY_NAME = 'FT_Container'
);
GO
--Consulto los metadatos
SELECT DB_NAME(database_id),
non_transacted_access,
non_transacted_access_desc
FROM sys.database_filestream_options;
GO--Crear una FileTable en la base de datos
USE CampingJCV_filetable; 

-- Crear una FileTable en la base de datos
CREATE TABLE Filetable_JCV AS FileTable
   WITH (
      FileTable_Directory = 'Filetable_JCV',   
      FileTable_Collate_Filename = database_default,
      FileTable_streamid_unique_constraint_name=uq_stream_id
   );
GO

-- Consultamos la tabla
SELECT *
FROM Filetable_JCV
GO

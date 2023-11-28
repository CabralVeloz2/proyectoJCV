USE CampingJCV_3;
GO

INSERT INTO [dbo].[Images_CampingJCV] (id,imageFile)
SELECT NEWID(), BulkColumn
FROM OPENROWSET(BULK N'C:\ImagenesJCV\Git-logo.svg.png', SINGLE_BLOB) AS f;
GO

--INSERT INTO [dbo].[Images_CampingJCV] (ID, ImageFile)
--VALUES (1, CAST('C:\ImagenesJCV\Git-logo.svg' AS VARBINARY(MAX)));
--GO



--Comprobamos con SELECT 
SELECT *
FROM Images_CampingJCV;
GO


-- BORRAMOS LA TABLA

--Borrar la tabla
ALTER TABLE Images_CampingJCV DROP COLUMN ImageFile
GO
--Commands completed successfully.
--Completion time: 2023-11-23T00:11:59.6077335+01:00

DROP TABLE Images_CampingJCV;
--Commands completed successfully.
--Completion time: 2023-11-23T00:11:59.6077335+01:00

USE master
GO
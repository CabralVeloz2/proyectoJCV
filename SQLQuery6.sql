

-- ACID ATOMICITY CONSISTENCY ISOLATION DURABILITY
-- A ATOMICIDAD    TODAS LAS OPERACIONES DE LA TRANSACCIÓN O NINGUNA


-- TRANSACCIONES IMPLICITAS - EXPLICITAS
-- BEGIN TRAN - COMMIT - ROLLBACK
-- UNION ALL
-- TRY-CATCH

-- DEMOSTRACIÓN DE QUE EN OCASIONES USAR TRANSACCIONES IMPLICITAS EN LUGAE DE EXPLICITAS PUEDE PROVOCAR ERRORE

-- NOTA
-- MANTENGO EL EJEMPLO CON INSERT
-- SERÍA MÁS CORRECTO USAR UPDATE 
-- CAMBIAR EJEMPLO PARA USAR UPDATE EN VUESTRA DEMOSTRACIÓN

USE master
GO
DROP DATABASE IF EXISTS  EXPLITRAN
GO
CREATE DATABASE EXPLITRAN
GO
USE EXPLITRAN
GO
DROP TABLE IF EXISTS Checking
GO
CREATE TABLE dbo.Checking
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
DROP TABLE IF EXISTS Savings
GO
CREATE TABLE dbo.Savings
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
-- INSERTO EN MI CUENTA CORRIENTE

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 25.00, 'Starting my checking account', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 100.00, 'Starting my savings account, Thanks dad!', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total		AccountType
--100.00	Savings
--25.00		Checking

-- CONFIRMACIÓN IMPLICITA DE LA TRANSACCIÓN USA MENOS CODIGO 
-- PERO A VECES PUEDE PROVOCAR RESULTADOS INCORRECTOS

-- Auto-commit is about as simple as it gets. 
-- It's going to require the least amount of code. 
-- However, it does have drawbacks. 

-- ALGO VA MAL CON EL PRIMER INSERT ENTONCES NO QUIERES QUE SE EJECUTE EL 2 INSERT

--The primary one we'll focus on here is if something goes wrong with the first insert statement 
-- and you don't want the second insert statement to execute, you're out of luck. 
-- Let's look at this in action. 
-- VOY A INTENTAR MOVER 100 DESDE MI CUENTA DE AHORRO A MI CUENTA CORRIENTE
--In the example below, I'm moving $100 from my savings account into my checking.  
-- See the following example:

-- NOTA : EJECUTO LAS 2 INSERCIONES JUNTAS
-- PERO LA PRIMERA FALLA

-- INTENTO RETIRAR 100 DE MI CUENTA DE AHORRO
INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(2, -100.00, 'Taking money out of my savings account.', GETDATE());
GO
-- INTENTO CARGAR 100 DE MI CUENTA CORRIENTE

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(2, 100.00, 'Taking money out of my account for a copy of a new NES game, sorry dad! I will replace it after I get a job.', GETDATE());
GO

--(1 row affected)
--Msg 2628, Level 16, State 1, Line 77
--String or binary data would be truncated in table 'EXPLITRAN.dbo.Checking', column 'ShortDescription'. Truncated value: 'Taking money out of my account for a copy of a new NES game, sorry dad! I will replace it after I ge'.

-- NOS DA ERROR AL INTENTAR INSERTAR EN table 'EXPLITRAN.dbo.Checking'
-- SIN EMBARGO LA INSERCIÓN EN LA TABLA DE AHORRO "FUNCIONA"
-- Notice that the first insert SQL command will fail.
-- I hope my savings account isn't missing $100. However, I would be wrong.

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total	AccountType
--0.00	Savings
--25.00	Checking

-- CONFIRMANDO CON SELECT INDIVIDUALES
SELECT * FROM Savings
go

--ID	Amount	ShortDescription						TransactionDate
--1		100.00	Starting my savings account, Thanks dad!	2023-09-26
--2		-100.00	Taking money out of my savings account.		2023-09-26

SELECT SUM(Amount) AS [Total], 'Savings' AS [AccountType]
FROM dbo.Savings
GO

--Total	AccountType
--0.00	Savings

SELECT * FROM dbo.Checking;
go

--ID	Amount	ShortDescription	          TransactionDate
--1	    25.00	Starting my checking account	2023-09-26

SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total	AccountType
--25.00	Checking

----------------------------------------------------
--------------------------------------------------------

-- TRANSACCIONES EXPLICITAS
-- MANTENER ACID
-- ATOMICITY CONSISTENCY ISOLATION DURABILITY
-- Nuestro Caso ATOMICITY
-- ATOMICITY SE TIENE QUE EJECUTAR TODAS LAS OPERACIONES DE LA TRANSACCIÓN O NINGUN
-- BEGIN - END TRANSACTION
-- COMMIT TRANSACTION		confirmar
-- ROLLBACK TRANSACTION		deshacer

-- PUEDES CONTROLAR EXCEPCIONES Y/O ERRORES CON TRY...CATCH
-- EN LUGAR DE TRY...CATCH PUEDES USAR SET XACT_ABORT ON
-- Hace ROLLBACK SI SE PRODUCE UNA EXCEPCIÓN
-- 
--Explicit Transaction in T-SQL
--With explicit transactions, you tell SQL Server to start a transaction by issuing the BEGIN TRANSACTION
-- syntax. Once your statement finishes, you can ROLLBACK or COMMIT. 
-- Ideally, you would wrap the transaction in a TRY...CATCH block. 
--You can roll back the transaction and raise the exception if an error occurs.

--If you don't want to deal with a TRY...CATCH, 
-- you can SET XACT_ABORT ON. 
-- This command is handy because it will roll back the transaction if an exception occurs.
-- By default, XACT_ABORT is off.

--Suppose you repeat the example from above by using an explicit transaction and XACT_ABORT.
-- The entire transaction will roll back after the first exception occurs, which is the expected result. 
-- In my opinion, this is the primary reason to use explicit transactions.

-- REPETIMOS EJEMPLO USANDO TRANSACCIONES EXPLICITAS

-- NOTA : EJECUTAR DESDE EL PRINCIPIO (DESDE GENERAR LAS TABLAS PARA TENET LOS MISMOS VALORES)
DROP TABLE IF EXISTS Checking
GO
CREATE TABLE dbo.Checking
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
DROP TABLE IF EXISTS Savings
GO
CREATE TABLE dbo.Savings
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
-- INSERTO EN MI CUENTA CORRIENTE

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 25.00, 'Starting my checking account', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 100.00, 'Starting my savings account, Thanks dad!', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total		AccountType
--100.00	Savings
--25.00		Checking

SET XACT_ABORT ON;

BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS INSERCIONES
INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(2, -100.00, 'Taking money out of my savings account.', GETDATE());

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(2, 100.00, 'Taking money out of my account for a copy of a new NES games, sorry dad! I will replace it after I get a job.', GETDATE());

COMMIT TRANSACTION;

-- (1 row affected)
--Msg 2628, Level 16, State 1, Line 132
--String or binary data would be truncated in table 'EXPLITRAN.dbo.Checking', column 'ShortDescription'. Truncated value: 'Taking money out of my account for a copy of a new NES games, sorry dad! I will replace it after I g'.

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total		AccountType
--100.00	Savings
--25.00		Checking

-- AL NO FUNCIONAR EL PRIMER INSERT LA TRANSACCIÓN (ATOMICITY) PROVOCA UN ROLLBACK.
-- VALOR EN LAS 2 TABLAS NO CAMBIA


--The money stays in my savings account until I shorten the message and make it to the store.

--------------------------
----------------------------
-- USANDO UPDATE

-- DESDE EL PRINCIPIO

DROP TABLE IF EXISTS Checking
GO
CREATE TABLE dbo.Checking
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
DROP TABLE IF EXISTS Savings
GO
CREATE TABLE dbo.Savings
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
-- INSERTO EN MI CUENTA CORRIENTE

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 25.00, 'Starting my checking account', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 100.00, 'Starting my savings account, Thanks dad!', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total		AccountType
--100.00	Savings
--25.00		Checking


-- TRANSACCIÓN IMPLICITA
SELECT *
FROM dbo.Savings
GO

--ID	Amount	ShortDescription						TransactionDate
--1		100.00	Starting my savings account, Thanks dad!	2023-09-26

SELECT *
FROM Checking
GO

--ID	Amount	ShortDescription			TransactionDate
--1		25.00	Starting my checking account	2023-09-26



-- EJECUTAR LOS 2 UPDATES JUNTOS

UPDATE Savings
SET  Amount=Amount-100,ShortDescription='Taking money out of my savings account.',
    TransactionDate = GETDATE()
WHERE ID = 1

-- ESTE UPDATE VA A FALLAR

UPDATE Checking
SET  Amount=Amount+100,ShortDescription='Taking money out of my account for a copy of a new NES games, 
								sorry dad! I will replace it after I get a job.',
    TransactionDate = GETDATE()
WHERE ID = 1

--(1 row affected)
--Msg 2628, Level 16, State 1, Line 440
--String or binary data would be truncated in table 'EXPLITRAN.dbo.Checking', column 'ShortDescription'. Truncated value: 'Taking money out of my account for a copy of a new NES games, 
--								sorry dad! I will replace it'.


-- COMPRUEBO
SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total	AccountType
--0.00	Savings
--25.00	Checking




-- TRANSACCIÓN EXPLICITA

SET XACT_ABORT ON;-- CONTROLAR EXCEPCIONES
BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS ACTUALIZACIONES
UPDATE Savings
SET  Amount=Amount-100,ShortDescription='Taking money out of my savings account.',
    TransactionDate = GETDATE()
WHERE ID = 1

-- ESTE UPDATE VA A FALLAR
UPDATE Checking
SET  Amount=Amount+100,ShortDescription='Taking money out of my account for a copy of a new NES games, 
								sorry dad! I will replace it after I get a job.',
    TransactionDate = GETDATE()
WHERE ID = 1
COMMIT TRAN

-- TAMBIEN DIO ERROR
--(1 row affected)
--Msg 2628, Level 16, State 1, Line 480
--String or binary data would be truncated in table 'EXPLITRAN.dbo.Checking', column 'ShortDescription'. Truncated value: 'Taking money out of my account for a copy of a new NES games, 
--								sorry dad! I will replace it'.

-- COMPRUEBO
SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total	AccountType
--100.00	Savings
--25.00	Checking


-- USANDO TRY - CATCH - THROW

-- DESDE EL PRINCIPIO

DROP TABLE IF EXISTS Checking
GO
CREATE TABLE dbo.Checking
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
DROP TABLE IF EXISTS Savings
GO
CREATE TABLE dbo.Savings
(
    ID INT NOT NULL,
    Amount DECIMAL(19, 2) NOT NULL,
    ShortDescription NVARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
-- INSERTO EN MI CUENTA CORRIENTE

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 25.00, 'Starting my checking account', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(1, 100.00, 'Starting my savings account, Thanks dad!', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

--Total		AccountType
--100.00	Savings
--25.00		Checking

BEGIN TRY  
BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS INSERCIONES
INSERT INTO dbo.Savings
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(2, -100.00, 'Taking money out of my savings account.', GETDATE());

INSERT INTO dbo.Checking
(
    ID,
    Amount,
    ShortDescription,
    TransactionDate
)
VALUES
(2, 100.00, 'Taking money out of my account for a copy of a new NES games, sorry dad! I will replace it after I get a job.', GETDATE());

COMMIT TRANSACTION; 
END TRY  
BEGIN CATCH  
    PRINT 'Truncated value:';  
    THROW;  
END CATCH;  
 GO 


--(1 row affected)

--(0 rows affected)
--Truncated value:
--Msg 2628, Level 16, State 1, Line 593
--String or binary data would be truncated in table 'EXPLITRAN.dbo.Checking', column 'ShortDescription'. Truncated value: 'Taking money out of my account for a copy of a new NES games, sorry dad! I will replace it after I g'.


-- COMPROBACIÓN

SELECT SUM(Amount) AS [Total], -- SELECT Statement
       'Savings' AS [AccountType]
FROM dbo.Savings
UNION ALL
SELECT SUM(Amount) AS [Total],
       'Checking' AS [AccountType]
FROM dbo.Checking;
GO

-- NO EJECUTA . ATOMICIDAD (TODAS O NINGUNA)

--Total	AccountType
--100.00	Savings
--25.00	   Checking
-- 1.	Create a Database
CREATE DATABASE Bank

USE Bank

-- 2.	Create Tables
CREATE TABLE Clients (
  Id INT PRIMARY KEY IDENTITY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL
)

CREATE TABLE AccountTypes (
  Id  INT PRIMARY KEY IDENTITY,
  Name VARCHAR(50) NOT NULL
)

CREATE TABLE Accounts (
  Id INT PRIMARY KEY IDENTITY,
  AccountTypeId INT FOREIGN KEY REFERENCES AccountTypes(Id),
  Balance DECIMAL(15, 2) NOT NULL DEFAULT(0),
  ClientId INT FOREIGN KEY REFERENCES Clients(Id)
)

-- 3.	Insert Sample Data into Database
INSERT INTO Clients (FirstName, LastName) VALUES
('Mena', 'Petkanova'),
('Sami', 'Petkanov'),
('Ico', 'Petkanov')

INSERT INTO AccountTypes (Name) VALUES
('Checking'),
('Savings')

SELECT * FROM  AccountTypes;

INSERT INTO Accounts (Accounts.ClientId, Accounts.AccountTypeId, Accounts.Balance) VALUES
(1, 1, 175),
(2, 1, 275.56),
(3, 1, 138.01),
(4, 1, 40.30),
(4, 2, 375.50)

SELECT * FROM  Accounts;

-- 4.	Create a Function
CREATE FUNCTION f_CalculateTotalBalance (@ClientId INT)
RETURNS DECIMAL(15, 2)
BEGIN
  DECLARE @result AS DECIMAL(15, 2) = (
    SELECT SUM(Balance)
    FROM Accounts WHERE ClientId = @ClientID
  )
  RETURN @result
END

-- Notice the dbo. before the function name – this is the name of the schema which we must type when calling functions.
SELECT dbo.f_CalculateTotalBalance(4) AS Balance

-- 5.	Create Procedures
CREATE PROC p_AddAccount @ClientId INT, @AccountTypeId INT AS
INSERT INTO Accounts (ClientId, AccountTypeId)
VALUES (@ClientId, @AccountTypeId)

EXEC p_AddAccount 2, 2

SELECT * FROM Accounts

CREATE PROC p_Deposit @AccountId INT, @Amount DECIMAL(15, 2) AS
UPDATE Accounts
SET Balance += @Amount
WHERE Id = @AccountId

EXEC p_Deposit 14, 40

SELECT * FROM Accounts

CREATE PROC p_Withdraw @AccountId INT, @Amount DECIMAL(15, 2) AS
BEGIN
	DECLARE @OldBalance DECIMAL(15, 2)
	SELECT @OldBalance = Balance FROM Accounts WHERE Id = @AccountId
	IF (@OldBalance - @Amount >= 0)
	BEGIN
		UPDATE Accounts
		SET Balance -= @Amount
		WHERE Id = @AccountId
	END
	ELSE
	BEGIN
		RAISERROR('Insufficient funds', 10, 1)
	END
END

EXEC p_Withdraw 14, 80

SELECT * FROM Accounts

-- 6.	Create Transactions Table and a Trigger
CREATE TABLE Transactions (
  Id INT PRIMARY KEY IDENTITY,
  AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
  OldBalance DECIMAL(15, 2) NOT NULL,
  NewBalance DECIMAL(15, 2) NOT NULL,
  Amount AS NewBalance - OldBalance,
  DateTime DATETIME2
)

CREATE TRIGGER tr_Transaction ON Accounts
AFTER UPDATE
AS
  INSERT INTO Transactions (AccountId, OldBalance, NewBalance, DateTime)
  SELECT inserted.Id, deleted.Balance, inserted.Balance, GETDATE() FROM inserted
  JOIN deleted ON inserted.Id = deleted.Id

EXEC p_Deposit 14, 100.00
GO

EXEC p_Deposit 16, 130.00
GO

EXEC p_Withdraw 14, 300.00
GO

EXEC p_Deposit 17, 231.00
GO

SELECT * FROM Transactions


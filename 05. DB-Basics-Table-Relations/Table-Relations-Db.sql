-- Exercises: Table Relations

CREATE DATABASE TableRelations
GO

USE TableRelations
GO

-- Problem 1.	One-To-One Relationship

CREATE TABLE Persons (
  PersonID INT IDENTITY(1, 1) NOT NULL,
  FirstName NVARCHAR(32) NOT NULL,
  Salary DECIMAL(15) NOT NULL,
  PassportID INT NOT NULL
)
GO

CREATE TABLE Passports (
  PassportID INT IDENTITY(101, 1) NOT NULL,
  PassportNumber NVARCHAR(32) NOT NULL

  CONSTRAINT UQ_Passports_PassportNumber
    UNIQUE (PassportNumber)
)
GO

INSERT INTO Persons
    VALUES
      ('Roberto', 43300.00, 102),
      ('Tom', 56100.00, 103),
      ('Yana', 60200.00, 101)
GO

INSERT INTO Passports
    VALUES
      ('N34FG21B'),
      ('K65LO4R7'),
      ('ZE657QP2')
GO

SELECT * FROM Persons
GO

SELECT * FROM Passports
GO

ALTER TABLE Persons
    ADD
      CONSTRAINT PK_Persons_PersonID
      PRIMARY KEY (PersonID)
GO

ALTER TABLE Passports
    ADD
      CONSTRAINT FK_PassportID_PersonID
      FOREIGN KEY (PassportID)
        REFERENCES Persons(PersonID)
GO



-- Exercises: Table Relations

CREATE DATABASE TableRelations
GO

USE TableRelations
GO

-- Problem 1.	One-To-One Relationship

CREATE TABLE Persons (
  PersonID INT IDENTITY(1, 1) NOT NULL,
  FirstName NVARCHAR(32) NOT NULL,
  Salary DECIMAL(15, 2) NOT NULL,
  PassportID INT NOT NULL
)

CREATE TABLE Passports (
  PassportID INT IDENTITY(101, 1) NOT NULL,
  PassportNumber NVARCHAR(32) NOT NULL,

  CONSTRAINT UQ_Passports_PassportNumber
  UNIQUE (PassportNumber)
)

INSERT INTO Persons
    VALUES
      ('Roberto', 43300.00, 102),
      ('Tom', 56100.00, 103),
      ('Yana', 60200.00, 101)

INSERT INTO Passports
    VALUES
      ('N34FG21B'),
      ('K65LO4R7'),
      ('ZE657QP2')

ALTER TABLE Persons
    ADD CONSTRAINT PK_Persons_PersonID
    PRIMARY KEY (PersonID)

ALTER TABLE Passports
    ADD CONSTRAINT PK_Passports_PassportID
    PRIMARY KEY (PassportID)

ALTER TABLE Persons
    ADD CONSTRAINT FK_Passports_Persons
    FOREIGN KEY (PassportID)
    REFERENCES Passports(PassportID)


-- Problem 2.	One-To-Many Relationship

CREATE TABLE Manufacturers (
  ManufacturerID INT IDENTITY NOT NULL,
  Name NVARCHAR(32) NOT NULL,
  EstablishedOn DATE NOT NULL
)

CREATE TABLE Models (
  ModelID INT IDENTITY(100, 1) NOT NULL,
  Name NVARCHAR(32) NOT NULL,
  ManufacturerID INT NOT NULL
)

INSERT INTO Manufacturers
    VALUES
      ('BMW', '07/03/1916'),
      ('Tesla', '01/01/2003'),
      ('Lada', '01/05/1966')

INSERT INTO Models
    VALUES
      ('X1', 1),
      ('i6', 1),
      ('Model S', 2),
      ('Model X', 2),
      ('Model 3', 2),
      ('Nova', 3)

ALTER TABLE Manufacturers
    ADD CONSTRAINT PK_Manufacturers_ManufacturerID
    PRIMARY KEY (ManufacturerID)

ALTER TABLE Models
    ADD
      CONSTRAINT PK_Models_ModelID
      PRIMARY KEY (ModelID),

      CONSTRAINT FK_Models_Manufacturers
      FOREIGN KEY (ManufacturerID)
      REFERENCES Manufacturers(ManufacturerID)


-- Problem 3.	Many-To-Many Relationship

CREATE TABLE Students (
  StudentID INT IDENTITY NOT NULL,
  Name NVARCHAR(64) NOT NULL
)

CREATE TABLE Exams (
  ExamID INT IDENTITY(101, 1) NOT NULL,
  Name NVARCHAR(64) NOT NULL
)

INSERT INTO Students
    VALUES
      ('Mila'),
      ('Toni'),
      ('Ron')

INSERT INTO Exams
    VALUES
      ('SpringMVC'),
      ('Neo4j'),
      ('Oracle 11g')

ALTER TABLE Students
    ADD CONSTRAINT PK_Students_StudentID
    PRIMARY KEY (StudentID)

ALTER TABLE Exams
    ADD CONSTRAINT PK_Exams_ExamID
    PRIMARY KEY (ExamID)

CREATE TABLE StudentsExams (
  StudentID INT NOT NULL,
  ExamID INT NOT NULL,

  CONSTRAINT FK_StudentsExams_StudentID
  FOREIGN KEY (StudentID)
  REFERENCES Students(StudentID),

  CONSTRAINT FK_StudentsExams_ExamID
  FOREIGN KEY (ExamID)
  REFERENCES Exams(ExamID),

  CONSTRAINT PK_StudentID_ExamID
  PRIMARY KEY (StudentID, ExamID)
)

INSERT INTO StudentsExams
    VALUES
      (1, 101),
      (1, 102),
      (2, 101),
      (3, 103),
      (2, 102),
      (2, 103)


-- Problem 4.	Self-Referencing

CREATE TABLE Teachers (
  TeacherID INT IDENTITY(101, 1) NOT NULL,
  Name NVARCHAR(64) NOT NULL,
  ManagerID INT
)

INSERT INTO Teachers
    VALUES
      ('John', NULL ),
      ('Maya', 106),
      ('Silvia', 106),
      ('Ted', 105),
      ('Mark', 101),
      ('Greta', 101)

ALTER TABLE Teachers
    ADD CONSTRAINT PK_Teachers_TeacherID
    PRIMARY KEY (TeacherID)

ALTER TABLE Teachers
    ADD CONSTRAINT FK_TeacherID_ManagerID
    FOREIGN KEY (ManagerID)
    REFERENCES Teachers(TeacherID)


-- Problem 5.	Online Store Database

CREATE TABLE Cities (
  CityID INT IDENTITY NOT NULL,
  Name NVARCHAR(50) NOT NULL,

  CONSTRAINT PK_Cities_CityID
  PRIMARY KEY (CityID)
)

CREATE TABLE Customers (
  CustomerID INT IDENTITY NOT NULL,
  Name NVARCHAR(50) NOT NULL,
  Birthday DATE NOT NULL,
  CityID INT NOT NULL,

  CONSTRAINT PK_Customers_CustomerID
  PRIMARY KEY (CustomerID),

  CONSTRAINT FK_Customers_Cities
  FOREIGN KEY (CityID)
  REFERENCES Cities(CityID)
)

CREATE TABLE Orders (
  OrderID INT IDENTITY NOT NULL,
  CustomerID INT NOT NULL,

  CONSTRAINT PK_Orders_OrderID
  PRIMARY KEY (OrderID),

  CONSTRAINT FK_Orders_Customers
  FOREIGN KEY (CustomerID)
  REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes (
  ItemTypeID INT IDENTITY NOT NULL,
  Name NVARCHAR(50) NOT NULL,

  CONSTRAINT PK_ItemTypes_ItemTypeID
  PRIMARY KEY (ItemTypeID)
)

CREATE TABLE Items (
  ItemID INT IDENTITY NOT NULL,
  Name NVARCHAR(50) NOT NULL,
  ItemTypeID INT NOT NULL,

  CONSTRAINT PK_Items_ItemID
  PRIMARY KEY (ItemID),

  CONSTRAINT FK_Items_ItemTypes_ItemTypeID
  FOREIGN KEY (ItemTypeID)
  REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems (
  OrderID INT NOT NULL,
  ItemID INT NOT NULL,

  CONSTRAINT FK_OrderItems_ItemID
  FOREIGN KEY (ItemID)
  REFERENCES Items(ItemID),

  CONSTRAINT FK_OrderItems_OrderID
  FOREIGN KEY (OrderID)
  REFERENCES Orders(OrderID),

  CONSTRAINT PK_ItemID_OrderID
  PRIMARY KEY (OrderID, ItemID)
)


-- Problem 6.	University Database

CREATE TABLE Majors (
  MajorID INT IDENTITY NOT NULL,
  Name NVARCHAR(32) NOT NULL,

  CONSTRAINT PK_Majors_MajorID
  PRIMARY KEY (MajorID)
)

CREATE TABLE Students (
  StudentID INT IDENTITY NOT NULL,
  StudentNumber NVARCHAR(32) NOT NULL,
  StudentName NVARCHAR(32) NOT NULL,
  MajorID INT NOT NULL,

  CONSTRAINT PK_Students_StudentID
  PRIMARY KEY (StudentID),

  CONSTRAINT FK_Students_Majors
  FOREIGN KEY (MajorID)
  REFERENCES Majors(MajorID)
)

CREATE TABLE Payments (
  PaymentID INT IDENTITY NOT NULL,
  PaymentDate DATETIME2 NOT NULL,
  PaymentAmount DECIMAL(15, 2) NOT NULL,
  StudentID INT NOT NULL,

  CONSTRAINT PK_Payments_PaymentID
  PRIMARY KEY (PaymentID),

  CONSTRAINT FK_Payments_Students
  FOREIGN KEY (StudentID)
  REFERENCES Students(StudentID)
)

CREATE TABLE Subjects (
  SubjectID INT IDENTITY NOT NULL,
  SubjectName NVARCHAR(32) NOT NULL,

  CONSTRAINT PK_Subjects_SubjectID
  PRIMARY KEY (SubjectID)
)

CREATE TABLE Agenda (
  StudentID INT NOT NULL,
  SubjectID INT NOT NULL,

  CONSTRAINT PK_Agenda
  PRIMARY KEY (StudentID, SubjectID),

  CONSTRAINT FK_Agenda_Students
  FOREIGN KEY (StudentID)
  REFERENCES Students(StudentID),

  CONSTRAINT FK_Agenda_Subjects
  FOREIGN KEY (SubjectID)
  REFERENCES Subjects(SubjectID)
)


-- Problem 9.	*Peaks in Rila

USE Geography

SELECT MountainRange, PeakName, Elevation
FROM Mountains AS m
JOIN Peaks p
ON m.Id = P.MountainId
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC
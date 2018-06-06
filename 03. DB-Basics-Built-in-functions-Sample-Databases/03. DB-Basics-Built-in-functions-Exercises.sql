-- Part I – Queries for SoftUni Database
USE SoftUni

-- Problem 1.	Find Names of All Employees by First Name
SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'SA%'

-- Problem 2.	  Find Names of All employees by Last Name
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%EI%'

-- Problem 3.	Find First Names of All Employees
SELECT *
FROM Employees
WHERE DepartmentID = 3 OR DepartmentID = 10
AND HireDate BETWEEN 1995 AND 2005
ORDER BY HireDate DESC

-- Problem 4.	Find All Employees Except Engineers
SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

-- Problem 5.	Find Towns with Name Length
SELECT Name
FROM Towns
WHERE LEN(Name) = 5 OR LEN(Name) = 6
-- Same result: WHERE LEN(Name) IN (5, 6)
-- Same result: WHERE LEN(Name) BETWEEN 5 AND 6
ORDER BY Name

-- Problem 6. Find Towns Starting With
SELECT *
FROM Towns
WHERE Name LIKE 'M%'
  OR Name LIKE 'K%'
  OR Name LIKE 'B%'
  OR Name LIKE 'E%'
ORDER BY Name

-- Problem 7.	 Find Towns Not Starting With
SELECT *
FROM Towns
WHERE Name NOT LIKE 'R%'
  AND Name NOT LIKE 'B%'
  AND Name NOT LIKE 'D%'
ORDER BY Name

-- Problem 8.	Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) > 2000

SELECT * FROM V_EmployeesHiredAfter2000

-- Problem 9.	Length of Last Name
SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5


-- Part II – Queries for Geography Database
USE Geography

-- Problem 10.	Countries Holding ‘A’ 3 or More Times
SELECT CountryName, IsoCode
FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

-- Problem 11.	Mix of Peak and River Names
SELECT PeakName, RiverName,
  LOWER(CONCAT(PeakName, RIGHT(RiverName, LEN(RiverName) - 1))) AS Mix
FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

-- Part III – Queries for Diablo Database
USE Diablo

-- Problem 12.	Games from 2011 and 2012 year
SELECT TOP(50) Name, FORMAT(Start, 'yyyy-MM-dd') AS Start
FROM Games
WHERE YEAR(Start) IN (2011, 2012)
ORDER BY Start, Name

-- Problem 13.	 User Email Providers
SELECT Username, RIGHT(Email, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider]
FROM Users
ORDER BY [Email Provider], Username

-- Problem 14.	 Get Users with IPAdress Like Pattern
SELECT Username, IpAddress AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- Problem 15.	 Show All Games with Duration and Part of the Day
SELECT Name AS "Game",
    "Part of the Day" =
    CASE
      WHEN DATEPART(HH, Start) >= 0 AND DATEPART(HH, Start) < 12 THEN 'Morning'
      WHEN DATEPART(HH, Start) >= 12 AND DATEPART(HH, Start) < 18 THEN 'Afternoon'
      WHEN DATEPART(HH, Start) >= 18 AND DATEPART(HH, Start) < 24 THEN 'Evening'
    END,
    "Duration" =
    CASE
      WHEN Duration <= 3 THEN 'Extra Short'
      WHEN Duration > 3 AND Duration <= 6 THEN 'Short'
      WHEN Duration > 6 THEN 'Long'
      WHEN Duration IS NULL THEN 'Extra Long'
      ELSE 'Invalid duration'
    END
FROM Games
ORDER BY Name, Duration


-- Part IV – Date Functions Queries
USE Orders

-- Problem 16.	 Orders Table
SELECT ProductName, OrderDate,
  "Pay Due" = DATEADD(DAY, 3, OrderDate),
  "Deliver Due" =  DATEADD(MONTH, 1, OrderDate)
FROM Orders


-- Part V

-- Problem 17.  People Table
CREATE TABLE "People" (
  Id INT IDENTITY,
  [Name] VARCHAR(50),
  Birthdate DATETIME
)

INSERT INTO "People" (Name, Birthdate) VALUES
  ('Milena Petkanova', '1991-05-08 09:45:00'),
  ('Samuil Petkanov', '1990-04-25 00:00:00'),
  ('Hristo Petkanov', '2016-02-03 23:45:00')

CREATE VIEW V_PeopleBirthdateInfo AS
SELECT Name,
  "Age in Yaers" = DATEDIFF(YEAR, Birthdate, GETDATE()),
  "Age in Months" = DATEDIFF(MONTH, Birthdate, GETDATE()),
  "Age in Days" = DATEDIFF(DAY, Birthdate, GETDATE()),
  "Age in Minutes" = DATEDIFF(MINUTE, Birthdate, GETDATE())
FROM People

SELECT *
FROM V_PeopleBirthdateInfo



-- Exercises: Joins, Subqueries, CTE and Indices

-- Problem 1.	Employee Address
USE SoftUni

SELECT TOP (5) e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText
      FROM Employees AS e
INNER JOIN Addresses AS a
        ON e.AddressID = A.AddressID
  ORDER BY e.AddressID

-- Problem 2.	Addresses with Towns
SELECT top (50) e.FirstName, e.LastName, t.Name, a.AddressText
FROM Employees AS e
INNER JOIN Addresses AS a
  ON e.AddressID = a.AddressID
INNER JOIN Towns AS t
  ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

-- Problem 3.	Sales Employee
SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name
FROM Employees AS e
INNER JOIN Departments AS d
  ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY e.EmployeeID

-- Problem 4.	Employee Departments
SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name
FROM Employees AS e
INNER JOIN Departments AS d
  ON e.DepartmentID = d.DepartmentID
     AND e.Salary > 15000
ORDER BY e.DepartmentID

-- Problem 5.  Employee Without Project
SELECT TOP (3) e.EmployeeID, e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects as ep
  ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
GROUP BY e.EmployeeID, e.FirstName
ORDER BY e.EmployeeID

-- Problem 6.	Employees Hired After
SELECT e.FirstName, e.LastName, e.HireDate, d.Name
FROM Employees AS e
INNER JOIN Departments AS d
  ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > 01/01/1999
AND d.Name IN ('Sales', 'Finance')
ORDER BY e.HireDate

-- Problem 7.	Employees with Project
SELECT TOP (5) e.EmployeeID, e.FirstName, p.Name
FROM Employees AS e
INNER JOIN EmployeesProjects AS ep
  ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects AS p
  ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > 13/08/2002
  AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-- Problem 8.	Employee 24
SELECT e.EmployeeID,
       e.FirstName,
       "ProjectName" =
          CASE
            WHEN p.StartDate > '01/01/2005' THEN NULL
            ELSE p.Name
          END
FROM Employees AS e
INNER JOIN EmployeesProjects AS ep
  ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects AS p
  ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

-- Problem 9.	Employee Manager
    SELECT e.EmployeeID,
           e.FirstName,
           e.ManagerID,
           m.FirstName AS ManagerName
      FROM Employees AS e
INNER JOIN Employees AS m
  ON e.EmployeeID = m.ManagerID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

SELECT e.EmployeeID,
       e.FirstName,
       m.EmployeeID AS ManagerID,
       m.FirstName AS ManagerName
FROM Employees AS e
  INNER JOIN Employees AS m
    ON e.ManagerID = m.EmployeeID
WHERE m.EmployeeID IN (3, 7)
ORDER BY e.EmployeeID

-- Problem 10.	Employee Summary
SELECT TOP (50) e.EmployeeID,
       e.FirstName + ' ' + e.LastName AS EmployeeName,
       m.FirstName + ' ' + m.LastName AS ManagerName,
       d.Name AS DepartmentName
FROM Employees AS e
INNER JOIN Employees AS m
  ON e.ManagerID = m.EmployeeID
INNER JOIN Departments AS d
  ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- Problem 11.	Min Average Salary
SELECT MIN(AverageSalary) AS MinAverageSalary
  FROM (
    SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM Employees
    GROUP BY DepartmentID
  ) AS a

-- Problem 12.	Highest Peaks in Bulgaria
USE Geography

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM MountainsCountries AS mc
  INNER JOIN Mountains AS m
    ON mc.MountainId = m.Id
  INNER JOIN Peaks p
    ON m.Id = p.MountainId
WHERE p.Elevation > 2835
  AND mc.CountryCode = 'BG'
ORDER BY p.Elevation DESC

-- Problem 13.	Count Mountain Ranges
SELECT mc.CountryCode, COUNT(*) AS MountainRanges
FROM MountainsCountries AS mc
WHERE mc.CountryCode IN ('BG', 'US', 'RU')
GROUP BY mc.CountryCode

-- Problem 14.	Countries with Rivers
SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
  ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers r
  ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

-- Problem 15.  Continents and Currencies
WITH CTI_CountriesInfo (ContinentCode, CurrencyCode, CurrencyUsage) AS (
SELECT ContinentCode, CurrencyCode, COUNT(CountryCode)
FROM Countries AS c1
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(CurrencyCode) > 1
)

SELECT e.ContinentCode, cci.CurrencyCode, e.MaxCurrency AS CurrencyUsage
FROM (
  SELECT ContinentCode, MAX(CurrencyUsage) AS MaxCurrency
  FROM CTI_CountriesInfo
  GROUP BY ContinentCode ) AS e
JOIN CTI_CountriesInfo AS cci
    ON cci.ContinentCode = e.ContinentCode
    AND cci.CurrencyUsage = e.MaxCurrency

-- Problem 16.	Countries without any Mountains
SELECT COUNT(*) AS CountryCode
FROM Countries AS c
LEFT JOIN MountainsCountries AS cm
  ON c.CountryCode = cm.CountryCode
WHERE cm.CountryCode IS NULL

-- Problem 17.	Highest Peak and Longest River by Country
SELECT TOP (5) c.CountryName,
       MAX(p.Elevation) AS HighestPeakElevation,
       MAX(r.Length) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN MountainsCountries AS cm
  ON c.CountryCode = cm.CountryCode
LEFT JOIN Peaks AS p
  ON cm.MountainId = p.MountainId
LEFT JOIN CountriesRivers AS cr
  ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
  ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC,
         LongestRiverLength DESC,
         CountryName

-- Problem 18.  Highest Peak Name and Elevation by Country
WITH CTE_CountriesInfo (CountryName, PeakName, Elevation, Mountain) AS (
SELECT c.CountryName, p.PeakName, MAX(p.Elevation), m.MountainRange
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
  ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
  ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p
  ON m.Id = p.MountainId
GROUP BY c.CountryName, p.PeakName, m.MountainRange )

SELECT TOP (5) e.CountryName,
  ISNULL(cci.PeakName, '(no highest peak)'),
  ISNULL(cci.Elevation, '0'),
  ISNULL(cci.Mountain, '(no mountain)')
FROM (
SELECT CountryName, MAX(Elevation) AS MaxElevation
FROM CTE_CountriesInfo
GROUP BY CountryName ) AS e
LEFT JOIN CTE_CountriesInfo AS cci
  ON cci.CountryName = e.CountryName
  AND cci.Elevation = e.MaxElevation
ORDER BY e.CountryName, cci.PeakName
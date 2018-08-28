-- 02. Insert

INSERT INTO Employees(FirstName, LastName, Gender, BirthDate, DepartmentId) VALUES
  ('Marlo', 'O’Malley', 'M', '09/21/1958', 1),
  ('Niki', 'Stanaghan', 'F', '11/26/1969', 4),
  ('Ayrton', 'Senna', 'M', '03/21/1960', 9),
  ('Ronnie', 'Peterson', 'M', '02/14/1944', 9),
  ('Giovanna', 'Amati', 'F', '07/20/1959', 5);

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, Description, UserId, EmployeeId) VALUES
  (1, 1, '04/13/2017', NULL, 'Stuck Road on Str.133', 6, 2),
  (6, 3, '09/05/2015', '12/06/2015', 'Charity trail running', 3, 5),
  (14, 2, '09/07/2015', NULL, 'Falling bricks on Str.58', 5, 2),
  (4, 3, '07/03/2017', '07/06/2017', 'Cut off streetlight on Str.11', 1, 1);


-- 03. Update

UPDATE dbo.Reports
    SET StatusId = 2
WHERE StatusId = 1 AND CategoryId = 4


-- 04. Delete

DELETE FROM Reports
WHERE StatusId = 4


-- 05. Users by Age

SELECT Username, Age
FROM Users
ORDER BY Age, Username DESC


-- 06. Unassigned Reports

SELECT Description, OpenDate
FROM Reports
WHERE EmployeeId IS NULL
ORDER BY OpenDate, Description


-- 07. Employees & Reports
SELECT * FROM Reports
SELECT e.FirstName, e.LastName, r.[Description], r.OpenDate
FROM Employees AS e
JOIN Reports AS r
    ON r.Id = e.Id
WHERE r.EmployeeId IS NULL
ORDER BY e.Id, r.OpenDate, r.Id


SELECT e.FirstName,
       e.LastName,
       r.[Description],
       FORMAT(r.OpenDate, 'yyyy-MM-dd') AS OpenDate
FROM Employees AS e
JOIN Reports AS r ON r.EmployeeId = e.Id
ORDER BY e.Id, r.OpenDate, r.Id


-- 08.  Most Reported Category
SELECT c.Name AS CategoryName,
       COUNT(r.CategoryId) AS ReportsNumber
FROM Categories AS c
JOIN Reports AS r ON c.Id = r.CategoryId
GROUP BY c.Name
ORDER BY COUNT(r.CategoryId) DESC, c.Name


-- 9.	Employees in Category
SELECT c.Name AS CategoryName,
       COUNT(*) AS [Employees Number]
FROM Reports AS r
JOIN Categories AS c ON c.Id = r.CategoryId
GROUP BY c.Name
ORDER BY c.Name

SELECT * FROM Categories
ORDER BY Name

SELECT *
FROM Employees AS e
  JOIN Departments d ON e.DepartmentId = d.Id
  -- JOIN Categories c ON d.Id = c.DepartmentId
  ORDER BY e.DepartmentId
--FROM Categories AS c
--LEFT JOIN Reports AS r ON c.Id = r.CategoryId


-- 10.	Users per Employee

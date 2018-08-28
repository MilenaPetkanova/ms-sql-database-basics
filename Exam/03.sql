-- 05. Bulgarian Cities
SELECT Id, Name
FROM Cities
WHERE CountryCode = 'BG'
ORDER BY Name


-- 06. People Born After 1991
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS [Full Name],
  YEAR(BirthDate) AS BirthYear
FROM Accounts
WHERE YEAR(BirthDate) > 1991
ORDER BY BirthYear DESC, FirstName


-- 7. EEE-Mails
SELECT a.FirstName, a.LastName,
  FORMAT(BirthDate, 'MM-dd-yyyy') AS BirthDate,
  C.Name AS Hometown,
  a.Email
FROM Accounts AS a
JOIN Cities C ON a.CityId = C.Id
WHERE a.Email LIKE 'e%'
ORDER BY C.Name DESC


-- 08. City Statistics
SELECT c.Name AS City, COUNT(h.Id) AS Hotels
FROM Cities AS c
LEFT JOIN Hotels h ON c.Id = h.CityId
GROUP BY c.Name
ORDER BY Hotels DESC, City


-- 09. Expensive First Class Rooms
SELECT r.Id, r.Price, h.Name, c.Name
FROM Rooms AS r
JOIN Hotels h ON r.HotelId = h.Id
JOIN Cities c ON h.CityId = c.Id
WHERE r.Type = 'First Class'
ORDER BY r.Price DESC, r.Id


-- 10. Longest and Shortest Trips
SELECT e.AccoundId,
      e.FullName,
      MAX(e.TripLen) AS LongestTrip,
      MIN(e.TripLen) AS LongestTrip
FROM (
    SELECT a.Id AS AccoundId,
      a.FirstName + ' ' + a.LastName AS FullName,
      DATEDIFF(DAY, ArrivalDate, ReturnDate) AS TripLen,
    t.CancelDate
    FROM Accounts AS a
    JOIN AccountsTrips AS at ON a.Id = at.AccountId
    JOIN Trips t ON at.TripId = t.Id
    WHERE a.MiddleName IS NULL AND t.CancelDate IS NULL
) AS e
GROUP BY e.AccoundId, e.FullName
ORDER BY MAX(e.TripLen) DESC , AccoundId


-- 11. Metropolis
SELECT TOP (5) c.Id, c.Name AS City, c.CountryCode, Accounts
FROM Cities AS c
JOIN ( SELECT
        CityId AS CityId,
        COUNT(*) AS Accounts
        FROM Accounts AS a
        GROUP BY CityId
     ) AS sub
  ON c.Id = CityId
ORDER BY Accounts DESC


-- 12. Romantic Getaways
SELECT a.Id,
  a.Email,
  c.Name AS City,
  COUNT(*) AS Trips
FROM Accounts AS a
JOIN AccountsTrips AT2 ON a.Id = AT2.AccountId
JOIN Trips T ON AT2.TripId = T.Id
JOIN Rooms R ON T.RoomId = R.Id
JOIN Hotels H ON R.HotelId = H.Id
JOIN Cities C ON a.CityId = C.Id

WHERE a.CityId = h.CityId
GROUP BY a.Id, a.Email, a.CityId, c.Name
ORDER BY Trips DESC, a.Id

-- 15. Top Travelers
SELECT *
FROM Cities AS c
JOIN (
  SELECT a.Id, a.Email, COUNT(*) AS Trips
  FROM Accounts AS a
  JOIN Cities ON a.CityId = Cities.Id
  JOIN AccountsTrips AT2 ON a.Id = AT2.AccountId
  GROUP BY a.Id, a.Email
    ) AS sub
  ON c.Id =


-- 13. Lucrative Destinations
SELECT c.Id, c.Name
FROM Cities AS c
JOIN Hotels H ON c.Id = H.CityId
JOIN Rooms R ON H.Id = R.HotelId
GROUP BY c.Id, c.Name


-- 20. Cancel Trip
CREATE TRIGGER tr_CancelTrip
ON Trips
AFTER DELETE
AS
BEGIN
  IF (deleted.CancelDate IS NULL )

      UPDATE deleted
      SET CancelDate = GETDATE()
      WHERE deleted.CancelDate IS NOT NULL
    END



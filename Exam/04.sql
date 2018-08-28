-- Section 4. Programmability (14 pts)

-- 18. Available Room
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @roomType VARCHAR(50)
  DECLARE @roomId INT;
  DECLARE @roomBeds INT;
  DECLARE @roomPrice DECIMAL(15, 2)

  SELECT @roomId = RoomId,
        @roomType = RoomType,
        @roomPrice = TotalPrice,
        @roomBeds = RoomBeds
  FROM (
      SELECT TOP (1) r.Id AS RoomId,
        r.Type AS RoomType,
        (h.BaseRate + r.Price) * 2 AS TotalPrice,
        r.Beds AS RoomBeds
      FROM Hotels AS h
      RIGHT JOIN Rooms AS r ON h.Id = r.HotelId
      LEFT JOIN Trips t ON r.Id = t.RoomId
      WHERE ((@Date < ArrivalDate OR @Date > ReturnDate) AND CancelDate IS NULL)
            AND h.Id = @HotelId
            AND r.Beds >= @People
      ORDER BY TotalPrice DESC
  ) AS e

  IF (@roomId IS NULL)
    BEGIN
      RETURN  'No rooms available'
    END

  RETURN 'Room ' + CAST(@roomId AS VARCHAR) + ': '
         + CAST(@roomType AS VARCHAR) + ' ('
         + CAST(@roomBeds AS VARCHAR) + ' beds) - $'
         + CAST(@roomPrice AS VARCHAR)
END

SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)
SELECT dbo.udf_GetAvailableRoom(6, '2012-11-01', 2)
DROP FUNCTION udf_GetAvailableRoom

-- 19. Switch Room

USE Chinook 
IF OBJECT_ID('Track_v_ae')IS NOT NULL DROP VIEW Track_v_ae
IF OBJECT_ID('ArtistAlbum_fn_ae')IS NOT NULL DROP FUNCTION ArtistAlbum_fn_ae
IF OBJECT_ID('TracksByArtist_p_ae')IS NOT NULL DROP PROC TracksByArtist_p_ae

--1

GO

CREATE VIEW Track_v_ae AS
SELECT T.*
,G.Name AS GenreName
,MT.Name AS MediaTypeName
FROM Track T
JOIN Genre G
	ON T.GenreId = G.GenreId
JOIN MediaType MT
	ON T.MediaTypeId = MT.MediaTypeId

--2
GO

CREATE FUNCTION ArtistAlbum_fn_ae (@TrackId int)--DECLARE Column
RETURNS varchar(100)--DATA TYPE
AS
BEGIN--BEGIN Statement
DECLARE @ArtistAlbum varchar(100)--DECLARE Variable
SELECT
    @ArtistAlbum = CONCAT(Artist.Name,'-',Album.Title)--Select Variable
FROM Track
JOIN Album
    ON Track.AlbumId = Album.AlbumId
JOIN Artist
    ON Album.ArtistId = Artist.ArtistId
WHERE Track.TrackId = @TrackId
RETURN @ArtistAlbum--Variable
END--END Statement

--3
GO

CREATE PROC TracksByArtist_p_ae  
	@ArtistName varchar (100)--input PARAMETER
AS
SELECT Ar.Name AS ArtistName
,ISNULL(Al.Title,'unknown') AS AlbumTitle
,ISNULL(T.Name, 'unknown') AS TrackName
FROM Artist Ar
FULL JOIN Album Al
	ON Ar.ArtistId = Al.ArtistId
FULL JOIN Track T
	ON Al.AlbumId = T.AlbumId
WHERE Ar.Name LIKE CONCAT('%',@ArtistName,'%')--allowing for wildcard PARAMETER query

--4
GO

SELECT Name
,GenreName
,MediaTypeName
,Al.Title
FROM Track_v_ae Tv
JOIN Album Al
	ON Tv.AlbumId = Al.AlbumId
WHERE Name = 'Babylon'

--5
GO

SELECT 
dbo.ArtistAlbum_fn_ae(TrackId) AS 'Artist and Album'
,Name AS TrackName
FROM Track_v_ae
WHERE GenreName = 'opera'

--6
GO

EXEC TracksByArtist_p_ae 'black'--input wildcard parameter

GO

EXEC TracksByArtist_p_ae 'white'--input wildcard parameter

--7
GO 

ALTER  PROC TracksByArtist_p_ae  
	@ArtistName varchar (100) = 'scorpions'
AS
SELECT Ar.Name AS ArtistName
,Al.Title AS AlbumTitle
,T.Name AS TrackName
FROM Artist Ar
FULL JOIN Album Al
	ON Ar.ArtistId = Al.ArtistId
FULL JOIN Track T
	ON Al.AlbumId = T.AlbumId
WHERE Ar.Name LIKE CONCAT('%',@ArtistName,'%')

--8
GO

EXEC TracksByArtist_p_ae

--9
GO

BEGIN TRANSACTION
UPDATE Employee
SET LastName = 'Emdur'
WHERE EmployeeId = 1

--10
SELECT EmployeeId
,LastName
FROM Employee
WHERE EmployeeId =1


GO

ROLLBACK TRANSACTION

SELECT EmployeeId
,LastName
FROM Employee
WHERE EmployeeId =1
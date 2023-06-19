--All songs on playlist
SELECT * FROM dbo.playlist;

--Length of the playlist in hours
SELECT (SUM(time)/60)/60 AS HoursLong 
FROM dbo.playlist;

--All songs that are remixes
SELECT * FROM dbo.playlist 
WHERE song LIKE '%Remix%';

--Songs that are not collabs
SELECT * FROM dbo.playlist 
WHERE artist NOT LIKE '%,%' AND artist NOT LIKE '%&%';

--Songs and artists ordered by genre
SELECT song, artist, genre 
FROM dbo.playlist
ORDER BY genre

--Songs that are the first track in their album
SELECT song, artist, album, track_number 
FROM dbo.playlist
WHERE Track_Number = 1
AND album NOT LIKE '%single%' 
AND album NOT LIKE '% EP%'
AND album NOT LIKE '%feat.%'

--number of songs added in 2018
SELECT COUNT(*) 
FROM dbo.playlist 
WHERE YEAR(Date_Added) = 2018

--Songs that were added before the year 2020
SELECT * FROM dbo.playlist
WHERE YEAR(Date_Added) < 2020
ORDER BY Date_Added, Time_Added

--Songs that were added in the years 2021 and 2022
SELECT * FROM dbo.playlist
WHERE YEAR(Date_Added) BETWEEN 2021 AND 2022
ORDER BY Date_Added, Time_Added

--Average song length in munutes grouped by the year added to playlist
SELECT ROUND(AVG(time)/60, 3) AS SongLengthInMinutes, YEAR(Date_Added) 
FROM dbo.playlist
GROUP BY YEAR(Date_Added)
ORDER BY YEAR(Date_Added)

--Number of hours added to the playlist each year ordered by year
SELECT ROUND(SUM(time)/60, 2) AS NumberOfHoursAdded, YEAR(Date_Added) AS Year 
FROM dbo.playlist
GROUP BY YEAR(Date_Added)
ORDER BY YEAR(Date_Added)

--Number of songs added each year ordered from most to least excluding partial years
SELECT COUNT(*) AS NumberOfSongsAdded, YEAR(Date_Added) AS Year 
FROM dbo.playlist
WHERE Date_Added BETWEEN '2018-01-01' AND '2022-12-31'
GROUP BY YEAR(Date_Added)
ORDER BY COUNT(*) DESC;

--Song, artist, and release year ordered by the date and time added to the playlist
SELECT song, artist, Year_Released, 
Date_Added AS DateAddedToPlaylist,
Time_Added AS TimeAddedToPlaylist
FROM dbo.playlist
ORDER BY 4, 5

--songs by a given artist or remixed by that artist
GO
CREATE PROCEDURE searchbyartist (@artistname VARCHAR(100))
AS
BEGIN
	SELECT song, artist
	FROM dbo.playlist 
	WHERE artist LIKE @artistname OR song LIKE @artistname;
END
GO
EXEC searchbyartist @artistname = '%ILLENIUM%'
EXEC searchbyartist @artistname = '%Seven Lions%'
EXEC searchbyartist @artistname = '%Last Heroes%'

--songs by a given artist that are collabs
GO
CREATE PROCEDURE songsThatAreCollabs (@artistname VARCHAR(100))
AS
BEGIN
	WITH collab (song, artist) 
		AS(
	SELECT song, artist
	FROM dbo.playlist
	WHERE artist LIKE @artistname
		)
	SELECT song, artist FROM collab WHERE artist LIKE '%,%' OR artist LIKE '%&%';
END
GO
EXEC songsThatAreCollabs @artistname = '%Said The Sky%'
EXEC songsThatAreCollabs @artistname = '%Zedd%'
EXEC songsThatAreCollabs @artistname = '%Gryffin%'



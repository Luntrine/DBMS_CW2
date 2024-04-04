--Q1

SELECT COUNT(*) FROM imdb_actors WHERE sex = 'F';

--Q2

SELECT MAX(time) FROM imdb_runningtimes;

--Q3

SELECT COUNT(DISTINCT m.movieid) 
FROM imdb_movies2directors md
JOIN imdb_movies m ON m.movieid = md.movieid AND md.genre = 'Comedy'
JOIN imdb_movies2actors ma ON ma.movieid = m.movieid
JOIN imdb_actors a ON a.actorid = ma.actorid AND a.name = 'Ford, Harrison (I)';

--Q4

SELECT SUBSTRING_INDEX(name, ',', 1) AS surname, COUNT(*) AS movie_count
FROM imdb_movies2writers
JOIN imdb_writers ON imdb_movies2writers.writerid = imdb_writers.writerid
GROUP BY imdb_writers.writerid
ORDER BY movie_count DESC
LIMIT 1;

--Q5

SELECT SUM(rt.time1) AS total_running_time
FROM imdb_runningtimes rt
JOIN imdb_movies2directors md ON rt.movieid = md.movieid
WHERE md.genre = 'Sci-Fi';

--Q6

SELECT COUNT(DISTINCT m1.movieid) AS num_movies
FROM imdb_movies2actors m1
JOIN imdb_movies2actors m2 ON m1.movieid = m2.movieid
JOIN imdb_actors a1 ON m1.actorid = a1.actorid AND a1.name = 'McGregor, Ewan'
JOIN imdb_actors a2 ON m2.actorid = a2.actorid AND a2.name = 'Carlyle, Robert (I)';

--Q7

SELECT COUNT(DISTINCT m1.movieid) AS num_movies
FROM imdb_movies2actors m1
JOIN imdb_movies2actors m2 ON m1.movieid = m2.movieid AND m1.actorid < m2.actorid
JOIN imdb_actors a1 ON m1.actorid = a1.actorid
JOIN imdb_actors a2 ON m2.actorid = a2.actorid
GROUP BY m1.actorid, m2.actorid
HAVING COUNT(DISTINCT m1.movieid) >= 10;

--Q8

SELECT  CONCAT(FLOOR(year/10)*10, '-', FLOOR(year/10)*10+9) AS decade, COUNT(*) AS movies_count
FROM imdb_movies
GROUP BY decade
HAVING decade >= 1960
ORDER BY decade ASC;

--Q9

SELECT COUNT(*)
FROM (
    SELECT m.movieid
    FROM imdb_movies m
    JOIN imdb_movies2actors m2a ON m.movieid = m2a.movieid
    JOIN imdb_actors a ON m2a.actorid = a.actorid
    GROUP BY m.movieid
    HAVING SUM(CASE WHEN a.sex = 'F' THEN 1 ELSE -1 END) > 0
) AS female_movies;

--Q10

SELECT d.genre, AVG(r.rank) AS avg_rank
FROM imdb_movies2directors d
JOIN imdb_ratings r ON d.movieid = r.movieid
WHERE r.votes >= 10000
GROUP BY d.genre
ORDER BY avg_rank DESC
LIMIT 1;

--Q11

SELECT a.name, COUNT(DISTINCT md.genre) as num_genres
FROM imdb_actors a
JOIN imdb_movies2actors m2a ON a.actorid = m2a.actorid
JOIN imdb_movies2directors md ON m2a.movieid = md.movieid
GROUP BY a.name
HAVING COUNT(DISTINCT md.genre) >= 10;

--Q12

SELECT COUNT(DISTINCT m2a.movieid) AS movie_count
FROM imdb_movies2actors m2a
JOIN imdb_movies2directors m2d ON m2a.movieid = m2d.movieid
JOIN imdb_actors a ON m2a.actorid = a.actorid
JOIN imdb_directors d ON m2d.directorid = d.directorid
WHERE a.name = d.name;

--Q13

SELECT 
    CONCAT(LEFT(year, 3), '0s') AS decade,
    AVG(rank) AS avg_rank
FROM imdb_movies
JOIN imdb_ratings ON imdb_movies.movieid = imdb_ratings.movieid
GROUP BY decade
ORDER BY avg_rank DESC
LIMIT 1;

--Q14

SELECT COUNT(*) AS num_missing_genre_movies
FROM imdb_movies
LEFT JOIN imdb_movies2directors ON imdb_movies.movieid = imdb_movies2directors.movieid
WHERE imdb_movies2directors.genre IS NULL;

--Q15

SELECT COUNT(DISTINCT m.movieid) AS num_movies
FROM imdb_movies m
LEFT JOIN imdb_movies2actors ma ON m.movieid = ma.movieid
LEFT JOIN imdb_movies2directors md ON m.movieid = md.movieid
LEFT JOIN imdb_actors a ON a.actorid = ma.actorid
LEFT JOIN imdb_directors d ON d.directorid = md.directorid
LEFT JOIN imdb_movies2writers mw ON m.movieid = mw.movieid
LEFT JOIN imdb_writers w ON w.writerid = mw.writerid
WHERE a.name != d.name AND a.name = w.name;
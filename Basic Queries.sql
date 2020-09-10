#The Art Competitions
SELECT 
    sport_name, COUNT(athlete_id) AS athlete_count
FROM
    competition AS c
        INNER JOIN
    sport_event AS se ON c.sport_event_id = se.sport_event_id
        INNER JOIN
    sport s ON se.sport_id = s.sport_id
WHERE
	
    sport_name LIKE '%Art%';
-- 3578 athletes participated in Art Competitions.

# Which countries won the most art medals?
SELECT 
    noc_name, COUNT(medal_id) AS medal_count
FROM
    art
WHERE
    medal_id != 4
GROUP BY noc_name
ORDER BY medal_count DESC;
-- Germany won the most art medals, they had 26 medals.

# Nazis crush the 1936 Art Competitions
SELECT 
    noc_name, COUNT(medal_id) AS medal_count
FROM
    art
WHERE
    medal_id != 4 AND game_year = 1936
GROUP BY noc_name
ORDER BY medal_count DESC;
-- Germany had 14 medals this year.

# Medal counts for female athletes of different nations: 1936
select noc, gold, silver, bronze, total  from female_medal
where game_year = 1936;
# Top 3 nations are Germany, United States and Hungary with 27, 17 and 11 medals in total, respectively

# Medal counts for female athletes of different nations: 1976
select noc, gold, silver, bronze, total from female_medal
where game_year = 1976;
# Top 3 nations are Soviet Union, East Germany and United States with 120, 111 and 60 medals in total, respectively

# Medal counts for female athletes of different nations: 2016
select noc, gold, silver, bronze, total  from female_medal
where game_year = 2016;
# Top 3 nations are United States, Russia and China with 149, 83 and 75 medals in total, respectively

# Geographic representation
# Amsterdam 1928
select 
IF(GROUPING(noc), 'All Region', noc) AS noc, 
count(*) as 'athlete_count'
from exclude_art
where game_year = 1928 and season_name = 'Summer'
group by noc with rollup
order by count(*) desc;
# Total number of athletes participated in Amsterdam 1928 Olympic game is 4184, excluding the art competitions

# Munich 1972
SELECT 
    IF(GROUPING(noc), 'All Region', noc) AS noc,
    COUNT(*) AS 'athlete_count'
FROM
    exclude_art
WHERE
    game_year = 1972
        AND season_name = 'Summer'
GROUP BY noc WITH ROLLUP
ORDER BY COUNT(*) DESC;
# Total number of athletes participated in Munich 1972 Olympic game is 10304, excluding the art competitions

# Rio 2016
SELECT 
    IF(GROUPING(noc), 'All Region', noc) AS noc,
    COUNT(*) AS 'athlete_count'
FROM
    exclude_art
WHERE
    game_year = 2016
        AND season_name = 'Summer'
GROUP BY noc WITH ROLLUP
ORDER BY COUNT(*) DESC;
# Total number of athletes participated in Rio 2016 Olympic game is 13688, excluding the art competitions

-- age distribution for gold medals
SELECT 
    athlete_age, COUNT(medal_id)
FROM
    gold_medalist
WHERE
    athlete_age IS NOT NULL AND medal_id = 1
GROUP BY athlete_age
ORDER BY athlete_Age;

-- gold medals for athlete over 50 
SELECT 
    sport_name AS sport,
    COUNT(medal_id) AS 'gold medal count',
    ROUND(AVG(athlete_age)) AS 'average age'
FROM
    gold_medalist
WHERE
    athlete_age > 50
GROUP BY sport
ORDER BY COUNT(medal_id) DESC , ROUND(AVG(athlete_age)) DESC;

-- top 5 gold medal countries
SELECT 
    region 'country', COUNT(medal_id) 'gold medal count'
FROM
    gold_medalist
GROUP BY region
ORDER BY COUNT(medal_id) DESC
LIMIT 5;

-- average height/weight for a gold medalist by each sport
SELECT 
    sport_event_name,
    ROUND(AVG(athlete_height), 2) AS avg_height,
    ROUND(AVG(athlete_weight), 2) AS avg_weight
FROM
    gold_medalist
WHERE
    athlete_height
        AND athlete_weight IS NOT NULL
GROUP BY sport_event_name
ORDER BY avg_height DESC , avg_weight DESC;
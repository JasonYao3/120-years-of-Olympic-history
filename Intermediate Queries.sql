-- Using CTE to show the number of participants by each year and seASON
WITH participant_by_year_season AS (
	SELECT 
    game_year, 
    host_city_name, 
    season_name
	FROM 
		competitiON
			INNER JOIN 
		game
			USING (game_id)
			INNER JOIN 
		host_locatiON
			USING (host_id)
			INNER JOIN 
		seASON
			USING (season_id)
)
SELECT 
    game_year,
    host_city_name,
    SUM(CASE
        WHEN season_name = 'Winter' THEN 1
        ELSE 0
    END) AS Winter,
    SUM(CASE
        WHEN season_name LIKE '%Summer%' THEN 1
        ELSE 0
    END) AS Summer
FROM
    participant_by_year_season
GROUP BY game_year , season_name , host_city_name
ORDER BY game_year;
/* 
- first summer Olympics hosted in Athens 1896 with Only 380 athletes.
- first winter Olympics hosted in Chamonix 1924

Interesting historic events affected the Olympics games participant counts
- LA and Lake Placid 1932 summer and winter games had a significant drop of participants was due to the Great Depression.
- Melbourne 1956, had a significant drop of participants was due to countries boycotted in response to USSR's invasion of Hungary.
- Stockholm 1956, the first time in Olympics history where there are two countries hosted the summer game, the equestrian events wAS held in Stockholm due to Australia's strict quarantine regulations.
- Montreal 1976, 29 countries, mostly African, boycotted the game in resposne to the apartheid.
- Moscow 1980, 66 countries led by the US, boycotted the game entirely because of the Soviet-Afghan war.
- LA 1984, Soviet Union boycotted th game in response to the 1980 game boycot.
*/

CREATE VIEW art AS
    (SELECT 
        athlete_id,
        sport_event_id,
        noc_id,
        noc_name,
        sport_name,
        medal_id,
        sport_id,
        game_year
    FROM
        competitiON
            INNER JOIN
        game USING (game_id)
            INNER JOIN
        athlete USING (athlete_id)
            INNER JOIN
        medal USING (medal_id)
            INNER JOIN
        noc USING (noc_id)
            INNER JOIN
        sport_event USING (sport_event_id)
            INNER JOIN
        sport USING (sport_id)
    WHERE
        sport_id = 5);

-- Using Subquery to show that the number of artists over time
SELECT 
    game_year, SUM(artists) AS artists_count
FROM
    (SELECT 
        game_year, COUNT(athlete_id) AS artists
    FROM
        art
    GROUP BY game_year , athlete_id) AS artist
GROUP BY game_year
ORDER BY game_year;

/*
- 1912 the first year of art competitiONs had ONly 33 artists.
- Number of artists peaked at 1932 with 1124 of them.
- LASt year of art competitiONs is in 1948.
*/

-- Create a Temporary Table to exclude the art competitiONs
CREATE TEMPORARY TABLE exclude_art 
	(SELECT 
		game_year, athlete_gender, seASON_name, noc, c.athlete_id, , m.medal_id
	FROM
		competitiON AS c
			INNER JOIN
		athlete AS a ON c.athlete_id = a.athlete_id
			INNER JOIN
		game AS g ON g.game_id = c.game_id
			INNER JOIN
		sport_event AS se ON se.sport_event_id = c.sport_event_id
			INNER JOIN
		sport AS s USING (sport_id)
			INNER JOIN
		medal AS m ON m.medal_id = c.medal_id
			INNER JOIN
		noc AS n USING (noc_id)
			INNER JOIN
		host_locatiON AS hl USING (host_id)
			INNER JOIN
		seASON sea ON sea.seASON_id = g.seASON_id
	WHERE
		sport_id != 5
);
        
SELECT 
    game_year, season_name, Male, Female
FROM
    (SELECT 
        IF(GROUPING(game_year), 'All year', game_year) AS game_year,
            season_name,
            IF(GROUPING(athlete_gender), 'All gender', athlete_gender) AS athlete_gender,
            COUNT(CASE
                WHEN athlete_gender = 'M' THEN 1
                ELSE NULL
            END) Male,
            COUNT(CASE
                WHEN athlete_gender = 'F' THEN 1
                ELSE NULL
            END) Female
    FROM
        exclude_art
    GROUP BY game_year , athlete_gender WITH ROLLUP
    ORDER BY game_year DESC) t
WHERE
    athlete_gender = 'All gender';
# This query shows that in recent games the number of male and female athletes has been coming closer.
# In summer 1988, there are 10453 males and 4223 females. In summer 2016, there are 7465 males and 6223 females. 


# A Temporary table for query female athletes with medals
CREATE TEMPORARY TABLE 
female_medal 
AS  (
	SELECT 
		game_year, noc, gold, silver, bronze, total
	FROM
		(SELECT 
			game_year,
				IF(GROUPING(noc), 'All NOC', noc) AS noc,
				IF(GROUPING(medal_id), 'Total medal', medal_id) AS medal_id,
				COUNT(CASE
					WHEN medal_id = 1 THEN 1
					ELSE NULL
				END) gold,
				COUNT(CASE
					WHEN medal_id = 2 THEN 1
					ELSE NULL
				END) silver,
				COUNT(CASE
					WHEN medal_id = 3 THEN 1
					ELSE NULL
				END) bronze,
				COUNT(medal_id) total
		FROM
			exclude_art
		WHERE
			athlete_gender = 'F' AND medal_id < 4
		GROUP BY game_year , noc , medal_id WITH ROLLUP
		ORDER BY medal_id , total DESC) t
	WHERE
		medal_id = 'Total medal'
);

-- Countries that hosted highest number of olympics
-- GROUP CONCAT
SELECT 
    host_country_name AS 'host country',
    COUNT(game_year) AS 'number of host time',
    REPLACE(GROUP_CONCAT(game_year),
        ',',
        ' ') AS 'host year'
FROM
    host_location
        INNER JOIN
    game USING (host_id)
        INNER JOIN
    season USING (season_id)
WHERE
    season_id = 1 
GROUP BY host_country_name
ORDER BY COUNT(*) DESC;
# USA topped the list countres hosted the summer olympics for four times in 1904, 1932, 1984 and 1996.
# Great Britain and Greece both came in second place with three times hosted the summer olmypics.

SELECT 
    host_country_name AS 'host country',
    COUNT(game_year) AS 'number of host time',
    REPLACE(GROUP_CONCAT(game_year),
        ',',
        ' ') AS 'host year'
FROM
    host_location
        INNER JOIN
    game USING (host_id)
        INNER JOIN
    season USING (season_id)
WHERE
	season_id = 2
GROUP BY host_country_name
ORDER BY COUNT(*) DESC;
# USA topped the list countres hosted the winter olympics for four times in 1932, 1960, 1980 and 2002.
# France is the second place with three times hosted the winter olmypics in 1924, 1968 and 1992


# Create a View for gold medalist
CREATE VIEW gold_medalist AS
    (SELECT 
        athlete_age,
        medal_id,
        sport_name,
        noc_name,
        athlete_height,
        athlete_weight,
        sport_event_name,
        game_year,
        athlete_name,
        athlete_id
    FROM
        competition
            INNER JOIN
        athlete USING (athlete_id)
            INNER JOIN
        sport_event USING (sport_event_id)
            INNER JOIN
        game USING (game_id)
            INNER JOIN
        medal USING (medal_id)
            INNER JOIN
        noc USING (noc_id)
            INNER JOIN
        sport USING (sport_id)
    WHERE
        medal_id = 1);

-- athlete above average height for each sport event
-- get avg height of each sport event
SELECT 
    athlete_name,
    athlete_id,
    athlete_height,
    avg_height,
    avg_h.sport_event_name,
    game_year
FROM
    gold_medalist gm
        INNER JOIN
-- get the average height of each sport event
    (SELECT 
        sport_event_name,
            ROUND(AVG(athlete_height), 2) AS avg_height
    FROM
        gold_medalist
    WHERE
        athlete_height IS NOT NULL
    GROUP BY sport_event_name) AS avg_h USING (sport_event_name)
WHERE
    athlete_height > avg_h.avg_height;
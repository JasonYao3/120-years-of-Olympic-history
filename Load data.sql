CREATE SCHEMA olympics;
USE olympics;

DROP TABLE IF EXISTS athlete_event;

# CreateD tableS to load kaggle data in csv format
CREATE TABLE kaggle_data (
    athlete_id SMALLINT NOT NULL,
    name VARCHAR(256) NOT NULL,
    sex ENUM('M', 'F') NOT NULL,
    age VARCHAR(5),
    height VARCHAR(5),
    weight VARCHAR(20),
    team VARCHAR(50) NOT NULL,
    NOC VARCHAR(3) NOT NULL,
    games VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    season VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    sport VARCHAR(50) NOT NULL,
    event VARCHAR(256) NOT NULL,
    medal VARCHAR(10)
);

DROP TABLE IF EXISTS noc_regions;

CREATE TABLE noc_regions (
    NOC VARCHAR(3) NOT NULL,
    continent VARCHAR(50),
    region VARCHAR(50),
    notes VARCHAR(50)
);

DROP TABLE IF EXISTS game_data;

CREATE TEMPORARY TABLE game_data (
    year INT NOT NULL,
    season ENUM('Winter', 'Summer') NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    participants_country INT NOT NULL,
    participants INT NOT NULL,
    men INT NOT NULL,
    women INT NOT NULL,
    sports INT NOT NULL,
    events INT NOT NULL
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

DROP TABLE IF EXISTS hostcity_data;

CREATE TABLE hostcity_data (
    host_year INT NOT NULL,
    season ENUM('Winter', 'Summer') NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    lng DECIMAL(11 , 8 ) NOT NULL,
    lat DECIMAL(10 , 8 ) NOT NULL
);

DROP TABLE IF EXISTS sport;

CREATE TABLE sport (
    sport VARCHAR(50) NOT NULL,
    season ENUM('Winter', 'Summer') NOT NULL,
    participant INT NOT NULL,
    men INT NOT NULL,
    women INT NOT NULL,
    participants_country INT NOT NULL,
    editions INT NOT NULL,
    events INT NOT NULL
);

# Load data into the database from csv format
LOAD DATA INFILE
'H:/kaggle data/olympic/athlete_events.csv'
INTO TABLE kaggle_data
FIELDS ENCLOSED BY '"'
TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA INFILE
'H:/kaggle data/olympic/d_noc.csv'
INTO TABLE noc_regions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE
'H:/kaggle data/olympic/d_games.csv'
INTO TABLE game_data
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

ALTER TABLE game_data ORDER BY year ASC;

LOAD DATA INFILE
'H:/kaggle data/olympic/d_hostcity.csv'
INTO TABLE hostcity_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE
'H:/kaggle data/olympic/d_sports.csv'
INTO TABLE sport
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

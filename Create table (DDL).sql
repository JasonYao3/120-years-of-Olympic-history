-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema olympics
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema olympics
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `olympics` DEFAULT CHARACTER SET utf8 ;
USE `olympics` ;

-- -----------------------------------------------------
-- Table `olympics`.`noc_region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`noc_region` (
  `noc_region_id` INT NOT NULL AUTO_INCREMENT,
  `noc` VARCHAR(3) NULL DEFAULT NULL,
  `region` VARCHAR(45) NULL DEFAULT NULL,
  `continent` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`noc_region_id`),
  INDEX `idx_noc` (`noc` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 256
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`athlete`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`athlete` (
  `athlete_id` INT NOT NULL AUTO_INCREMENT,
  `athlete_name` VARCHAR(120) NULL DEFAULT NULL,
  `athlete_gender` ENUM('M', 'F') NULL DEFAULT NULL COMMENT 'M = Male\\nF  = Female',
  `noc_region_id` INT NOT NULL,
  PRIMARY KEY (`athlete_id`),
  INDEX `fk_athlete_noc_region1_idx` (`noc_region_id` ASC) INVISIBLE,
  INDEX `idx_name` (`athlete_name` ASC) VISIBLE,
  CONSTRAINT `fk_athlete_noc_region1`
    FOREIGN KEY (`noc_region_id`)
    REFERENCES `olympics`.`noc_region` (`noc_region_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 196606
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`host_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`host_location` (
  `host_id` INT NOT NULL AUTO_INCREMENT,
  `host_city_name` VARCHAR(45) NULL DEFAULT NULL,
  `host_country_name` VARCHAR(45) NULL DEFAULT NULL,
  `host_lng` VARCHAR(45) NULL DEFAULT NULL,
  `host_lat` VARCHAR(45) NULL DEFAULT NULL COMMENT 'lng = longtitude\\nlat = latitude\\n',
  PRIMARY KEY (`host_id`),
  INDEX `idx_city` (`host_city_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 43
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`game`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`game` (
  `game_id` INT NOT NULL AUTO_INCREMENT,
  `game_year` INT NULL DEFAULT NULL,
  `game_season` VARCHAR(40) NULL DEFAULT NULL,
  `game_country_count` INT NULL DEFAULT NULL,
  `game_participant_count` INT NULL DEFAULT NULL,
  `game_men_count` INT NULL DEFAULT NULL,
  `game_women_count` INT NULL DEFAULT NULL,
  `game_sport_count` INT NULL DEFAULT NULL,
  `game_event_count` INT NULL DEFAULT NULL,
  `host_id` INT NOT NULL,
  PRIMARY KEY (`game_id`),
  INDEX `fk_game_host_location1_idx` (`host_id` ASC) VISIBLE,
  INDEX `idx_season` (`game_season` ASC) VISIBLE,
  CONSTRAINT `fk_game_host_location1`
    FOREIGN KEY (`host_id`)
    REFERENCES `olympics`.`host_location` (`host_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 64
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`medal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`medal` (
  `medal_id` INT NOT NULL AUTO_INCREMENT,
  `medal_type` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`medal_id`),
  INDEX `idx_medal_type` (`medal_type` ASC) INVISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`sport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`sport` (
  `sport_id` INT NOT NULL AUTO_INCREMENT,
  `sport_name` VARCHAR(45) NULL DEFAULT NULL,
  `sport_season` VARCHAR(45) NULL DEFAULT NULL,
  `sport_participant_count` INT NULL DEFAULT NULL,
  `sport_men_count` INT NULL DEFAULT NULL,
  `sport_women_count` INT NULL DEFAULT NULL,
  `sport_country_count` INT NULL DEFAULT NULL,
  `sport_edition` INT NULL DEFAULT NULL,
  `sport_event_count` INT NULL DEFAULT NULL,
  PRIMARY KEY (`sport_id`),
  INDEX `idx_season` (`sport_season` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 128
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`sport_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`sport_event` (
  `sport_event_id` INT NOT NULL AUTO_INCREMENT,
  `sport_event_name` VARCHAR(100) NULL DEFAULT NULL,
  `sport_id` INT NOT NULL,
  PRIMARY KEY (`sport_event_id`),
  INDEX `idx_sport_event` (`sport_event_name` ASC) VISIBLE,
  INDEX `fk_sport_event_sport_idx` (`sport_id` ASC) VISIBLE,
  CONSTRAINT `fk_sport_event_sport`
    FOREIGN KEY (`sport_id`)
    REFERENCES `olympics`.`sport` (`sport_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1024
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`competition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`competition` (
  `athlete_id` INT NOT NULL,
  `athlete_age` VARCHAR(45) NULL DEFAULT NULL,
  `athlete_height` VARCHAR(45) NULL DEFAULT NULL,
  `athlete_weight` VARCHAR(45) NULL DEFAULT NULL,
  `game_id` INT NOT NULL,
  `sport_event_id` INT NOT NULL,
  `medal_id` INT NOT NULL,
  INDEX `fk_competition_medal1_idx` (`medal_id` ASC) VISIBLE,
  INDEX `fk_competition_sport_event1_idx` (`sport_event_id` ASC) VISIBLE,
  INDEX `fk_competition_game1_idx` (`game_id` ASC) VISIBLE,
  INDEX `fk_competition_athlete1_idx` (`athlete_id` ASC) VISIBLE,
  CONSTRAINT `fk_competition_athlete1`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `olympics`.`athlete` (`athlete_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_competition_game1`
    FOREIGN KEY (`game_id`)
    REFERENCES `olympics`.`game` (`game_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_competition_medal1`
    FOREIGN KEY (`medal_id`)
    REFERENCES `olympics`.`medal` (`medal_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_competition_sport_event1`
    FOREIGN KEY (`sport_event_id`)
    REFERENCES `olympics`.`sport_event` (`sport_event_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`kaggle_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`kaggle_data` (
  `name` VARCHAR(256) NOT NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `age` VARCHAR(5) NULL DEFAULT NULL,
  `height` VARCHAR(5) NULL DEFAULT NULL,
  `weight` VARCHAR(20) NULL DEFAULT NULL,
  `team` VARCHAR(50) NOT NULL,
  `NOC` VARCHAR(3) NOT NULL,
  `games` VARCHAR(50) NOT NULL,
  `year` INT NOT NULL,
  `season` VARCHAR(255) NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `sport` VARCHAR(50) NOT NULL,
  `event` VARCHAR(256) NOT NULL,
  `medal` VARCHAR(10) NULL DEFAULT NULL,
  INDEX `1` (`name` ASC) VISIBLE,
  INDEX `2` (`sex` ASC) VISIBLE,
  INDEX `3` (`season` ASC) VISIBLE,
  INDEX `4` (`medal` ASC) VISIBLE,
  INDEX `5` (`event` ASC) VISIBLE,
  INDEX `6` (`year` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `olympics`.`team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olympics`.`team` (
  `team_id` INT NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(50) NULL DEFAULT NULL,
  `noc_region_id` INT NOT NULL,
  PRIMARY KEY (`team_id`),
  INDEX `idx_team_name` (`team_name` ASC) VISIBLE,
  INDEX `fk_team_noc_region1_idx` (`noc_region_id` ASC) VISIBLE,
  CONSTRAINT `fk_team_noc_region1`
    FOREIGN KEY (`noc_region_id`)
    REFERENCES `olympics`.`noc_region` (`noc_region_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2048
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

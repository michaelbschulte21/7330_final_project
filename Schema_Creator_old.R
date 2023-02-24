# Schema_Creator_old.R

source('Connections/Local_connect.R')
rm(secrets)

############ Create Schema #########
script <- paste0('CREATE SCHEMA IF NOT EXISTS formula1;')
dbExecute(conn = dbconnection_local, statement = script)

######### Create Tables ################
# Circuits
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Circuits` (
                  `circuit_ID` INT NOT NULL,
                  `circuit_Ref` VARCHAR(45) NOT NULL,
                  `name` VARCHAR(45) NOT NULL,
                  `location` VARCHAR(45) NULL,
                  `country` VARCHAR(45) NULL,
                  `latitude` FLOAT NULL,
                  `longitude` FLOAT NULL,
                  `number_alt` FLOAT NULL,
                  PRIMARY KEY (`circuit_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Driver Standings
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Driver_Standings` (
                  `driver_Standings_ID` INT NOT NULL,
                  `race_ID` INT NULL,
                  `driver_ID` INT NULL,
                  `points` INT NULL,
                  `position` INT NULL,
                  `position_Text` INT NULL,
                  `wins` INT NULL,
                  PRIMARY KEY (`driver_Standings_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Drivers
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Drivers` (
                  `driver_ID` INT NOT NULL,
                  `driver_Ref` VARCHAR(45) NULL,
                  `number` INT NULL,
                  `code` CHAR(3) NULL,
                  `forename` VARCHAR(45) NULL,
                  `surname` VARCHAR(45) NULL,
                  `DOB` DATE NULL,
                  `nationality` VARCHAR(45) NULL,
                  PRIMARY KEY (`driver_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Lap Times
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Lap_Times` (
                  `race_ID` INT NOT NULL,
                  `driver_ID` INT NULL,
                  `lap` INT NULL,
                  `position` INT NULL,
                  `time` TIME NULL,
                  `milliseconds` INT NULL,
                  PRIMARY KEY (`race_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Races
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Races` (
                  `race_ID` INT NOT NULL,
                  `year` INT NULL,
                  `round` INT NULL,
                  `circuit_ID` INT NULL,
                  `name` VARCHAR(45) NULL,
                  `date` DATE NULL,
                  `time` TIME NULL,
                  PRIMARY KEY (`race_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Results
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Results` (
                  `result_ID` INT NOT NULL,
                  `race_ID` INT NULL,
                  `driver_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `number` INT NULL,
                  `grid` INT NULL,
                  `position` INT NULL,
                  `position_Text` INT NULL,
                  `position_Order` INT NULL,
                  `points` INT NULL,
                  `laps` INT NULL,
                  `time` TIME NULL,
                  `milliseconds` INT NULL,
                  `fastest_Lap` INT NULL,
                  `rank` INT NULL,
                  `fastest_Lap_Time` TIME NULL,
                  `fastest_Lap_Speed` FLOAT NULL,
                  `status_ID` INT NULL,
                  PRIMARY KEY (`result_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Constructors
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Constructors` (
                  `constructor_ID` INT NOT NULL,
                  `constructor_Ref` VARCHAR(45) NULL,
                  `name` VARCHAR(45) NULL,
                  `nationality` VARCHAR(45) NULL,
                  PRIMARY KEY (`constructor_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Qualifying
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Qualifying` (
                  `qualify_ID` INT NOT NULL,
                  `race_ID` INT NULL,
                  `driver_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `number` INT NULL,
                  `position` INT NULL,
                  `q1` TIME NULL,
                  `q2` TIME NULL,
                  `q3` TIME NULL,
                  PRIMARY KEY (`qualify_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Pit Stops
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Pit_Stops` (
                  `race_ID` INT NOT NULL,
                  `driver_ID` INT NULL,
                  `stop` INT NULL,
                  `lap` INT NULL,
                  `time` TIME NULL,
                  `duration` FLOAT NULL,
                  `milliseconds` INT NULL,
                  PRIMARY KEY (`race_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Constructor Standings
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Constructor_Standings` (
                  `constructor_Standings_ID` INT NOT NULL,
                  `race_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `points` INT NULL,
                  `position` INT NULL,
                  `position_Text` INT NULL,
                  `wins` INT NULL,
                  PRIMARY KEY (`constructor_Standings_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Constructor Results
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Constructor_Results` (
                  `constructor_Results_ID` INT NOT NULL,
                  `race_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `points` INT NULL,
                  PRIMARY KEY (`constructor_Results_ID`));")
dbExecute(conn = dbconnection_local, statement = script)

# Seasons
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Seasons` (
                  `year` INT NOT NULL,
                  PRIMARY KEY (`year`));")
dbExecute(conn = dbconnection_local, statement = script)

# Status
script <- paste0("CREATE TABLE IF NOT EXISTS `formula1`.`Status` (
                  `status_ID` INT NOT NULL,
                  `status` VARCHAR(45) NULL,
                  PRIMARY KEY (`status_ID`));")
dbExecute(conn = dbconnection_local, statement = script)
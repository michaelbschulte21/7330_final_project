# Master/Schema_Creator_master.R

source('Connections/Local_connect.R')
rm(secrets)

############ Create Schema #########
script <- paste0('CREATE SCHEMA IF NOT EXISTS f1_master;')
# script <- paste0('DROP SCHEMA f1_master;')
dbExecute(conn = dbconnection_local, statement = script)

dbKillConnections()

source('Connections/Master_connect.R')
rm(secrets)

######### Create Tables ################
########## Circuits ##########
script <- paste0("CREATE TABLE IF NOT EXISTS `Circuits` (
                  `circuit_ID` INT NOT NULL AUTO_INCREMENT,
                  -- `circuit_Ref` VARCHAR(45) NOT NULL,
                  `circuit_name` VARCHAR(45) NOT NULL,
                  `circuit_abbr` VARCHAR(45) NULL,
                  `locality` VARCHAR(45) NULL,
                  `country` VARCHAR(45) NULL,
                  `latitude` FLOAT NULL,
                  `longitude` FLOAT NULL,
                  -- `number_alt` FLOAT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`circuit_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

########## Driver Standings ##########
script <- paste0("CREATE TABLE IF NOT EXISTS `Driver_Standings` (
                  `driver_Standings_ID` INT NOT NULL AUTO_INCREMENT,
                  `race_ID` INT NULL,
                  `driver_ID` INT NULL,
                  `points` INT NULL,
                  `position` INT NULL,
                  `position_Text` varchar(3) NULL,
                  `wins` INT NULL,
                  `constructor_ID` INT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`driver_Standings_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

########### Drivers ##############
script <- paste0("CREATE TABLE IF NOT EXISTS `Drivers` (
                  `driver_ID` INT NOT NULL AUTO_INCREMENT,
                  `driver_abbr` VARCHAR(45) NULL,
                  -- `driver_Ref` VARCHAR(45) NULL,
                  `number` INT NULL,
                  `code` CHAR(3) NULL,
                  `first_name` VARCHAR(45) NULL,
                  `last_name` VARCHAR(45) NULL,
                  `DOB` DATE NULL,
                  `nationality` VARCHAR(45) NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`driver_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############ Lap Times ###############
script <- paste0("CREATE TABLE IF NOT EXISTS `Lap_Times` (
                  `race_ID` INT NOT NULL,
                  `driver_ID` INT NULL,
                  `lap` INT NULL,
                  `position` INT NULL,
                  `time` TIME(3) NULL
                  -- `milliseconds` INT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  -- PRIMARY KEY (`race_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############### Races #############
script <- paste0("CREATE TABLE IF NOT EXISTS `Races` (
                  `race_ID` INT NOT NULL AUTO_INCREMENT,
                  `year` INT NULL,
                  `round` INT NULL,
                  `circuit_ID` INT NULL,
                  `race_name` VARCHAR(45) NULL,
                  `date` DATE NULL,
                  `time` TIME(3) NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`race_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############# Results #############
# Turning the time column into varchar. Need to figure out how to convert 65.32 into 00:00:65.32
script <- paste0("CREATE TABLE IF NOT EXISTS `Results` (
                  `result_ID` INT NOT NULL AUTO_INCREMENT,
                  `race_ID` INT NULL,
                  `driver_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `number` INT NULL,
                  `grid` INT NULL,
                  `position` INT NULL,
                  `position_Text` varchar(3) NULL,
                  -- `position_Order` INT NULL,
                  `points` INT NULL,
                  `laps` INT NULL,
                  `time` TIME(3) NULL,
                  `milliseconds` INT NULL,
                  `fastest_Lap` INT NULL,
                  `rank` INT NULL,
                  `fastest_Lap_Time` TIME(3) NULL,
                  `fastest_Lap_Speed` FLOAT NULL,
                  `fastest_Lap_Speed_Units` char(3) NULL,
                  `status_ID` INT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`result_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############## Constructors ##############
script <- paste0("CREATE TABLE IF NOT EXISTS `Constructors` (
                  `constructor_ID` INT NOT NULL AUTO_INCREMENT,
                  -- `constructor_Ref` VARCHAR(45) NULL,
                  `constructor_name` VARCHAR(45) NULL,
                  `constructor_abbr` VARCHAR(45) NULL,
                  `nationality` VARCHAR(45) NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`constructor_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############ Qualifying #############
script <- paste0("CREATE TABLE IF NOT EXISTS `Qualifying` (
                  `qualify_ID` INT NOT NULL AUTO_INCREMENT,
                  `race_ID` INT NULL,
                  `driver_ID` varchar(45) NULL,
                  `constructor_ID` INT NULL,
                  `number` INT NULL,
                  `position` INT NULL,
                  `q1` TIME(3) NULL,
                  `q2` TIME(3) NULL,
                  `q3` TIME(3) NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`qualify_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############# Pit Stops ###############
script <- paste0("CREATE TABLE IF NOT EXISTS `Pit_Stops` (
                  `race_ID` INT NOT NULL,
                  `driver_ID` INT NULL,
                  `stop` INT NULL,
                  `lap` INT NULL,
                  `time` TIME(3) NULL,
                  `duration` FLOAT NULL
                  -- `milliseconds` INT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  -- PRIMARY KEY (`race_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

############# Constructor Standings #############
script <- paste0("CREATE TABLE IF NOT EXISTS `Constructor_Standings` (
                  `constructor_Standings_ID` INT NOT NULL AUTO_INCREMENT,
                  `race_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `points` INT NULL,
                  `position` INT NULL,
                  `position_Text` varchar(3) NULL,
                  `wins` INT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL,
                  PRIMARY KEY (`constructor_Standings_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

########### Constructor Results ##############
script <- paste0("CREATE TABLE IF NOT EXISTS `Constructor_Results` (
                  `constructor_Results_ID` INT NOT NULL AUTO_INCREMENT,
                  `race_ID` INT NULL,
                  `constructor_ID` INT NULL,
                  `driver_ID` INT NULL,
                  `points` INT NULL,
                  `number` INT NULL,
                  `position` INT NULL,
                  `position_Text` varchar(3) NULL,
                  `status_ID` INT NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`constructor_Results_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

################ Seasons ###########
script <- paste0("CREATE TABLE IF NOT EXISTS `Seasons` (
                  `year` INT NOT NULL,
                  `num_rounds` INT NULL,
                  PRIMARY KEY (`year`)
                 );")
dbExecute(conn = dbconnection_master, statement = script)

############## Status ##########
script <- paste0("CREATE TABLE IF NOT EXISTS `Status` (
                  `status_ID` INT NOT NULL AUTO_INCREMENT,
                  `status` VARCHAR(45) NULL,
                  -- `season` INT NULL,
                  -- `round` INT NULL
                  PRIMARY KEY (`status_ID`)
                  );")
dbExecute(conn = dbconnection_master, statement = script)

dbKillConnections()

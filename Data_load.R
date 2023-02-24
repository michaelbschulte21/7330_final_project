# Data_load.R

# source('API/API_access_pt1.R')

source('Connections/F1_connect.R')
rm(secrets)

# script <- paste0("select table_schema as database_name,
#                   table_name
#                   from information_schema.tables
#                   where table_type = 'BASE TABLE'
#                   and table_schema = 'formula1' -- enter your database name here
#                   order by database_name, table_name;")
# stuff <- dbGetQuery(conn = dbconnection_f1, statement = script)

# Seasons
# script <- paste0("INSERT INTO seasons (year)
#                      VALUES ", paste("(",
#                                      years
#                                      ,")", collapse = ",\n"),";")
# dbExecute(conn = dbconnection_f1, statement = script)

require(dplyr)

script <- paste0("SELECT max(year) AS max_year
                 FROM Seasons;")
start_year <- dbGetQuery(conn = dbconnection_f1, statement = script)
start_year <- start_year$max_year
if(is.na(start_year)){
  start_year <- 1
} else if(start_year != max(years)){
  start_year <- length(years) - (as.integer(max(years)) - start_year) + 1
} else if(start_year == max(years)){
  start_year <- length(years)
  script <- paste0("DELETE FROM Seasons
                   WHERE year = ", max(years),";")
  dbExecute(conn = dbconnection_f1, statement = script)
  i <- length(years)
  source('Connections/Season_connect.R')
  script <- paste0("TRUNCATE TABLE Circuits;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Driver_Standings;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Drivers;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Lap_Times;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Races;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Results;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Constructors;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Qualifying;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Pit_Stops;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Constructor_Standings;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Constructor_Results;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABEL Seasons;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Status;")
  dbExecute(conn = dbconnection_season, statement = script)
}

for(i in start_year:length(years)){
  dbKillConnections()
  source('Connections/F1_connect.R')
  source('Connections/Season_connect.R')
  rm(secrets)
  race <- api_getter(season = years[i], round_number = NULL, value = NULL)
  race <- race$MRData$RaceTable$Races
  num_rounds <- max(as.integer(race$round))
  
  script <- paste0("INSERT INTO Seasons (year, num_rounds)
                   VALUES ", paste("(",
                                   years[i], ", ",
                                   num_rounds
                                   ,")", sep = "", collapse = ",\n"),";")
  dbExecute(conn = dbconnection_f1, statement = script)
  
  for(nr in 1:num_rounds){
    source('API/API_access_pt2.R')
  
    # Circuits
    script <- paste0("INSERT INTO circuits (circuit_ID, circuit_Ref, name, location, country, latitude, longitude, number_alt)
                     VALUES ", paste("(",
                                    
                                    ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Constructor Standings
    script <- paste0("INSERT INTO constructor_standings (constructor_Standings_ID, race_ID, constructor_ID, points, position, position_Text, wins)
                     VALUES ", paste("(",
                                    
                                    ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Constructor Results
    script <- paste0("INSERT INTO constructor_results (constructor_Results_ID, race_ID, constructor_ID, points)
                     VALUES ", paste("(",
                                    
                                    ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Constructors
    script <- paste0("INSERT INTO constructors (constructor_ID, constructor_Ref, name, nationality)
                     VALUES ", paste("(",
                                    
                                    ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Driver Standings
    script <- paste0("INSERT INTO driver_standings (driver_Standings_ID, race_ID, driver_ID, points, position, position_Text, wins)
                     VALUES ", paste("(",
                                    
                                    ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Drivers
    script <- paste0("INSERT INTO drivers (driver_ID, driver_Ref, number, code, forename, surname, DOB, nationality)
                     VALUES ();")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Lap Times
    if(years[i] >= 1996){
      script <- paste0("INSERT INTO lap_times (race_ID, driver_ID, lap, position, time, milliseconds)
                       VALUES ", paste("(",
                                       
                                       ,")", collapse = ",\n"),";")
      dbExecute(conn = dbconnection_f1, statement = script)
    }
    
    # Pit Stops
    if(years[i] >= 2012){
      script <- paste0("INSERT INTO pit_stops (race_ID, driver_ID, stop, lap, time, duration, milliseconds)
                       VALUES ", paste("(",
                                       
                                       ,")", collapse = ",\n"),";")
      dbExecute(conn = dbconnection_f1, statement = script)
    }
    
    # Qualifying
    script <- paste0("INSERT INTO qualifying (qualify_ID, race_ID, driver_ID, constructor_ID, number, position, q1, q2, q3)
                     VALUES ", paste("(",
                                     
                                     ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Races
    script <- paste0("INSERT INTO races (race_ID, year, round, circuit_ID, name, date, time)
                     VALUES ", paste("(",
                                     
                                     ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Results
    script <- paste0("INSERT INTO results (result_ID, race_ID, driver_ID, constructor_ID, number, grid, position, position_Text, position_Order, points, laps, time, milliseconds, fastest_Lap, rank, fastest_Lap_Time, fastest_Lap_Speed, status_ID)
                     VALUES ", paste("(",
                                     
                                     ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
    
    # Seasons
    # script <- paste0("INSERT INTO seasons (year)
    #                  VALUES ", paste("(",
    #                                  
    #                                  ,")", collapse = ",\n"),";")
    # dbExecute(conn = dbconnection_f1, statement = script)
    
    # Status
    script <- paste0("INSERT INTO status (status_ID, status)
                     VALUES ", paste("(",
                                     
                                     ,")", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_f1, statement = script)
  }
}
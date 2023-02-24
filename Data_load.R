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
  
  # Seasons
  script <- paste0("INSERT INTO seasons (year)
                     VALUES ", paste("(",
                                     years[i]
                                     ,")", collapse = ",\n"),";")
  dbExecute(conn = dbconnection_season, statement = script)
  
  for(nr in 1:num_rounds){
    source('API/API_access_pt2.R')
  
    # Circuits
    script <- paste0("INSERT INTO circuits (circuit_ID, circuit_name, locality, country, latitude, longitude, round)
                     VALUES ", paste("('",
                                    circuits$circuitId, "', '",
                                    circuits$circuitName, "', '",
                                    circuits$Location$locality, "', '",
                                    circuits$Location$country, "', ",
                                    circuits$Location$lat, ", ",
                                    circuits$Location$long, ", ",
                                    nr
                                    ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Constructor Standings
    script <- paste0("INSERT INTO constructor_standings (constructor_ID, points, position, position_Text, wins, round)
                     VALUES ", paste("('",
                                    constructorStandings$Constructor$constructorId, "', ",
                                    constructorStandings$points, ", ",
                                    constructorStandings$position, ", '",
                                    constructorStandings$positionText, "', ",
                                    constructorStandings$wins, ", ",
                                    nr
                                    ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Constructor Results
    script <- paste0("INSERT INTO constructor_results (race_name, constructor_ID, driver_ID, points, number, position, position_Text, status, round)
                     VALUES ", paste("('",
                                    results.race$raceName, "', '",
                                    results$Constructor$constructorId, "', '",
                                    results$Driver$driverId, "', ",
                                    results$points, ", ",
                                    results$number, ", ",
                                    results$position, ", '",
                                    results$positionText, "', '",
                                    results$status, "', ",
                                    nr
                                    ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Constructors
    script <- paste0("INSERT INTO constructors (constructor_ID, constructor_name, nationality, round)
                     VALUES ", paste("('",
                                    constructors$constructorId, "', '",
                                    constructors$name, "', '",
                                    constructors$nationality, "', ",
                                    nr
                                    ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Driver Standings
    script <- paste0("INSERT INTO driver_standings (driver_ID, points, position, position_Text, wins, constructor_ID, round)
                     VALUES ", paste("('",
                                    driverStandings$Driver$driverId, "', ",
                                    driverStandings$points, ", ",
                                    driverStandings$position, ", '",
                                    driverStandings$positionText, "', ",
                                    driverStandings$wins, ", '",
                                    driverStandings.constructors$constructorId, "', ",
                                    nr
                                    ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Drivers
    script <- paste0("INSERT INTO drivers (driver_ID, number, code, first_name, last_name, DOB, nationality, round)
                     VALUES ", paste("('",
                                     drivers$driverId, "', ",
                                     drivers$permanentNumber, ", '",
                                     drivers$code, "', '",
                                     drivers$givenName, "', '",
                                     drivers$familyName, "', '",
                                     drivers$dateOfBirth, "', '",
                                     drivers$nationality, "', ",
                                     nr
                                     ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Lap Times
    if(years[i] >= 1996){
      script <- paste0("INSERT INTO lap_times (race_name, driver_ID, lap, position, time, round)
                       VALUES ", paste("('",
                                       laps$Races.raceName, "', '",
                                       laps.laps.timings$driverId, "', ",
                                       laps.laps$number, ", ",
                                       laps.laps.timings$position, ", '",
                                       laps.laps.timings$time, "', ",
                                       nr
                                       ,")", sep = "", collapse = ",\n"),";")
      dbExecute(conn = dbconnection_season, statement = script)
    }
    
    # Pit Stops
    if(years[i] >= 2012){
      script <- paste0("INSERT INTO pit_stops (race_name, driver_ID, stop, lap, time, duration, round)
                       VALUES ", paste("('",
                                       pitstops.races$Races.raceName, "', '",
                                       pitstops.pitstops$driverId, "', ",
                                       pitstops.pitstops$stop, ", ",
                                       pitstops.pitstops$lap, ", '",
                                       pitstops.pitstops$time, "', ",
                                       pitstops.pitstops$duration, ", ",
                                       nr
                                       ,")", sep = "", collapse = ",\n"),";")
      dbExecute(conn = dbconnection_season, statement = script)
    }
    
    # Qualifying
    script <- paste0("INSERT INTO qualifying (race_name, driver_ID, constructor_ID, number, position, q1, q2, q3, round)
                     VALUES ", paste("('",
                                     qualifying.races$raceName, "', '",
                                     qualifying$Driver$driverId, "', '",
                                     qualifying$Constructor$constructorId, "', ",
                                     qualifying$number, ", ",
                                     qualifying$position, ", '",
                                     qualifying$Q1, "', '",
                                     qualifying$Q2, "', '",
                                     qualifying$Q3, "', ",
                                     nr
                                     ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Races
    script <- paste0("INSERT INTO races (race_name, year, circuit_ID, date, time, round)
                     VALUES ", paste("('",
                                     race$raceName, "', ",
                                     years[i], ", '",
                                     race$Circuit$circuitId, "', '",
                                     race$date, "', '",
                                     race$time, "', ",
                                     nr
                                     ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Results
    script <- paste0("INSERT INTO results (race_name, driver_ID, constructor_ID, number, grid, position, position_Text, points, laps, time, milliseconds, fastest_Lap, rank, fastest_Lap_Time, fastest_Lap_Speed, fastest_Lap_Speed_Units, status, round)
                     VALUES ", paste("('",
                                     results.race$raceName, "', '",
                                     results$Driver$driverId, "', '",
                                     results$Constructor$constructorId, "', ",
                                     results$number, ", ",
                                     results$grid, ", ",
                                     results$position, ", '",
                                     results$positionText, "', ",
                                     results$points, ", ",
                                     results$laps, ", '",
                                     results$Time$time, "', ",
                                     results$Time$millis, ", ",
                                     results$FastestLap$lap, ", ",
                                     results$FastestLap$rank, ", '",
                                     results$FastestLap$Time$time, "', ",
                                     results$FastestLap$AverageSpeed$speed, ", ",
                                     results$FastestLap$AverageSpeed$units, ", ",
                                     results$status, ", ",
                                     nr
                                     ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
    
    # Status
    script <- paste0("INSERT INTO status (status_ID, status, round)
                     VALUES ", paste("(",
                                     status$statusId, ", '",
                                     status$status, "', ",
                                     nr
                                     ,")", sep = "", collapse = ",\n"),";")
    dbExecute(conn = dbconnection_season, statement = script)
  }
}
# Data_load.R

####### Start #########
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
  truncate_current(i)
}

print(paste0("start_year = ", start_year, " which is year = ", years[start_year]))

source('Data_Cleaning_Tools.R')

stop_loop <- FALSE

######## Start of Years Loop ##########
for(i in start_year:length(years)){
  dbKillConnections()
  print(paste0("The season is ", years[i]))
  source('Connections/F1_connect.R')
  source('Connections/Season_connect.R')
  rm(secrets)
  race <- api_getter(season = years[i], round_number = NULL, value = NULL)
  race <- race$MRData$RaceTable$Races
  num_rounds <- max(as.integer(race$round))
  
  # Seasons for formula1
  script <- paste0("INSERT INTO seasons (year, num_rounds)
                   VALUES ", paste("(",
                                   years[i], ", ",
                                   num_rounds
                                   ,")", sep = "", collapse = ",\n"),";")
  dbExecute(conn = dbconnection_f1, statement = script)
  
  script <- paste0("INSERT INTO table_insert_tracker (year, num_rounds)
                   VALUES ", paste("(",
                                   years[i], ", ",
                                   num_rounds
                                   ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_f1, statement = script)
  
  # Seasons for f1_year[i]
  script <- paste0("INSERT INTO seasons (year, num_rounds)
                     VALUES ", paste("(",
                                     years[i], ", ",
                                     num_rounds
                                     ,")", collapse = ",\n"),";")
  dbExecute(conn = dbconnection_season, statement = script)
  
  script <- paste0("UPDATE table_insert_tracker
                   SET
                   seasons = 1
                   WHERE year = ", years[i],";")
  dbExecute(conn = dbconnection_f1, statement = script)
  
  ######## Start of Rounds Loop ############
  for(nr in 1:num_rounds){
    tryCatch({
      print(paste0("The season is ", years[i], " & the round number is ", nr," out of ", num_rounds))
      
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       current_round = ", nr, ", \n",
                       paste(tables_in_db_insert_order[-1], " = 0", sep = "", collapse = ",\n"), ",
                       completed_insertion = 0
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      source('API/API_access_pt2.R')
      
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       APIs = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
    
      ######## Circuits ########
      if(nrow(circuits) > 0){
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
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       circuits = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ############# Constructor Standings ##############
      if(nrow(constructorStandings) > 0){
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
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       constructor_standings = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ############## Constructor Results ################
      if(nrow(results) > 0){
        script <- paste0("INSERT INTO constructor_results (race_name, constructor_ID, driver_ID, points, number, position, position_Text, status, round)
                         VALUES ", paste("('",
                                        results.race$raceName, "', '",
                                        results$Constructor$constructorId, "', '",
                                        results$Driver$driverId, "', ",
                                        results$points, ", ",
                                        if_null_int(results$number), ", ",
                                        results$position, ", '",
                                        results$positionText, "', '",
                                        results$status, "', ",
                                        nr
                                        ,")", sep = "", collapse = ",\n"),";")
        dbExecute(conn = dbconnection_season, statement = script)
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       constructor_results = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ############### Constructors #################
      if(nrow(constructors) > 0){
        script <- paste0("INSERT INTO constructors (constructor_ID, constructor_name, nationality, round)
                         VALUES ", paste("('",
                                        constructors$constructorId, "', '",
                                        constructors$name, "', '",
                                        constructors$nationality, "', ",
                                        nr
                                        ,")", sep = "", collapse = ",\n"),";")
        dbExecute(conn = dbconnection_season, statement = script)
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       constructors = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ################ Driver Standings ###############
      if(nrow(driverStandings) > 0){
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
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       driver_standings = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ############### Drivers ##############
      if(nrow(drivers) > 0){
        script <- paste0("INSERT INTO drivers (driver_ID, number, code, first_name, last_name, DOB, nationality, round)
                         VALUES ", paste("('",
                                         drivers$driverId, "', ",
                                         if_null_int(drivers$permanentNumber), ", ",
                                         if_null_char(drivers$code), ", '",
                                         drivers$givenName, "', '",
                                         apostrophe_fix(drivers$familyName), "', '",
                                         drivers$dateOfBirth, "', '",
                                         drivers$nationality, "', ",
                                         nr
                                         ,")", sep = "", collapse = ",\n"),";")
        dbExecute(conn = dbconnection_season, statement = script)
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       drivers = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ############### Lap Times ################
      if(years[i] >= 1996){
        if(nrow(laps) > 0){
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
        script <- paste0("UPDATE table_insert_tracker
                       SET
                       lap_times = 1
                       WHERE year = ", years[i], ";")
        dbExecute(conn = dbconnection_f1, statement = script)
      } else{
        script <- paste0("UPDATE table_insert_tracker
                       SET
                       lap_times = NULL
                       WHERE year = ", years[i], ";")
        dbExecute(conn = dbconnection_f1, statement = script)
      }
      
      ########### Pit Stops #########
      if(years[i] >= 2012){
        if(nrow(pitstops) > 0){
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
        script <- paste0("UPDATE table_insert_tracker
                       SET
                       pit_stops = 1
                       WHERE year = ", years[i], ";")
        dbExecute(conn = dbconnection_f1, statement = script)
      } else{
        script <- paste0("UPDATE table_insert_tracker
                       SET
                       pit_stops = NULL
                       WHERE year = ", years[i], ";")
        dbExecute(conn = dbconnection_f1, statement = script)
      }
      
      ############## Qualifying #############
      if(nrow(qualifying) > 0){
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
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       qualifying = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ########### Races ############
      if(nrow(race) > 0){
        script <- paste0("INSERT INTO races (race_name, year, circuit_ID, date, time, round)
                         VALUES ", paste("('",
                                         race$raceName, "', ",
                                         years[i], ", '",
                                         race$Circuit$circuitId, "', '",
                                         race$date, "', ",
                                         if_null_char(race$time), ", ",
                                         nr
                                         ,")", sep = "", collapse = ",\n"),";")
        dbExecute(conn = dbconnection_season, statement = script)
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       races = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ########### Results #############
      if(nrow(results) > 0){
        script <- paste0("INSERT INTO results (race_name, driver_ID, constructor_ID, number, grid, position, position_Text, points, laps, time, milliseconds, fastest_Lap, `rank`, fastest_Lap_Time, fastest_Lap_Speed, fastest_Lap_Speed_Units, status, round)
                         VALUES ", paste("(",
                                         if_null_char(results.race$raceName), ", ",
                                         if_null_char(results$Driver$driverId), ", ",
                                         if_null_char(results$Constructor$constructorId), ", ",
                                         if_null_int(results$number), ", ",
                                         if_null_int(results$grid), ", ",
                                         if_null_int(results$position), ", ",
                                         if_null_char(results$positionText), ", ",
                                         if_null_int(results$points), ", ",
                                         if_null_int(results$laps), ", ",
                                         if_null_char(clean_nums(results$Time$time)), ", ",
                                         if_null_int(results$Time$millis), ", ",
                                         if_null_int(results$FastestLap$lap), ", ",
                                         if_null_int(results$FastestLap$rank), ", ",
                                         if_null_char(clean_nums(results$FastestLap$Time$time)), ", ",
                                         if_null_int(results$FastestLap$AverageSpeed$speed), ", ",
                                         if_null_char(results$FastestLap$AverageSpeed$units), ", ",
                                         if_null_char(results$status), ", ",
                                         nr
                                         ,")", sep = "", collapse = ",\n"),";")
        dbExecute(conn = dbconnection_season, statement = script)
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       results = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
      
      ############# Status ############
      if(nrow(status) > 0){
        script <- paste0("INSERT INTO status (status_ID, status, round)
                         VALUES ", paste("(",
                                         status$statusId, ", '",
                                         status$status, "', ",
                                         nr
                                         ,")", sep = "", collapse = ",\n"),";")
        dbExecute(conn = dbconnection_season, statement = script)
      }
      script <- paste0("UPDATE table_insert_tracker
                       SET
                       status = 1
                       WHERE year = ", years[i], ";")
      dbExecute(conn = dbconnection_f1, statement = script)
    }, error = function(e) {
      cat("Error occurred: ", conditionMessage(e), "\n")
      stop_loop <- TRUE
      truncate_current(i)
      break
    })
  }
  if(stop_loop){
    break
  }
  script <- paste0("UPDATE table_insert_tracker
                   SET
                   completed_insertion = 1
                   WHERE year = ", years[i], ";")
  dbExecute(conn = dbconnection_f1, statement = script)
}

dbKillConnections()

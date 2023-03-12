source('Connections/Master_connect.R')
rm(secrets)

f1_tables <- c('circuits',
               'constructor_results',
               'constructor_standings',
               'constructors',
               'driver_standings',
               'drivers',
               'lap_times',
               'pit_stops',
               'qualifying',
               'races',
               'results',
               'seasons',
               'status')

######## Import Data ###########

csv_to_SQL <- function(table_name){
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/', table_name, '.csv')), stringsAsFactors = FALSE)
  dbAppendTable(conn = dbconnection_master, name = paste0(table_name), value = df)
  print(paste0(table_name, " inserted"))
}

dbSendQuery(conn = dbconnection_master, "SET GLOBAL local_infile = true;")
tryCatch({
  for(i in 1:length(f1_tables)){
    csv_to_SQL(table_name = f1_tables[i])
  }
}, error = function(e){
  
  # basic_paste_structure_for_insert <- paste("(",,")", sep = "", collapse = ",\n")
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/', f1_tables[1], '.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO circuits (circuit_ID, circuit_name, circuit_abbr, locality, country, latitude, longitude)
                   VALUES ", paste("(",
                                    df$circuit_ID, ", '",
                                   df$circuit_name, "', '",
                                   df$circuit_abbr, "', '",
                                   df$locality, "', '",
                                   df$country, "', ",
                                   df$latitude, ", ",
                                   df$longitude
                                   ,")", sep = "", collapse = ",\n"),";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/seasons.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO seasons (year, num_rounds)
                 VALUES ", paste("(", 
                                 df$year, ", ",
                                 df$num_rounds
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/drivers.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO drivers (driver_ID, driver_abbr, number, code, first_name, last_name, DOB, nationality)
                 VALUES ", paste("(",
                                 df$driver_ID, ", ",
                                 if_null_char(df$driver_abbr), ", ",
                                 if_null_int(df$number), ", ",
                                 if_null_char(df$code), ", '",
                                 df$first_name, "', '",
                                 apostrophe_fix(df$last_name), "', '",
                                 df$DOB, "', '",
                                 df$nationality
                                 ,"')", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/constructors.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO constructors (constructor_ID, constructor_name, constructor_abbr, nationality)
                 VALUES ", paste("(",
                                  df$constructor_ID, ", '",
                                 df$constructor_name, "', '",
                                 df$constructor_abbr, "', '",
                                 df$nationality
                                 ,"')", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/status.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO status (status_ID, status)
                 VALUES ", paste("(",
                                 df$status_ID, ", '",
                                 df$status
                                 ,"')", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  ##### No need to insert id ########
  
  races <- data.frame(read.csv(file = paste0('csv_files_last_resort/races.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO races(race_ID, year, round, circuit_ID, race_name, date, time)
                 VALUES ", paste("(",
                                 races$race_ID, ", ",
                                 races$year, ", ",
                                 races$round, ", ",
                                 races$circuit_ID, ", ",
                                 if_null_char(races$race_name), ", ",
                                 if_null_char(races$date), ", ",
                                 if_null_char(races$time)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/constructor_results.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO constructor_results (constructor_Results_ID, race_ID, constructor_ID, driver_ID, points, number, position, position_Text, status_ID)
                 VALUES ", paste("(",
                                 if_null_int(df$constructor_results_ID), ", ",
                                 if_null_int(df$race_ID), ", ",
                                 if_null_int(df$constructor_ID), ", ",
                                 if_null_int(df$driver_ID), ", ",
                                 if_null_int(df$points), ", ",
                                 if_null_int(df$number), ", ",
                                 if_null_int(df$position), ", ",
                                 if_null_char(df$position_Text), ", ",
                                 if_null_int(df$status_ID)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/constructor_standings.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO constructor_standings (constructor_Standings_ID, race_ID, constructor_ID, points, position, position_Text, wins)
                 VALUES ", paste("(",
                                 if_null_int(df$constructor_standings_ID), ", ",
                                 if_null_int(df$race_ID), ", ",
                                 if_null_int(df$constructor_ID), ", ",
                                 if_null_int(df$points), ", ",
                                 if_null_int(df$position), ", ",
                                 if_null_char(df$position_Text), ", ",
                                 if_null_int(df$wins)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/driver_standings.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO driver_standings (driver_Standings_ID, race_ID, driver_ID, points, position, position_Text, wins, constructor_ID)
                 VALUES ", paste("(",
                                 if_null_int(df$driver_standings_ID), ", ",
                                 if_null_int(df$race_ID), ", ",
                                 if_null_int(df$driver_ID), ", ",
                                 if_null_int(df$points), ", ",
                                 if_null_int(df$position), ", ",
                                 if_null_char(df$position_Text), ", ",
                                 if_null_int(df$wins), ", ",
                                 if_null_int(df$constructor_ID)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  lap_times <- data.frame(read.csv(file = paste0('csv_files_last_resort/lap_times.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO lap_times (race_ID, driver_ID, lap, position, time)
                 VALUES ", paste("(",
                                 if_null_int(lap_times$race_ID), ", ",
                                 if_null_int(lap_times$driver_ID), ", ",
                                 if_null_int(lap_times$lap), ", ",
                                 if_null_int(lap_times$position), ", ",
                                 if_null_char(lap_times$time)
                                 ,")", sep = "", collapse = ',\n'), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  pit_stops <- data.frame(read.csv(file = paste0('csv_files_last_resort/pit_stops.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO pit_stops (race_ID, driver_ID, stop, lap, time, duration)
                 VALUES ", paste("(",
                                 if_null_int(pit_stops$race_ID), ", ",
                                 if_null_int(pit_stops$driver_ID), ", ",
                                 if_null_int(pit_stops$stop), ", ",
                                 if_null_int(pit_stops$lap), ", ",
                                 if_null_char(pit_stops$time), ", ",
                                 if_null_int(pit_stops$duration)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  qualifying <- data.frame(read.csv(file = paste0('csv_files_last_resort/qualifying.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO qualifying (qualify_ID, race_ID, driver_ID, constructor_ID, number, position, q1, q2, q3)
                 VALUES ", paste("(",
                                 if_null_int(qualifying$qualify_ID), ", ",
                                 if_null_int(qualifying$race_ID), ", ",
                                 if_null_int(qualifying$driver_ID), ", ",
                                 if_null_int(qualifying$constructor_ID), ", ",
                                 if_null_int(qualifying$number), ", ",
                                 if_null_int(qualifying$position), ", ",
                                 if_null_char(qualifying$q1), ", ",
                                 if_null_char(qualifying$q2), ", ",
                                 if_null_char(qualifying$q3)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
  
  results <- data.frame(read.csv(file = paste0('csv_files_last_resort/results.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO results (result_ID, race_ID, driver_ID, constructor_ID, number, grid, position, position_Text, points, laps, `time`, milliseconds, fastest_Lap, `rank`, fastest_Lap_Time, fastest_Lap_Speed, fastest_Lap_Speed_Units, status_ID)
                 VALUES ", paste("(",
                                 if_null_int(results$result_ID), ", ",
                                 if_null_int(results$race_ID), ", ",
                                 if_null_int(results$driver_ID), ", ",
                                 if_null_int(results$constructor_ID), ", ",
                                 if_null_int(results$number), ", ",
                                 if_null_int(results$grid), ", ",
                                 if_null_int(results$position), ", ",
                                 if_null_char(results$position_Text), ", ",
                                 if_null_int(results$points), ", ",
                                 if_null_int(results$laps), ", ",
                                 if_null_char(results$time), ", ",
                                 if_null_int(results$milliseconds), ", ",
                                 if_null_int(results$fastest_Lap), ", ",
                                 if_null_int(results$rank), ", ",
                                 if_null_char(results$fastest_Lap_Time), ", ",
                                 if_null_int(results$fastest_Lap_Speed), ", ",
                                 if_null_char(results$fastest_Lap_Speed_Units), ", ",
                                 if_null_int(results$status_ID)
                                 ,")", sep = "", collapse = ",\n"), ";")
  dbExecute(conn = dbconnection_master, statement = script)
})


dbKillConnections()

# Master/Data_load_master.R

source('Connections/Local_connect.R')
rm(secrets)

source('Connections/Master_connect.R')
rm(secrets)

source('Data_Cleaning_Tools.R')

######## Seasons #########
script <- paste0(paste("SELECT * FROM f1_", years, ".seasons", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY year;")
seasons <- dbGetQuery(conn = dbconnection_local, statement = script)

script <- paste0("INSERT INTO seasons (year, num_rounds)
                 VALUES ", paste("(", 
                                 seasons$year, ", ",
                                 seasons$num_rounds
                                   ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

print(paste0('Seasons loaded'))

##### Drivers ########
script <- paste0(paste("SELECT * FROM f1_", years, ".drivers", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
drivers <- dbGetQuery(conn = dbconnection_local, statement = script)
drivers <- drivers %>% select(-c(season, round))
drivers <- unique(drivers)
drivers <- drivers_cleaner(drivers)
rownames(drivers) <- NULL
drivers <- drivers %>% dplyr::rename('driver_abbr' = 'driver_ID')
drivers$driver_ID <- 1:nrow(drivers)
drivers <- drivers %>% dplyr::relocate(driver_ID, .before = driver_abbr)

script <- paste0("INSERT INTO drivers (driver_abbr, number, code, first_name, last_name, DOB, nationality)
                 VALUES ", paste("(",
                                 if_null_char(drivers$driver_abbr), ", ",
                                 if_null_int(drivers$number), ", ",
                                 if_null_char(drivers$code), ", '",
                                 drivers$first_name, "', '",
                                 apostrophe_fix(drivers$last_name), "', '",
                                 drivers$DOB, "', '",
                                 drivers$nationality
                                 ,"')", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

print(paste0('Drivers loaded'))

####### Constructors #########
script <- paste0(paste("SELECT * FROM f1_", years, ".constructors", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
constructors <- dbGetQuery(conn = dbconnection_local, statement = script)
constructors <- constructors %>% select(-c(season, round))
constructors <- unique(constructors)
rownames(constructors) <- NULL
constructors <- constructors %>% dplyr::rename('constructor_abbr' = 'constructor_ID')
constructors$constructor_ID <- 1:nrow(constructors)
constructors <- constructors %>% dplyr::relocate(constructor_ID, .before = constructor_abbr)

script <- paste0("INSERT INTO constructors (constructor_name, constructor_abbr, nationality)
                 VALUES ", paste("('",
                                  constructors$constructor_name, "', '",
                                  constructors$constructor_abbr, "', '",
                                  constructors$nationality
                                  ,"')", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

print(paste0('Constructors loaded'))

####### Circuits ######
script <- paste0(paste("SELECT * FROM f1_", years, ".circuits", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
circuits <- dbGetQuery(conn = dbconnection_local, statement = script)
circuits <- circuits %>% select(-c(season, round))
circuits <- unique(circuits)
circuits <- circuit_cleaner(circuits)
rownames(circuits) <- NULL
circuits <- circuits %>% dplyr::rename('circuit_abbr' = 'circuit_ID')
circuits$circuit_ID <- 1:nrow(circuits)
circuits <- circuits %>% dplyr::relocate(circuit_ID, .before = circuit_abbr)

script <- paste0("INSERT INTO circuits (circuit_name, circuit_abbr, locality, country, latitude, longitude)
                 VALUES ", paste("('",
                                 circuits$circuit_name, "', '",
                                 circuits$circuit_abbr, "', '",
                                 circuits$locality, "', '",
                                 circuits$country, "', ",
                                 circuits$latitude, ", ",
                                 circuits$longitude
                                 ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

print(paste0('Circuits loaded'))

####### Status ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".status", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY status_ID;")
status <- dbGetQuery(conn = dbconnection_local, statement = script)
status <- status %>% select(-c(season, round))
status <- unique(status)
rownames(status) <- NULL
status$status_ID <- 1:nrow(status)

script <- paste0("INSERT INTO status (status)
                 VALUES ", paste("('",
                                 status$status
                                 ,"')", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

print(paste0('Status loaded'))

###### Races ###########
script <- paste0(paste("SELECT * FROM f1_", years, ".races", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
races <- dbGetQuery(conn = dbconnection_local, statement = script)
races <- races %>% select(-c(year))
races <- merge(x = races,
               y = circuits  %>% select(c(circuit_ID, circuit_abbr)),
              by.x = 'circuit_ID',
              by.y = 'circuit_abbr',
              all.x = TRUE,
              all.y = FALSE,
              sort = FALSE)
races <- races %>% 
  select(-c(circuit_ID)) %>% 
  rename('circuit_ID' = 'circuit_ID.y') %>% 
  relocate(circuit_ID, .after = race_name)
races <- unique(races)
races <- races_cleaner(races)
races <- races[order(races$season, races$round),]
rownames(races) <- NULL
races$race_ID <- 1:nrow(races)
races <- races %>% dplyr::relocate(race_ID, .before = race_name)
rownames(races) <- NULL

script <- paste0("INSERT INTO races(race_ID, year, round, circuit_ID, race_name, date, time)
                 VALUES ", paste("(",
                                 races$race_ID, ", ",
                                 races$season, ", ",
                                 races$round, ", ",
                                 races$circuit_ID, ", ",
                                 if_null_char(races$race_name), ", ",
                                 if_null_char(races$date), ", ",
                                 if_null_char(races$time)
                                 ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

print(paste0('Races loaded'))

######### Constructor Results #########
script <- paste0(paste("SELECT * FROM f1_", years, ".constructor_results", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
constructor_results <- dbGetQuery(conn = dbconnection_local, statement = script)
# constructor_results <- constructor_results %>% select(-c(season, round))
constructor_results <- unique(constructor_results)
rownames(constructor_results) <- NULL
constructor_results <- merge(x = constructor_results,
            y = constructors %>% select(c(constructor_ID, constructor_abbr)),
            by.x = 'constructor_ID',
            by.y = 'constructor_abbr',
            all.x = TRUE,
            all.y = FALSE,
            sort = FALSE)
constructor_results <- constructor_results %>% 
  select(-c(constructor_ID)) %>%
  dplyr::rename('constructor_ID' = 'constructor_ID.y') %>%
  dplyr::relocate(constructor_ID, .before = driver_ID)
constructor_results <- merge(x = constructor_results,
                            y = drivers %>% select(c(driver_ID, driver_abbr)),
                            by.x = 'driver_ID',
                            by.y = 'driver_abbr',
                            all.x = TRUE,
                            all.y = FALSE,
                            sort = FALSE)
constructor_results <- constructor_results %>% 
  select(-c(driver_ID)) %>%
  dplyr::rename('driver_ID' = 'driver_ID.y') %>% 
  dplyr::relocate(driver_ID, .after = constructor_ID)
constructor_results <- merge(x = constructor_results,
                            y = status,
                            by.x = 'status',
                            by.y = 'status',
                            all.x = TRUE,
                            all.y = FALSE,
                            sort = FALSE)
constructor_results <- constructor_results %>% 
  select(-c(status)) %>% 
  dplyr::relocate(status_ID, .after = position_Text)
constructor_results <- merge(x = constructor_results,
                            y = races %>% select(c(race_ID, race_name, season, round)),
                            by.x = c('race_name', 'season', 'round'),
                            by.y = c('race_name', 'season', 'round'),
                            all.x = TRUE,
                            all.y = FALSE,
                            sort = FALSE)
constructor_results <- constructor_results %>% 
  select(-c(race_name, season, round)) %>%
  dplyr::relocate(race_ID, .before = constructor_ID)
constructor_results <- constructor_results[order(constructor_results$race_ID, constructor_results$constructor_ID),]
rownames(constructor_results) <- NULL
constructor_results$constructor_results_ID <- 1:nrow(constructor_results)
constructor_results <- constructor_results %>% dplyr::relocate(constructor_results_ID, .before = race_ID)

script <- paste0("INSERT INTO constructor_results (constructor_Results_ID, race_ID, constructor_ID, driver_ID, points, number, position, position_Text, status_ID)
                 VALUES ", paste("(",
                                 if_null_int(constructor_results$constructor_results_ID), ", ",
                                 if_null_int(constructor_results$race_ID), ", ",
                                 if_null_int(constructor_results$constructor_ID), ", ",
                                 if_null_int(constructor_results$driver_ID), ", ",
                                 if_null_int(constructor_results$points), ", ",
                                 if_null_int(constructor_results$number), ", ",
                                 if_null_int(constructor_results$position), ", ",
                                 if_null_char(constructor_results$position_Text), ", ",
                                 if_null_int(constructor_results$status_ID)
                                 ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

rm(constructor_results)

print(paste0('Constructor Results loaded'))

########## Constructor Standings ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".constructor_standings", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
constructor_standings <- dbGetQuery(conn = dbconnection_local, statement = script)
constructor_standings <- unique(constructor_standings)
rownames(constructor_standings) <- NULL
constructor_standings <- merge(x = constructor_standings,
                                y = constructors %>% select(c(constructor_ID, constructor_abbr)),
                                by.x = 'constructor_ID',
                                by.y = 'constructor_abbr',
                                all.x = TRUE,
                                all.y = FALSE,
                                sort = FALSE)
constructor_standings <- constructor_standings %>% 
  select(-c(constructor_ID)) %>% 
  dplyr::rename('constructor_ID' = 'constructor_ID.y') %>% 
  dplyr::relocate(constructor_ID, .before = points)
constructor_standings <- merge(x = constructor_standings,
                               y = races %>% select(c(race_ID, season, round)),
                               by.x = c('season', 'round'),
                               by.y = c('season', 'round'),
                               all.x = T,
                               all.y = F,
                               sort = F)
constructor_standings <- constructor_standings %>% dplyr::relocate(race_ID, .before = constructor_ID)
constructor_standings <- constructor_standings[order(constructor_standings$season, constructor_standings$round, constructor_standings$constructor_ID),]
rownames(constructor_standings) <- NULL
constructor_standings <- constructor_standings %>% select(-c(season, round))
constructor_standings$constructor_standings_ID <- 1:nrow(constructor_standings)
constructor_standings <- constructor_standings %>% dplyr::relocate(constructor_standings_ID, .before = constructor_ID)
  
script <- paste0("INSERT INTO constructor_standings (constructor_Standings_ID, race_ID, constructor_ID, points, position, position_Text, wins)
                 VALUES ", paste("(",
                                 if_null_int(constructor_standings$constructor_standings_ID), ", ",
                                 if_null_int(constructor_standings$race_ID), ", ",
                                 if_null_int(constructor_standings$constructor_ID), ", ",
                                 if_null_int(constructor_standings$points), ", ",
                                 if_null_int(constructor_standings$position), ", ",
                                 if_null_char(constructor_standings$position_Text), ", ",
                                 if_null_int(constructor_standings$wins)
                                 ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

rm(constructor_standings)

print(paste0('Constructor Standings loaded'))

######## Driver Standings ############
script <- paste0(paste("SELECT * FROM f1_", years, ".driver_standings", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
driver_standings <- dbGetQuery(conn = dbconnection_local, statement = script)
driver_standings <- unique(driver_standings)
rownames(driver_standings) <- NULL
driver_standings <- merge(x = driver_standings,
                          y = drivers %>% select(c(driver_ID, driver_abbr)),
                          by.x = 'driver_ID',
                          by.y = 'driver_abbr',
                          all.x = TRUE,
                          all.y = FALSE,
                          sort = FALSE)
driver_standings <- driver_standings %>% 
  select(-c(driver_ID)) %>% 
  dplyr::rename('driver_ID' = 'driver_ID.y') %>%
  dplyr::relocate(driver_ID, .before = points)
driver_standings <- merge(x = driver_standings,
                          y = constructors %>% select(c(constructor_ID, constructor_abbr)),
                          by.x = 'constructor_ID',
                          by.y = 'constructor_abbr',
                          all.x = TRUE,
                          all.y = FALSE,
                          sort = FALSE)
driver_standings <- driver_standings %>% 
  select(-c(constructor_ID)) %>% 
  dplyr::rename('constructor_ID' = 'constructor_ID.y') %>% 
  dplyr::relocate(constructor_ID, .after = wins)
driver_standings <- merge(x = driver_standings,
                          y = races %>% select(c(race_ID, season, round)),
                          by.x = c('season', 'round'),
                          by.y = c('season', 'round'),
                          all.x = TRUE,
                          all.y = FALSE,
                          sort = FALSE)
driver_standings <- driver_standings[order(driver_standings$season, driver_standings$round),]
driver_standings <- driver_standings %>% 
  select(-c(season, round)) %>% 
  dplyr::relocate(race_ID, .before = driver_ID)
rownames(driver_standings) <- NULL
driver_standings$driver_standings_ID <- 1:nrow(driver_standings)
driver_standings <- driver_standings %>% dplyr::relocate(driver_standings_ID, .before = race_ID)

script <- paste0("INSERT INTO driver_standings (driver_Standings_ID, race_ID, driver_ID, points, position, position_Text, wins, constructor_ID)
                 VALUES ", paste("(",
                                 if_null_int(driver_standings$driver_standings_ID), ", ",
                                 if_null_int(driver_standings$race_ID), ", ",
                                 if_null_int(driver_standings$driver_ID), ", ",
                                 if_null_int(driver_standings$points), ", ",
                                 if_null_int(driver_standings$position), ", ",
                                 if_null_char(driver_standings$position_Text), ", ",
                                 if_null_int(driver_standings$wins), ", ",
                                 if_null_int(driver_standings$constructor_ID)
                                 ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

rm(driver_standings)

print(paste0('Driver Standings loaded'))

######### Lap Times ###########
script <- paste0(paste("SELECT * FROM f1_", years, ".lap_times", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
lap_times <- dbGetQuery(conn = dbconnection_local, statement = script)
lap_times <- unique(lap_times)
rownames(lap_times) <- NULL
lap_times <- merge(x = lap_times,
                   y = drivers %>% select(c(driver_ID, driver_abbr)),
                   by.x = 'driver_ID',
                   by.y = 'driver_abbr',
                   all.x = TRUE,
                   all.y = FALSE,
                   sort = FALSE)
lap_times <- lap_times %>% 
  select(-c(driver_ID)) %>%
  dplyr::rename('driver_ID' = 'driver_ID.y') %>% 
  dplyr::relocate(driver_ID, .before = lap)
lap_times <- merge(x = lap_times,
                   y = races %>% select(race_ID, race_name, season, round),
                   by.x = c('season', 'round', 'race_name'),
                   by.y = c('season', 'round', 'race_name'),
                   all.x = TRUE,
                   all.y = FALSE,
                   sort = FALSE)
lap_times <- lap_times[order(lap_times$season, lap_times$round, lap_times$race_name),]
lap_times <- lap_times %>% 
  select(-c(season, round, race_name)) %>% 
  dplyr::relocate(race_ID, .before = driver_ID)

script <- paste0("INSERT INTO lap_times (race_ID, driver_ID, lap, position, time)
                 VALUES ", paste("(",
                                 if_null_int(lap_times$race_ID), ", ",
                                 if_null_int(lap_times$driver_ID), ", ",
                                 if_null_int(lap_times$lap), ", ",
                                 if_null_int(lap_times$position), ", ",
                                 if_null_char(lap_times$time)
                                 ,")", sep = "", collapse = ',\n'), ";")
dbExecute(conn = dbconnection_master, statement = script)

rm(lap_times)

print(paste0('Lap Times loaded'))

######## Pit Stops ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".pit_stops", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
pit_stops <- dbGetQuery(conn = dbconnection_local, statement = script)
pit_stops <- unique(pit_stops)
rownames(pit_stops) <- NULL
pit_stops <- merge(x = pit_stops,
                   y = drivers %>% select(c(driver_ID, driver_abbr)),
                   by.x = 'driver_ID',
                   by.y = 'driver_abbr',
                   all.x = TRUE,
                   all.y = FALSE,
                   sort = FALSE)
pit_stops <- pit_stops %>% 
  select(-c(driver_ID)) %>% 
  dplyr::rename('driver_ID' = 'driver_ID.y') %>% 
  dplyr::relocate(driver_ID, .before = stop)
pit_stops$race_name[pit_stops$season == '2021' & pit_stops$round == '12'] <- races$race_name[races$season == '2021' & races$round == '12']
for(se in 2023:2024){
  for(round_num in 1:max(pit_stops$round[pit_stops$season == se])){
    pit_stops$race_name[pit_stops$season == se & pit_stops$round == round_num] <- races$race_name[races$season == se & races$round == round_num]
  }
}
pit_stops <- merge(x = pit_stops,
                   y = races %>% select(race_ID, race_name, season, round),
                   by.x = c('season', 'round', 'race_name'),
                   by.y = c('season', 'round', 'race_name'),
                   all.x = TRUE,
                   all.y = FALSE,
                   sort = FALSE)
pit_stops <- pit_stops[order(pit_stops$season, pit_stops$round, pit_stops$race_name),]
rownames(pit_stops) <- NULL
pit_stops <- pit_stops %>%
  select(-c(season, round, race_name)) %>%
  dplyr::relocate(race_ID, .before = driver_ID)

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

rm(pit_stops)

print(paste0('Pit Stops loaded'))

######## Qualifying ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".qualifying", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
qualifying <- dbGetQuery(conn = dbconnection_local, statement = script)
rownames(qualifying) <- NULL
qualifying <- merge(x = qualifying,
                    y = drivers %>% select(c(driver_ID, driver_abbr)),
                    by.x = 'driver_ID',
                    by.y = 'driver_abbr',
                    all.x = TRUE,
                    all.y = FALSE,
                    sort = FALSE)
qualifying <- qualifying %>% select(-c(driver_ID)) %>% 
  dplyr::rename('driver_ID' = 'driver_ID.y') %>% 
  dplyr::relocate(driver_ID, .before = constructor_ID)
qualifying <- merge(x = qualifying,
                    y = constructors %>% select(c(constructor_ID, constructor_abbr)),
                    by.x = 'constructor_ID',
                    by.y = 'constructor_abbr',
                    all.x = TRUE,
                    all.y = F,
                    sort = F)
qualifying <- qualifying %>% 
  select(-c(constructor_ID)) %>% 
  dplyr::rename('constructor_ID' = 'constructor_ID.y') %>% 
  dplyr::relocate(constructor_ID, .before = number)
qualifying <- merge(x = qualifying,
                    y = races %>% select(-c(circuit_ID, date, time)),
                    by.x = c('season', 'round', 'race_name'),
                    by.y = c('season', 'round', 'race_name'),
                    all.x = T,
                    all.y = F,
                    sort = F)
qualifying <- qualifying[order(qualifying$season, qualifying$round, qualifying$race_ID),]
rownames(qualifying) <- NULL
qualifying <- qualifying %>% 
  select(-c(season, round, race_name)) %>% 
  dplyr::relocate(race_ID, .before = driver_ID)
qualifying$qualify_ID <- 1:nrow(qualifying)
qualifying <- qualifying %>% dplyr::relocate(qualify_ID, .before = race_ID)

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

rm(qualifying)

print(paste0('Qualifying loaded'))

######### Results ########
script <- paste0(paste("SELECT * FROM f1_", years, ".results", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
results <- dbGetQuery(conn = dbconnection_local, statement = script)
rownames(results) <- NULL
results <- merge(x = results,
                    y = drivers %>% select(c(driver_ID, driver_abbr)),
                    by.x = 'driver_ID',
                    by.y = 'driver_abbr',
                    all.x = T,
                    all.y = F,
                    sort = F)
results <- results %>% 
  select(-c(driver_ID)) %>% 
  dplyr::rename('driver_ID' = 'driver_ID.y') %>% 
  dplyr::relocate(driver_ID, .before = constructor_ID)
results <- merge(x = results,
                  y = constructors %>% select(c(constructor_ID, constructor_abbr)),
                  by.x = 'constructor_ID',
                  by.y = 'constructor_abbr',
                  all.x = T,
                  all.y = F,
                  sort = F)
results <- results %>%
  select(-c(constructor_ID)) %>% 
  dplyr::rename('constructor_ID' = 'constructor_ID.y') %>% 
  dplyr::relocate(constructor_ID, .before = number)
results <- merge(x = results,
                 y = status,
                 by.x = 'status',
                 by.y = 'status',
                 all.x = T,
                 all.y = F,
                 sort = F)
results <- results %>% 
  select(-c(status)) %>% 
  dplyr::relocate(status_ID, .after = fastest_Lap_Speed_Units)
results <- merge(x = results,
                  y = races %>% select(-c(circuit_ID, date, time)),
                  by.x = c('season', 'round', 'race_name'),
                  by.y = c('season', 'round', 'race_name'),
                  all.x = T,
                  all.y = F,
                  sort = F)
results <- results[order(results$season, results$round, results$position),]
results <- results %>% 
  select(-c(season, round, race_name)) %>% 
  dplyr::relocate(race_ID, .before = driver_ID)
rownames(results) <- NULL
results <- results_time_cleaner(results)
results$result_ID <- 1:nrow(results)
results <- results %>% dplyr::relocate(result_ID, .before = race_ID)

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

rm(results)

print(paste0('Results loaded'))

dbKillConnections()

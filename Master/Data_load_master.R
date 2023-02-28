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

##### Drivers ########
script <- paste0(paste("SELECT * FROM f1_", years, ".drivers", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
drivers <- dbGetQuery(conn = dbconnection_local, statement = script)
drivers <- drivers %>% select(-c(season, round))
drivers <- unique(drivers)
rownames(drivers) <- NULL

script <- paste0("INSERT INTO drivers (number, code, first_name, last_name, DOB, nationality)
                 VALUES ", paste("(",
                                 if_null_int(drivers$number), ", ",
                                 if_null_char(drivers$code), ", '",
                                 drivers$first_name, "', '",
                                 apostrophe_fix(drivers$last_name), "', '",
                                 drivers$DOB, "', '",
                                 drivers$nationality
                                 ,"')", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

####### Constructors #########
script <- paste0(paste("SELECT * FROM f1_", years, ".constructors", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
constructors <- dbGetQuery(conn = dbconnection_local, statement = script)
constructors <- constructors %>% select(-c(season, round))
constructors <- unique(constructors)
rownames(constructors) <- NULL

script <- paste0("INSERT INTO constructors (constructor_name, nationality)
                 VALUES ", paste("('",
                                  constructors$constructor_name, "', '",
                                  constructors$nationality
                                  ,"')", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

####### Circuits ######
script <- paste0(paste("SELECT * FROM f1_", years, ".circuits", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
circuits <- dbGetQuery(conn = dbconnection_local, statement = script)
circuits <- circuits %>% select(-c(season, round))
circuits <- unique(circuits)
rownames(circuits) <- NULL

script <- paste0("INSERT INTO circuits (circuit_name, locality, country, latitude, longitude)
                 VALUES ", paste("('",
                                 circuits$circuit_name, "', '",
                                 circuits$locality, "', '",
                                 circuits$country, "', ",
                                 circuits$latitude, ", ",
                                 circuits$longitude
                                 ,")", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

####### Status ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".status", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY status_ID;")
status <- dbGetQuery(conn = dbconnection_local, statement = script)
status <- status %>% select(-c(season, round))
status <- unique(status)
rownames(status) <- NULL

script <- paste0("INSERT INTO status (status)
                 VALUES ", paste("('",
                                 status$status
                                 ,"')", sep = "", collapse = ",\n"), ";")
dbExecute(conn = dbconnection_master, statement = script)

###### Races ###########
script <- paste0(paste("SELECT * FROM f1_", years, ".races", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
races <- dbGetQuery(conn = dbconnection_local, statement = script)
races <- races %>% select(-c(year))
races <- unique(races)

######### Constructor Results #########
script <- paste0(paste("SELECT * FROM f1_", years, ".constructor_results", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
constructor_results <- dbGetQuery(conn = dbconnection_local, statement = script)
# constructor_results <- constructor_results %>% select(-c(season, round))
constructor_results <- unique(constructor_results)
rownames(constructor_results) <- NULL

########## Constructor Standings ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".constructor_standings", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
constructor_standings <- dbGetQuery(conn = dbconnection_local, statement = script)
constructor_standings <- unique(constructor_standings)
rownames(constructor_standings) <- NULL

######## Driver Standings ############
script <- paste0(paste("SELECT * FROM f1_", years, ".driver_standings", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
driver_standings <- dbGetQuery(conn = dbconnection_local, statement = script)
driver_standings <- unique(driver_standings)
rownames(driver_standings) <- NULL

######### Lap Times ###########
script <- paste0(paste("SELECT * FROM f1_", years, ".lap_times", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
lap_times <- dbGetQuery(conn = dbconnection_local, statement = script)
lap_times <- unique(lap_times)
rownames(lap_times) <- NULL

######## Pit Stops ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".pit_stops", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
pit_stops <- dbGetQuery(conn = dbconnection_local, statement = script)
pit_stops <- unique(pit_stops)
rownames(pit_stops) <- NULL

######## Qualifying ##########
script <- paste0(paste("SELECT * FROM f1_", years, ".qualifying", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
qualifying <- dbGetQuery(conn = dbconnection_local, statement = script)
rownames(qualifying) <- NULL

######### Results ########
script <- paste0(paste("SELECT * FROM f1_", years, ".results", sep = "", collapse = "\n UNION \n"), "
                 ORDER BY season;")
results <- dbGetQuery(conn = dbconnection_local, statement = script)
rownames(results) <- NULL

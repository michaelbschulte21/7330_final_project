# Main_Task_pt2.R

truncate_master <- function(){
  source('Connections/Master_connect.R')
  script <- paste0("TRUNCATE TABLE Circuits;")
  dbExecute(conn = dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Driver_Standings;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Drivers;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Lap_Times;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Races;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Results;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Constructors;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Qualifying;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Pit_Stops;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Constructor_Standings;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Constructor_Results;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Seasons;")
  dbExecute(conn =  dbconnection_master, statement = script)
  script <- paste0("TRUNCATE TABLE Status;")
  dbExecute(conn =  dbconnection_master, statement = script)
  dbKillConnections()
  print(paste0('Truncated f1_master'))
}

schema_nuke_master <- function(){
  source('Connections/Master_connect.R')
  script <- paste0("DROP SCHEMA IF EXISTS f1_master;")
  dbExecute(conn = dbconnection_master, statement = script)
  dbKillConnections()
  print(paste0('f1_master has been nuked'))
}


source('API/API_access_pt1.R')

source('Connections/Local_connect.R')
rm(secrets)

script <- paste0("SELECT SCHEMA_NAME
                    FROM INFORMATION_SCHEMA.SCHEMATA
                    WHERE SCHEMA_NAME = 'f1_master';")
flag <- dbGetQuery(conn = dbconnection_local, statement = script)

flag <- nrow(flag) == 0

dbKillConnections()

if(flag){
  ######## Create Schema & Tables #########
  
  source('Master/Schema_Creator_master.R')
}

source('Connections/Local_connect.R')
rm(secrets)

script <- paste0("SELECT SCHEMA_NAME
                  FROM INFORMATION_SCHEMA.SCHEMATA
                 WHERE ",paste("SCHEMA_NAME = 'f1_", years,"'", sep = "", collapse = '\n OR '),";")
flag_years <- dbGetQuery(conn = dbconnection_local, statement = script)
flag_years_all <- nrow(flag_years) == length(years)
flag_years_multi <- flag_years_all

print(paste0("Schema for all years present = ", flag_years_all))

if(!flag_years_all){
  flag_years_multi <- nrow(flag_years) > 1 & paste0('f1_', max(years)) %in% flag_years$SCHEMA_NAME
  print(paste0("Schema for multiple years present = ", flag_years_multi))
}

script <- paste0("SELECT SCHEMA_NAME
                  FROM INFORMATION_SCHEMA.SCHEMATA
                 WHERE ",paste("SCHEMA_NAME = 'f1_", start_year:max(years),"'", sep = "", collapse = '\n OR '),";")
flag_years_max <- dbGetQuery(conn = dbconnection_local, statement = script)
flag_years_max <- nrow(flag_years_max) == 1 & flag_years_max$SCHEMA_NAME[1] == paste0('f1_', max(years))
print(paste0("Schema for max year only = ", flag_years_max))

dbKillConnections()

if(flag_years_all | flag_years_multi){
  source('Master/Data_load_master.R')
} else if(flag_years_max){
  source('Master/Data_upgrader_master.R')
}

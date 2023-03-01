# Main_Task_pt2.R

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
  
  dbKillConnections()
}

truncate_master <- function(){
  source('Connections/Master_connect.R')
  rm(secrets)
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
  rm(secrets)
  script <- paste0("DROP SCHEMA IF EXISTS f1_master;")
  dbExecute(conn = dbconnection_master, statement = script)
  dbKillConnections()
  print(paste0('f1_master has been nuked'))
}

source('Master/Data_load_master.R')
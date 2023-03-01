# Main_Task.R

###### Load Libraries #######

source('Libraries.R')

######### Function to kill all connections #########

dbKillConnections <- function(){
  all_cons <- dbListConnections(RMySQL::MySQL())
  print(all_cons)
  for(con in all_cons){
    dbDisconnect(conn = con)
  }
  print(paste0(length(all_cons), " connections killed"))
}

# Drop all schema
schema_nuke <- function(){
  all_schema <- TRUE
  source('Schema_dropper.R')
  print('All existing schemas have been nuked')
}

schema_nuke_years <- function(){
  all_schema <- FALSE
  source('Schema_dropper.R')
  print('All existing individual years schemas have been nuked')
}

truncate_current <- function(i){
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
  script <- paste0("TRUNCATE TABLE Seasons;")
  dbExecute(conn = dbconnection_season, statement = script)
  script <- paste0("TRUNCATE TABLE Status;")
  dbExecute(conn = dbconnection_season, statement = script)
  print(paste0('Truncated season = ', years[i]))
}

truncate_all <- function(){
  for(i in 1:length(years)){
    source('Connections/Season_connect.R')
    truncate_current(i)
    dbKillConnections()
  }
  source('Connections/F1_connect.R')
  script <- paste0("TRUNCATE TABLE seasons;")
  dbExecute(conn = dbconnection_f1, statement = script)
  script <- paste0("TRUNCATE TABLE table_insert_tracker;")
  dbExecute(conn = dbconnection_f1, statement = script)
  print(paste0("formula1 truncated"))
  dbKillConnections()
}

########### Create formula1 schema ###########

source('Connections/Local_connect.R')
rm(secrets)

script <- paste0("SELECT SCHEMA_NAME
                    FROM INFORMATION_SCHEMA.SCHEMATA
                    WHERE SCHEMA_NAME = 'formula1'")
flag <- dbGetQuery(conn = dbconnection_local, statement = script)

flag <- nrow(flag) == 0

dbKillConnections()

if(flag){
  source('Schema_Creator_formula1.R')
}

source('API/API_access_pt1.R')

######## Check if schema exists ########

for(i in 1:length(years)){
  print(paste0(years[i]))
  source('Connections/Local_connect.R')
  rm(secrets)
  
  script <- paste0("SELECT SCHEMA_NAME
                    FROM INFORMATION_SCHEMA.SCHEMATA
                    WHERE SCHEMA_NAME = 'f1_", years[i],"'")
  flag <- dbGetQuery(conn = dbconnection_local, statement = script)
  
  flag <- nrow(flag) == 0
  
  dbKillConnections()
  
  if(flag){
    ######## Create Schema & Tables #########
    
    source('Schema_Creator.R')
    
    dbKillConnections()
  }
}

####### Load data into tables ##########

source('Data_load.R')

########## Normalize the data ###########

source('Main_Task_pt2.R')

######## Drop not normalized data ########

# schema_nuke_years()
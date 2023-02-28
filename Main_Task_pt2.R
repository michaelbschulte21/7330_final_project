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

source('Master/Data_load_master.R')
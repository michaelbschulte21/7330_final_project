# Main_Task.R

###### Load Libraries #######

source('Libraries.R')

######### Function to kill all connections #########

dbKillConnections <- function(){
  all_cons <- dbListConnections(MySQL())
  for(con in all_cons){
    dbDisconnect(conn = con)
  }
}

######## Check if schema exists ########

source('Connections/Local_connect.R')
rm(secrets)

script <- paste0("SELECT SCHEMA_NAME
                  FROM INFORMATION_SCHEMA.SCHEMATA
                  WHERE SCHEMA_NAME = 'formula1'")
flag <- dbGetQuery(conn = dbconnection_local, statement = script)

flag <- nrow(flag) == 0

dbKillConnections()

if(flag){
  ######## Create Schema & Tables #########
  
  source('Schema_Creator.R')
  
  dbKillConnections()
}

####### Load data into tables ##########

source('Data_load.R')

dbKillConnections()

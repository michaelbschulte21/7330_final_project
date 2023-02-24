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

drop_all_schema <- function(){
  source('Schema_dropper.R')
  print('All existing schemas have been nuked')
}

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

dbKillConnections()

# Schema_Dropper/Schema_dropper_years.R

source('Connections/Local_connect.R')
rm(secrets)

source('API/API_access_pt1.R')

######## Check if schema exists ########

for(i in 1:length(years)){
  print(years[i])
  ############ Drop Schema #########
  script <- paste0('DROP SCHEMA IF EXISTS f1_', years[i],';')
  dbExecute(conn = dbconnection_local, statement = script)
}

dbKillConnections()
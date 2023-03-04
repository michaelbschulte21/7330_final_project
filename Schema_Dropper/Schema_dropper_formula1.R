# Schema_Dropper/Schema_dropper_formula1.R

source('Connections/Local_connect.R')
rm(secrets)

print('formula1')
script <- paste0('DROP SCHEMA IF EXISTS formula1;')
dbExecute(conn = dbconnection_local, statement = script)

dbKillConnections()

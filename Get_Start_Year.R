# Get_Start_Year.R

source('Connections/F1_connect.R')
rm(secrets)

require(dplyr)

script <- paste0("SELECT max(year) AS max_year
                 FROM table_insert_tracker
                 WHERE completed_insertion = '1';")
start_year <- dbGetQuery(conn = dbconnection_f1, statement = script)
start_year <- start_year$max_year
if(is.na(start_year)){
  start_year <- 1
} else if(start_year != max(years)){
  start_year <- length(years) - (as.integer(max(years)) - start_year) + 1
} else if(start_year == max(years)){
  start_year <- length(years)
  script <- paste0("DELETE FROM Seasons
                   WHERE year = ", max(years),";")
  dbExecute(conn = dbconnection_f1, statement = script)
  script <- paste0("DELETE FROM table_insert_tracker
                   WHERE year = ", max(years),";")
  dbExecute(conn = dbconnection_f1, statement = script)
  i <- length(years)
  source('Connections/Season_connect.R')
  truncate_current(i)
}

print(paste0("start_year = ", start_year, " which is year = ", years[start_year]))

dbKillConnections()
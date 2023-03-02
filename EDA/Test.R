# EDA/Test.R

source('Connections/Master_connect.R')
rm(secrets)

get_year <- 2013

script <- paste0("SELECT *
                 FROM races
                 WHERE year = ", get_year, ";")
# use cat(script) to see a print out of script

get_year <- c(2013, 1998, 2015)

script <- paste0("SELECT *
                 FROM races
                 WHERE ", paste("year = ", get_year, "", sep = "", collapse = "\n OR "), ";")
# dbExecute(conn, statement) Probably won't use this
df <- dbGetQuery(conn = dbconnection_master, statement = script)


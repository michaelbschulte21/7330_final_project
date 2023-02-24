# Schema_Creator_formula1.R
# Creates formula1 schema to monitor database & data the pertains to all schema

source('Connections/Local_connect.R')
rm(secrets)

############ Create Schema #########
script <- paste0('CREATE SCHEMA IF NOT EXISTS formula1;')
dbExecute(conn = dbconnection_local, statement = script)

# Figure out what tables need to be added
  # Need seasons/years table that includes number of rounds in a season (that have been recorded)
source('Connections/F1_connect.R')

script <- paste0("CREATE TABLE IF NOT EXISTS Seasons (
                  year INT NOT NULL,
                  num_rounds INT DEFAULT 0
                  );")
dbExecute(conn = dbconnection_f1, statement = script)
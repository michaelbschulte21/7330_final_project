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
rm(secrets)

script <- paste0("CREATE TABLE IF NOT EXISTS seasons (
                  year INT NOT NULL,
                  num_rounds INT DEFAULT 0
                  );")
dbExecute(conn = dbconnection_f1, statement = script)

tables_in_db_insert_order <- c("seasons"
                           , "APIs"
                           , "circuits"
                           , "constructor_standings"
                           , "constructor_results"
                           , "constructors"
                           , "driver_standings"
                           , "drivers"
                           , "lap_times"
                           , "pit_stops"
                           , "qualifying"
                           , "races"
                           , "results"
                           , "status")
script <- paste0("CREATE TABLE IF NOT EXISTS table_insert_tracker (
                 year INT NOT NULL,
                 num_rounds INT DEFAULT 0,
                 current_round INT DEFAULT 0,",
                 paste(tables_in_db_insert_order, " INT DEFAULT 0", sep = "", collapse = ",\n"), ",
                 start_time TIME(3) NULL,
                 end_time TIME(3) NULL,
                 completed_insertion INT DEFAULT 0
                 );")
dbExecute(conn = dbconnection_f1, statement = script)

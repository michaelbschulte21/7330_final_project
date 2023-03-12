source('Connections/Master_connect.R')
rm(secrets)

f1_tables <- c('circuits',
               'constructor_results',
               'constructor_standings',
               'constructors',
               'driver_standings',
               'drivers',
               'lap_times',
               'pit_stops',
               'qualifying',
               'races',
               'results',
               'seasons',
               'status')

######## Import Data ###########

csv_to_SQL <- function(table_name){
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/', table_name, '.csv')), stringsAsFactors = FALSE)
  dbWriteTable(conn = dbconnection_master, name = paste0(table_name), value = df, row.names = FALSE, append = TRUE)
  print(paste0(table_name, " inserted"))
}

dbSendQuery(conn = dbconnection_master, "SET GLOBAL local_infile = true;")

for(i in 1:length(f1_tables)){
  csv_to_SQL(table_name = f1_tables[i])
}

dbKillConnections()

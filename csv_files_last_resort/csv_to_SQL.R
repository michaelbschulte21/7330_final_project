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
  dbAppendTable(conn = dbconnection_master, name = paste0(table_name), value = df)
  print(paste0(table_name, " inserted"))
}

dbSendQuery(conn = dbconnection_master, "SET GLOBAL local_infile = true;")
tryCatch({
  for(i in 1:length(f1_tables)){
    csv_to_SQL(table_name = f1_tables[i])
  }
}, error = function(e){
  
  # basic_paste_structure_for_insert <- paste("(",,")", sep = "", collapse = ",\n")
  
  df <- data.frame(read.csv(file = paste0('csv_files_last_resort/', f1_tables[1], '.csv')), stringsAsFactors = FALSE)
  script <- paste0("INSERT INTO circuits (circuit_ID, circuit_name, circuit_abbr, locality, country, latitude, longitude)
                   VALUES ", paste("(",
                                    df$circuit_ID, ", '",
                                   df$circuit_name, "', '",
                                   df$circuit_abbr, "', '",
                                   df$locality, "', '",
                                   df$country, "', ",
                                   df$latitude, ", ",
                                   df$longitude
                                   ,")", sep = "", collapse = ",\n"),";")
  dbExecute(conn = dbconnection_master, statement = script)
})


dbKillConnections()

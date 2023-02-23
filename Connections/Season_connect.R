# Connections/Season_connect.R

source('secrets.R')
dbconnection_season <- RMySQL::dbConnect(RMySQL::MySQL(),
                                     dbname = paste0('f1_', years[i]),
                                     driver = "SQL Server",
                                     server = secrets$local_server,
                                     port = secrets$local_port,
                                     user = secrets$local_uid,
                                     password = secrets$local_pwd)
# Connections/F1_connect.R

source('secrets.R')
dbconnection_f1 <- RMySQL::dbConnect(RMySQL::MySQL(),
                                        dbname = 'formula1',
                                        driver = "SQL Server",
                                        server = secrets$local_server,
                                        port = secrets$local_port,
                                        user = secrets$local_uid,
                                        password = secrets$local_pwd)
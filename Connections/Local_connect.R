# Connections/Local_connect.R

source('secrets.R')
dbconnection_local <- RMySQL::dbConnect(RMySQL::MySQL(),
                                        driver = "SQL Server",
                                        server = secrets$local_server,
                                        port = secrets$local_port,
                                        user = secrets$local_uid,
                                        password = secrets$local_pwd)

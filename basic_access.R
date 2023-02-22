library(odbc)
library(RSQLite)
library(RMySQL)
library(tidyverse)
library(DBI)
library(sqldf)

source('secrets.R')
dbconnection_local <- RMySQL::dbConnect(RMySQL::MySQL(),
                                        dbname = 'salesordersexampletest',
                                        driver = "SQL Server",
                                        server = secrets$local_server,
                                        port = secrets$local_port,
                                        user = secrets$local_uid,
                                        password = secrets$local_pwd)
rm(secrets)

script <- paste0('SELECT CONCAT(e.EmpFirstName, " ", e.EmpLastName) AS Employee_Name,
                  CONCAT(c.CustFirstName, " ", c.CustLastName) AS Customer_Name
                  FROM employees e
                  JOIN orders o ON o.EmployeeID = e.EmployeeID
                  JOIN customers c ON c.CustomerID = o.CustomerID;')
employee.name_customer.name <- dbGetQuery(conn = dbconnection_local, statement = script)
unique(employee.name_customer.name)
nrow(employee.name_customer.name)
nrow(unique(employee.name_customer.name))
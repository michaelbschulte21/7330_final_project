# Libraries.R

tryCatch({
  library(odbc)
  library(RSQLite)
  library(RMySQL)
  library(tidyverse)
  library(DBI)
  library(sqldf)
  library(httr)
  library(jsonlite)
  library(lubridate)
}, error = function(e){
  install.packages('odbc')
  install.packages('RSQLite')
  install.packages('RMySQL')
  install.packages('tidyverse')
  install.packages('DBI')
  install.packages('sqldf')
  install.packages('httr')
  install.packages('jsonlite')
  install.packages('lubridate')
}
)
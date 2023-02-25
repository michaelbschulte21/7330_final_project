# Data_Cleaning_Tools.R

source('Data_Cleaning/NULL_fixer.R')

clean_nums <- function(df){
  df <- gsub("[+-]", "", df)
  return(df)
}

apostrophe_fix <- function(df){
  df <- gsub("'", "\\\\'", df)
  return(df)
}

# Combines all the data cleaning functions above into 1
full_clean <- function(df){
  df <- clean_nums(df)
  df <- apostrophe_fix(df)
  df <- if_null_char(df)
  df <- if_null_int(df)
  return(df)
}
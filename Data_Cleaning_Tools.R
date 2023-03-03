# Data_Cleaning_Tools.R

source('Data_Cleaning/NULL_fixer.R')

source('Data_Cleaning/Data_Cleaning.R')

clean_nums <- function(df){
  df <- gsub("[+-]", "", df)
  return(df)
}

apostrophe_fix <- function(df){
  df <- gsub("'", "\\\\'", df)
  return(df)
}

time_fix_1 <- function(df){
  df <- sub("Z", "", df)
  return(df)
}

# timestamp_fix <- function(df){
#   df <- sapply(df, function(x) {
#     if (grepl("\\d+\\.\\d+", x)) {
#       seconds <- floor(as.numeric(x))
#       milliseconds <- sprintf("%03d", round((as.numeric(x) - seconds) * 1000))
#       return(paste(sprintf("%02d", seconds %/% 3600), 
#                    sprintf("%02d", (seconds %/% 60) %% 60), 
#                    sprintf("%02d", seconds %% 60), 
#                    ".", milliseconds))
#     } else {
#       return(x)
#     }
#   })
#   return(df)
# }

# clean_time <- function(time) {
#   if (!is.na(time) && !grepl(":", time)) {  # Check if time is not NA and not already in the desired format
#     seconds <- as.numeric(time)
#     minutes <- floor(seconds / 60)
#     hours <- floor(minutes / 60)
#     milliseconds <- round((seconds %% 1) * 1000)
#     seconds <- floor(seconds %% 60)
#     minutes <- minutes %% 60
#     sprintf("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
#   } else {
#     time  # Return original time if already in the desired format or if NA
#   }
# }

clean_time <- function(x) {
  if (is.na(x)) {
    return(NA)
  }
  
  if (grepl("\\d+:\\d+:\\d+\\.\\d+", x)) {
    return(x)
  } else {
    seconds <- floor(as.numeric(x))
    milliseconds <- round((as.numeric(x) - seconds) * 1000)
    time <- sprintf("%02d:%02d:%02d.%03d", seconds %/% 3600, seconds %/% 60 %% 60, seconds %% 60, milliseconds)
    return(time)
  }
}

time_clean <- function(df_column) {
  df_column <- as.character(df_column)
  df_column <- ifelse(grepl("^\\d+\\.\\d+$", df_column), 
                      sprintf("00:%02d:%06.3f", floor(df_column/60), df_column %% 60), df_column)
  df_column <- ifelse(is.na(df_column), df_column, ifelse(grepl("^\\d{1,2}:\\d{2}:\\d{2}\\.\\d{2}$", df_column),
                                                          df_column, NA))
  return(df_column)
}

convert_time <- function(df_column) {
  # create a vector to store the converted times
  converted_times <- vector()
  
  # loop through each entry in the column
  for (i in 1:length(df_column)) {
    # check if the entry is in the format "x:xx.xxx"
    if (grepl("\\d:\\d\\d\\.\\d\\d\\d", df_column[i])) {
      # split the entry into the minutes and seconds/milliseconds
      split_time <- strsplit(df_column[i], ":")[[1]]
      minutes <- as.numeric(split_time[1])
      seconds <- as.numeric(split_time[2])
      # calculate the converted time and add it to the vector
      converted_time <- minutes*60 + seconds
      converted_times <- c(converted_times, converted_time)
    } else {
      # if the entry is not in the correct format, just add it to the vector as-is
      converted_times <- c(converted_times, df_column[i])
    }
  }
  
  # return the vector of converted times
  return(converted_times)
}



# Combines all the data cleaning functions above into 1
full_clean <- function(df){
  df <- clean_nums(df)
  df <- apostrophe_fix(df)
  df <- if_null_char(df)
  df <- if_null_int(df)
  return(df)
}
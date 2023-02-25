# Data_Cleaning/NULL_fixer.R

if_null_char <- function(df){
  if(length(df) == 0){
    df <- 'NULL'
  } else{
    df <- as.character(sapply(df, function(id){
      if(is.null(id) | is.na(id)){
        return('NULL')
      } else{
        return(paste0("'", id, "'"))
      }
    })
    )
  }
  return(df)
}

if_null_int <- function(df){
  if(length(df) == 0){
    df <- 'NULL'
  } else{
    df <- sapply(df, function(id){
      if(is.null(id) | is.na(id)){
        return('NULL')
      } else{
        return(id)
      }
    })
  }
  return(df)
}

# API/API_access_pt2.R

api_getter <- function(season = NULL, round_number = NULL, value = NULL, lap_number = NULL){
  if(is.null(value)){
    link <- paste0("http://ergast.com/api/f1/", ifelse(is.null(season), "", paste0(season)), ifelse(is.null(round_number), "", paste0("/", round_number)), ".json?limit=1000")
  } else if(is.null(lap_number)){
    link <- paste0("http://ergast.com/api/f1/", ifelse(is.null(season), "", paste0(season,"/")), ifelse(is.null(round_number), "", paste0(round_number,"/")), ifelse(is.null(value), "", value),".json?limit=1000")
  } else if(!is.null(lap_number)){
    link <- paste0("http://ergast.com/api/f1/", ifelse(is.null(season), "", paste0(season,"/")), ifelse(is.null(round_number), "", paste0(round_number,"/")), ifelse(is.null(value), "", paste0(value, "/")), lap_number, ".json?limit=1000")
  }
  res <- GET(url = link)
  fromJSON(rawToChar(res$content))
}

######## Circuits #######
tryCatch(
  {
    circuits <- api_getter(season = years[i], round_number = nr, value = table_names[1])
    circuits <- circuits$MRData$CircuitTable$Circuits
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See circuits call in API calls")
  }
)

########### Constructors ##########
tryCatch(
  {
    constructors <- api_getter(season = years[i], round_number = nr, value = table_names[2])
    constructors <- as.data.frame(constructors$MRData$ConstructorTable$Constructors)
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See constructors call in API calls")
  }
)

############ Constructor Standings #########
tryCatch(
  {
    constructorStandings <- api_getter(season = years[i], round_number = nr, value = table_names[3])
    constructorStandings <- as.data.frame(constructorStandings$MRData$StandingsTable$StandingsLists$ConstructorStandings)
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See constructorStandings call in API calls")
  }
)

######### Drivers ########
# drivers with year >= 2014 have a permanent driver number
tryCatch(
  {
    drivers <- api_getter(season = years[i], round_number = nr, value = table_names[4])
    drivers <- drivers$MRData$DriverTable$Drivers
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See drivers call in API calls")
  }
)

######### Driver Standings #######
tryCatch(
  {
    driverStandings <- api_getter(season = years[i], round_number = nr, value = table_names[5])
    driverStandings <- as.data.frame(driverStandings$MRData$StandingsTable$StandingsLists$DriverStandings)
    tryCatch(
      {
        driverStandings.constructors <- as.data.frame(driverStandings$Constructors)
      },
      error = function(e) {
        driverStandings.constructors <- driverStandings %>% tidyr::unnest(Constructors) %>% dplyr::bind_rows()
      }
    )
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See driverStandings call in API calls")
  }
)

########## Laps #############
# laps must be year >= 1996
if(years[i] >= 1996){
  tryCatch(
    {
      laps <- api_getter(season = years[i], round_number = nr, value = table_names[6], lap_number = 1)
      laps <- as.data.frame(laps$MRData$RaceTable)
      laps.laps <- as.data.frame(laps$Races.Laps)
      laps.laps.timings <- as.data.frame(laps.laps$Timings)
    }, error = function(e){
      cat("Error occurred: ", conditionMessage(e), "\n")
      print("See laps call in API calls")
    }
  )
}

####### Pit Stops ###################
# pitstops has data for year >= 2012
if(years[i] >= 2012){
  tryCatch(
    {
      tryCatch(
        {
          pitstops <- api_getter(season = years[i], round_number = nr, value = table_names[7])
          pitstops.races <- as.data.frame(pitstops$MRData$RaceTable)
          pitstops <- as.data.frame(pitstops$MRData$RaceTable$Races)
          pitstops.pitstops <- as.data.frame(pitstops$PitStops)
        }, error = function(e){
          pitstops <- api_getter(season = years[i], round_number = nr, value = table_names[7])
          pitstops.races$Races.raceName <- 'NULL'
          pitstops <- as.data.frame(pitstops$MRData$RaceTable$Races)
          pitstops.pitstops <- as.data.frame(pitstops$PitStops)
        }
      )
    }, error = function(e){
      cat("Error occurred: ", conditionMessage(e), "\n")
      print("See pitstops call in API calls")
    }
  )
}

############ Qualifying #########################
# Qualifying is only complete for year >= 2003
tryCatch(
  {
    qualifying <- api_getter(season = years[i], round_number = nr, value = table_names[8])
    qualifying <- qualifying$MRData$RaceTable$Races # Needs to be cut more. Find race ID
    qualifying.races <- qualifying
    qualifying <- as.data.frame(qualifying$QualifyingResults)
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See qualifying call in API calls")
  }
)

############ Results #############
tryCatch(
  {
    results <- api_getter(season = years[i], round_number = nr, value = table_names[9])
    results.race <- as.data.frame(results$MRData$RaceTable$Race)
    results <- as.data.frame(results$MRData$RaceTable$Races$Results) # May need to be broadened
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See results call in API calls")
  }
)

############ Status ############
tryCatch(
  {
    status <- api_getter(season = years[i], round_number = nr, value = table_names[10])
    status <- as.data.frame(status$MRData$StatusTable$Status)
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See status call in API calls")
  }
)

########## Race ###########
tryCatch(
  {
    race <- api_getter(season = years[i], round_number = nr, value = NULL)
    race <- as.data.frame(race$MRData$RaceTable$Races)
  }, error = function(e){
    cat("Error occurred: ", conditionMessage(e), "\n")
    print("See race call in API calls")
  }
)
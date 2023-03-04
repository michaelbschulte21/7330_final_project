# API/API_access_pt1.R

# For more information about API go here: http://ergast.com/mrd/

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

seasons <- api_getter(value = "seasons")

years <- unique(seasons$MRData$SeasonTable$Seasons$season)

table_names <- c('circuits',
                 'constructors',
                 'constructorStandings',
                 'drivers',
                 'driverStandings',
                 'laps',
                 'pitstops',
                 'qualifying',
                 'results',
                 'status')

tables_in_db_insert_order <- c("seasons"
                               , "APIs"
                               , "circuits"
                               , "constructor_standings"
                               , "constructor_results"
                               , "constructors"
                               , "driver_standings"
                               , "drivers"
                               , "lap_times"
                               , "pit_stops"
                               , "qualifying"
                               , "races"
                               , "results"
                               , "status")
# race is specified by year

# tables_in_db <- c("circuits,
#                   constructor_results,
#                   constructor_standings,
#                   constructors,
#                   driver_standings,
#                   drivers,
#                   lap_times,
#                   pit_stops,
#                   qualifying,
#                   races,
#                   results,
#                   seasons,
#                   status")
# 
# y <- 2013
# nr <- 1
# 
# circuits <- api_getter(season = y, round_number = nr, value = table_names[1])
# circuits <- circuits$MRData$CircuitTable$Circuits
# 
# constructors <- api_getter(season = y, round_number = nr, value = table_names[2])
# constructors <- as.data.frame(constructors$MRData$ConstructorTable$Constructors)
# 
# constructorStandings <- api_getter(season = y, round_number = nr, value = table_names[3])
# constructorStandings <- as.data.frame(constructorStandings$MRData$StandingsTable$StandingsLists$ConstructorStandings)
# 
# drivers <- api_getter(season = y, round_number = nr, value = table_names[4])
# drivers <- drivers$MRData$DriverTable$Drivers
# 
# driverStandings <- api_getter(season = y, round_number = nr, value = table_names[5])
# driverStandings <- as.data.frame(driverStandings$MRData$StandingsTable$StandingsLists$DriverStandings)
# driverStandings.constructors <- as.data.frame(driverStandings$Constructors)
# 
# # laps must be year >= 1996
# laps <- api_getter(season = y, round_number = nr, value = table_names[6], lap_number = 1)
# laps <- as.data.frame(laps$MRData$RaceTable)
# laps.laps <- as.data.frame(laps$Races.Laps)
# laps.laps.timings <- as.data.frame(laps.laps$Timings)
# 
# # Return to laps. It may be broken
# pitstops <- api_getter(season = y, round_number = nr, value = table_names[7])
# pitstops.races <- as.data.frame(pitstops$MRData$RaceTable)
# pitstops <- as.data.frame(pitstops$MRData$RaceTable$Races) # Needs to be looked at
# pitstops.pitstops <- as.data.frame(pitstops$PitStops)
# 
# qualifying <- api_getter(season = y, round_number = nr, value = table_names[8])
# qualifying <- qualifying$MRData$RaceTable$Races # Needs to be cut more. Find race ID
# qualifying.races <- qualifying
# qualifying <- as.data.frame(qualifying$QualifyingResults)
# 
# results <- api_getter(season = y, round_number = nr, value = table_names[9])
# results.race <- as.data.frame(results$MRData$RaceTable$Race)
# results <- as.data.frame(results$MRData$RaceTable$Races$Results) # May need to be broadened
# 
# status <- api_getter(season = y, round_number = nr, value = table_names[10])
# status <- as.data.frame(status$MRData$StatusTable$Status)
# 
# race <- api_getter(season = y, round_number = nr, value = NULL)
# race <- as.data.frame(race$MRData$RaceTable$Races)

# API_access_pt2.R

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

circuits <- api_getter(season = years[i], round_number = nr, value = table_names[1])
circuits <- circuits$MRData$CircuitTable$Circuits

constructors <- api_getter(season = years[i], round_number = nr, value = table_names[2])
constructors <- as.data.frame(constructors$MRData$ConstructorTable$Constructors)

constructorStandings <- api_getter(season = years[i], round_number = nr, value = table_names[3])
constructorStandings <- as.data.frame(constructorStandings$MRData$StandingsTable$StandingsLists$ConstructorStandings)

# drivers with year >= 2014 have a permanent driver number
drivers <- api_getter(season = years[i], round_number = nr, value = table_names[4])
drivers <- drivers$MRData$DriverTable$Drivers

driverStandings <- api_getter(season = years[i], round_number = nr, value = table_names[5])
driverStandings <- as.data.frame(driverStandings$MRData$StandingsTable$StandingsLists$DriverStandings)
driverStandings.constructors <- as.data.frame(driverStandings$Constructors)

# laps must be year >= 1996
if(years[i] >= 1996){
  laps <- api_getter(season = years[i], round_number = nr, value = table_names[6], lap_number = 1)
  laps <- as.data.frame(laps$MRData$RaceTable)
  laps.laps <- as.data.frame(laps$Races.Laps)
  laps.laps.timings <- as.data.frame(laps.laps$Timings)
}
# pitstops has data for year >= 2012
if(years[i] >= 2012){
  pitstops <- api_getter(season = years[i], round_number = nr, value = table_names[7])
  pitstops.races <- as.data.frame(pitstops$MRData$RaceTable)
  pitstops <- as.data.frame(pitstops$MRData$RaceTable$Races)
  pitstops.pitstops <- as.data.frame(pitstops$PitStops)
}
# Qualifying is only complete for year >= 2003
qualifying <- api_getter(season = years[i], round_number = nr, value = table_names[8])
qualifying <- qualifying$MRData$RaceTable$Races # Needs to be cut more. Find race ID
qualifying.races <- qualifying
qualifying <- as.data.frame(qualifying$QualifyingResults)

results <- api_getter(season = years[i], round_number = nr, value = table_names[9])
results.race <- as.data.frame(results$MRData$RaceTable$Race)
results <- as.data.frame(results$MRData$RaceTable$Races$Results) # May need to be broadened

status <- api_getter(season = years[i], round_number = nr, value = table_names[10])
status <- as.data.frame(status$MRData$StatusTable$Status)

race <- api_getter(season = years[i], round_number = nr, value = NULL)
race <- as.data.frame(race$MRData$RaceTable$Races)
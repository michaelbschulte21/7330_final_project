# Data_Cleaning/Data_Cleaning.R

# source('Connections/Master_connect.R')
# rm(secrets)

##### Circuits #######
# script <- paste0('SELECT *
#                  FROM circuits;')
# circuits <- dbGetQuery(conn = dbconnection_master, statement = script)

circuit_cleaner <- function(circuits){
  circuits$circuit_name[circuits$circuit_abbr == 'galvez'] <- 'Autódromo Juan y Oscar Gálvez'
  circuits$locality[circuits$circuit_abbr == 'nurburgring'] <- 'Nürburg'
  circuits$circuit_name[circuits$circuit_abbr == 'nurburgring'] <- 'Nürburgring'
  circuits$circuit_name[circuits$circuit_abbr == 'rodriguez'] <- 'Autódromo Hermanos Rodríguez'
  circuits$circuit_name[circuits$circuit_abbr == 'montjuic'] <- 'Montjuïc circuit'
  circuits$locality[circuits$circuit_abbr == 'interlagos'] <- 'São Paulo'
  circuits$circuit_name[circuits$circuit_abbr == 'interlagos'] <- 'Autodromo José Carlos Pace'
  circuits$circuit_name[circuits$circuit_abbr == 'jacarepagua'] <- 'Autódromo Internacional do Rio de Janeiro'
  circuits$circuit_name[circuits$circuit_abbr == 'estoril'] <- 'Autódromo do Estoril'
  circuits$locality[circuits$circuit_abbr == 'catalunya'] <- 'Montmeló'
  circuits$locality[circuits$circuit_abbr == 'portimao'] <- 'Portimão'
  circuits$circuit_name[circuits$circuit_abbr == 'portimao'] <- 'Algarve International Circuit'
  return(circuits)
}

####### Constructor Results #######
# script <- paste0('SELECT *
#                  FROM constructor_results;')
# constructor_results <- dbGetQuery(conn = dbconnection_master, statement = script)

######## Constructor Standings #######
# script <- paste0('SELECT *
#                  FROM constructor_standings;')
# constructor_standings <- dbGetQuery(conn = dbconnection_master, statement = script)

######## Constructors #######
# script <- paste0('SELECT *
#                  FROM constructors;')
# constructors <- dbGetQuery(conn = dbconnection_master, statement = script)

###### Driver Standings ########
# script <- paste0('SELECT *
#                  FROM driver_standings;')
# driver_standings <- dbGetQuery(conn = dbconnection_master, statement = script)

####### Drivers #######
# script <- paste0('SELECT *
#                  FROM drivers;')
# drivers <- dbGetQuery(conn = dbconnection_master, statement = script)

drivers_cleaner <- function(drivers){
  drivers$last_name[drivers$driver_abbr == 'londono'] <- 'Londoño'
  drivers$first_name[drivers$driver_abbr == 'guerra'] <- 'Miguel Ángel'
  drivers$first_name[drivers$driver_abbr == 'hesnault'] <- 'François'
  drivers$first_name[drivers$driver_abbr == 'campos'] <- 'Adrián'
  drivers$last_name[drivers$driver_abbr == 'sala'] <- 'Pérez-Sala'
  drivers$first_name[drivers$driver_abbr == 'gugelmin'] <- 'Maurício'
  drivers$last_name[drivers$driver_abbr == 'lehto'] <- 'Järvilehto'
  drivers$last_name[drivers$driver_abbr == 'hakkinen'] <- 'Häkkinen'
  drivers$last_name[drivers$driver_abbr == 'deletraz'] <- 'Delétraz'
  drivers$last_name[drivers$driver_abbr == 'gene'] <- 'Gené'
  drivers$first_name[drivers$driver_abbr == 'mazzacane'] <- 'Gastón'
  drivers$first_name[drivers$driver_abbr == 'enge'] <- 'Tomáš'
  drivers$first_name[drivers$driver_abbr == 'pizzonia'] <- 'Antônio'
  drivers$first_name[drivers$driver_abbr == 'bourdais'] <- 'Sébastien'
  drivers$first_name[drivers$driver_abbr == 'buemi'] <- 'Sébastien'
  drivers$last_name[drivers$driver_abbr == 'hulkenberg'] <- 'Hülkenberg'
  drivers$first_name[drivers$driver_abbr == 'ambrosio'] <- 'Jérôme'
  drivers$last_name[drivers$driver_abbr == 'perez'] <- 'Pérez'
  drivers$last_name[drivers$driver_abbr == 'gutierrez'] <- 'Gutiérrez'
  drivers$first_name[drivers$driver_abbr == 'lotterer'] <- 'André'
  drivers$first_name[drivers$driver_abbr == 'gonzalez'] <- 'José'
  drivers$last_name[drivers$driver_abbr == 'gonzalez'] <- 'González'
  drivers$last_name[drivers$driver_abbr == 'pian'] <- 'Pián'
  drivers$last_name[drivers$driver_abbr == 'marimon'] <- 'Marimón'
  drivers$last_name[drivers$driver_abbr == 'galvez'] <- 'Gálvez'
  drivers$first_name[drivers$driver_abbr == 'iglesias'] <- 'Jesús'
  drivers$last_name[drivers$driver_abbr == 'estefano'] <- 'Estéfano'
  drivers$first_name[drivers$driver_abbr == 'andre_pilette'] <- 'André'
  drivers$last_name[drivers$driver_abbr == 'frere'] <- 'Frère'
  drivers$first_name[drivers$driver_abbr == 'milhoux'] <- 'André'
  drivers$last_name[drivers$driver_abbr == 'neve'] <- 'Nève'
  drivers$last_name[drivers$driver_abbr == 'belso'] <- 'Belsø'
  drivers$last_name[drivers$driver_abbr == 'raikkonen'] <- 'Räikkönen'
  drivers$first_name[drivers$driver_abbr == 'martin'] <- 'Eugène'
  drivers$first_name[drivers$driver_abbr == 'chaboud'] <- 'Eugène'
  drivers$first_name[drivers$driver_abbr == 'simon'] <- 'André'
  drivers$first_name[drivers$driver_abbr == 'picard'] <- 'François'
  drivers$first_name[drivers$driver_abbr == 'guelfi'] <- 'André'
  drivers$first_name[drivers$driver_abbr == 'cevert'] <- 'François'
  drivers$first_name[drivers$driver_abbr == 'mazet'] <- 'François'
  drivers$first_name[drivers$driver_abbr == 'migault'] <- 'François'
  drivers$first_name[drivers$driver_abbr == 'dolhem'] <- 'José'
  drivers$first_name[drivers$driver_abbr == 'larrousse'] <- 'Gérard'
  drivers$last_name[drivers$driver_abbr == 'leclere'] <- 'Leclère'
  drivers$first_name[drivers$driver_abbr == 'arnoux'] <- 'René'
  drivers$first_name[drivers$driver_abbr == 'sarrazin'] <- 'Stéphane'
  drivers$first_name[drivers$driver_abbr == 'bechem'] <- 'Karl-Günther'
  drivers$first_name[drivers$driver_abbr == 'seiffert'] <- 'Günther'
  drivers$last_name[drivers$driver_abbr == 'ricardo_rodriguez'] <- 'Rodríguez'
  drivers$last_name[drivers$driver_abbr == 'rodriguez'] <- 'Rodríguez'
  drivers$first_name[drivers$driver_abbr == 'solana'] <- 'Moisés'
  drivers$first_name[drivers$driver_abbr == 'testut'] <- 'André'
  drivers$first_name[drivers$driver_abbr == 'cabral'] <- 'Mário de Araújo'
  drivers$first_name[drivers$driver_abbr == 'desire_wilson'] <- 'Desiré'
  drivers$first_name[drivers$driver_abbr == 'oscar_gonzalez'] <- 'Óscar'
  drivers$last_name[drivers$driver_abbr == 'oscar_gonzalez'] <- 'González'
  return(drivers)
}

# View(drivers[grepl('ÃƒÂ', drivers$first_name) | grepl('ÃƒÂ', drivers$last_name),])

###### Lap Times ########
# script <- paste0('SELECT *
#                  FROM lap_times;')
# lap_times <- dbGetQuery(conn = dbconnection_master, statement = script)

####### Pit Stops #########
# script <- paste0('SELECT *
#                  FROM pit_stops;')
# pit_stops <- dbGetQuery(conn = dbconnection_master, statement = script)

######## Qualifying ########
# script <- paste0('SELECT *
#                  FROM qualifying;')
# qualifying <- dbGetQuery(conn = dbconnection_master, statement = script)

######## Races ########
# script <- paste0('SELECT *
#                  FROM races;')
# races <- dbGetQuery(conn = dbconnection_master, statement = script)

races_cleaner <- function(races){
  races$race_name[races$race_name == 'SÃƒÂ£o Paulo Grand Prix'] <- 'São Paulo Grand Prix'
  return(races)
}

###### Results ##########
# script <- paste0('SELECT *
#                  FROM results;')
# results <- dbGetQuery(conn = dbconnection_master, statement = script)

results_time_cleaner <- function(results){
  op <- options(digits.secs=3)
  
  add_time_to_base <- function(base_time, add_time) {
    # convert base_time to POSIXlt
    base_time <- as.POSIXlt(paste(Sys.Date(), base_time), tz = "America/Chicago")
    
    # extract seconds and milliseconds from base_time
    sec <- base_time$sec
    min <- base_time$min
    hr <- base_time$hour
    
    if(grepl(":", add_time)){
      add_time <- as.POSIXlt(paste(add_time), "%M:%OS", tz = "America/Chicago")
      at_sec <- add_time$sec
      at_min <- add_time$min
      sec <- sec + at_sec
      min <- min + at_min
    } else{
      # add add_time to sec
      sec <- sec + as.numeric(add_time)
    }
    
    if (sec >= 60) {
      extra_min <- floor(sec / 60)
      sec <- sec %% 60
    } else {
      extra_min <- 0
    }
    
    min <- min + extra_min
    
    if(min >= 60){
      extra_hr <- floor(min / 60)
      min <- min %% 60
    } else{
      extra_hr <- 0
    }
      
    # update the seconds and milliseconds in base_time
    base_time$min <- min
    base_time$sec <- sec
    base_time$hour <- hr + extra_hr
    # base_time$msec <- total_msec
    
    # format the result as a character string
    true_time <- format(base_time, "%H:%M:%OS")
    
    return(true_time)
  }
  
  race_IDs <- unique(results$race_ID)
  for(race_id in race_IDs){
    print(paste0('race_ID = ', race_id))
    base.time <- results$time[results$race_ID == race_id & results$position == 1]
    # x <- strptime(base_time, "%H:%M:%OS")
    # x <- as.POSIXct(x, format = '%H:%M:%OS')
    # x <- format.POSIXlt(x, format = '%H:%M:%OS', usetz = F)
    all_positions <- results$position[results$race_ID == race_id & !is.na(results$time) & results$position != 1]
    if(length(all_positions) > 0){
      for(position in all_positions){
        # print(paste0('position = ', position))
        add.time <- results$time[results$race_ID == race_id & results$position == position & !is.na(results$time)]
        results$time[results$race_ID == race_id & results$position == position] <- add_time_to_base(base.time, add.time)
      }
    }
  }
  return(results)
}

########## Seasons #########
# script <- paste0('SELECT *
#                  FROM seasons;')
# seasons <- dbGetQuery(conn = dbconnection_master, statement = script)

####### Status ###########
# script <- paste0('SELECT *
#                  FROM status;')
# status <- dbGetQuery(conn = dbconnection_master, statement = script)

# Data_Cleaning/Data_Cleaning.R

source('Connections/Master_connect.R')
rm(secrets)

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
script <- paste0('SELECT *
                 FROM results;')
# results <- dbGetQuery(conn = dbconnection_master, statement = script)

########## Seasons #########
# script <- paste0('SELECT *
#                  FROM seasons;')
# seasons <- dbGetQuery(conn = dbconnection_master, statement = script)

####### Status ###########
# script <- paste0('SELECT *
#                  FROM status;')
# status <- dbGetQuery(conn = dbconnection_master, statement = script)

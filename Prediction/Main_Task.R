# Prediction/Main_Task.R
# Created by Michael 2023-04-02

source('Libraries.R')
library(caret)
library(Hmisc)
library(rpart)
library(rpart.plot)

dbKillConnections <- function(){
  all_cons <- dbListConnections(RMySQL::MySQL())
  print(all_cons)
  for(con in all_cons){
    dbDisconnect(conn = con)
  }
  print(paste0(length(all_cons), " connections killed"))
}

source('Connections/Master_connect.R')

script <- paste0("SELECT *
                 FROM seasons;")
season_info <- dbGetQuery(conn = dbconnection_master, statement = script)

script <- paste0("SELECT
                 DISTINCT(s.num_rounds) AS num_rounds,
                 COUNT(s.num_rounds) AS freq
                 FROM seasons s
                 GROUP BY s.num_rounds;")
rounds_freq <- dbGetQuery(conn = dbconnection_master, statement = script)

max_rounds <- season_info %>% filter(num_rounds == max(season_info$num_rounds))
season.2010s <- season_info %>% filter(year >= 2010)

script <- paste0("SELECT
                  res.race_ID,
                  rac.year AS season,
                  rac.round AS season_round,
                  s.num_rounds,
                  rac.date,
                  rac.time,
                  rac.circuit_ID,
                  cir.locality AS circuit_locality,
                  cir.country AS circuit_country,
                  res.driver_ID,
                  datediff(rac.date, d.DOB) AS driver_age,
                  d.nationality AS driver_nationality,
                  res.constructor_ID,
                  con.nationality AS constructor_nationality,
                  res.number AS driver_number,
                  q.position AS driver_qualifying_position,
                  MICROSECOND(q.q1) AS q1,
                  MICROSECOND(q.q2) AS q2,
                  MICROSECOND(q.q3) AS q3,
                  res.grid,
                  res.position,
                  res.position_Text,
                  res.points AS driver_points,
                  res.laps AS num_laps_completed,
                  MICROSECOND(res.time) AS driver_final_time,
                  res.milliseconds AS driver_final_time_ms,
                  res.fastest_Lap,
                  res.rank AS driver_rank,
                  ds.points AS driver_points_so_far,
                  ds.position AS driver_position,
                  ds.position_Text AS driver_position_text,
                  ds.wins AS num_races_won_driver,
                  cs.points AS constructor_points_so_far,
                  cs.position AS constructor_position,
                  cs.position_Text AS constructor_position_text,
                  cs.wins AS num_races_won_constructor,
                  MICROSECOND(res.fastest_Lap_Time) AS fastest_Lap_Time,
                  res.fastest_Lap_Speed,
                  lt.lap AS lap_number,
                  lt.position AS lap_driver_position,
                  MICROSECOND(lt.time) AS lap_time,
                  ps.stop AS stop_number,
                  ps.lap AS lap_ps_taken,
                  MICROSECOND(ps.time) AS time_ps_occurred,
                  ps.duration AS ps_duration,
                  res.status_ID
                  FROM results res
                  LEFT JOIN races rac ON rac.race_ID = res.race_ID
                  LEFT JOIN circuits cir ON cir.circuit_ID = rac.circuit_ID
                  LEFT JOIN drivers d ON d.driver_ID = res.driver_ID
                  LEFT JOIN constructors con ON con.constructor_ID = res.constructor_ID
                  LEFT JOIN qualifying q ON q.race_ID = res.race_ID AND q.driver_ID = res.driver_ID AND q.constructor_ID = res.constructor_ID
                  LEFT JOIN pit_stops ps ON ps.race_ID = res.race_ID AND ps.driver_ID = res.driver_ID
                  LEFT JOIN lap_times lt ON lt.race_ID = res.race_ID AND lt.driver_ID = res.driver_ID
                  LEFT JOIN driver_standings ds ON ds.race_ID = res.race_ID AND ds.driver_ID = res.driver_ID AND ds.constructor_ID = res.constructor_ID
                  LEFT JOIN constructor_standings cs ON cs.race_ID = res.race_ID AND cs.constructor_ID = res.constructor_ID
                  LEFT JOIN seasons s ON s.year = rac.year
                  WHERE rac.year < 2023
                  ORDER BY res.race_ID, res.position;")
race_data <- dbGetQuery(conn = dbconnection_master, statement = script)

race_data$season_champion <- 0
seasons <- unique(race_data$season)
for (season in seasons) {
  season_data <- race_data[race_data$season == season,]
  season_champion <- season_data$driver_ID[which.max(season_data$driver_points_so_far)]
  race_data$season_champion[race_data$season == season & race_data$driver_ID == season_champion] <- 1
}

rm(season_champion)
rm(season_data)
rm(seasons)

race_data$driver_points_so_far[is.na(race_data$driver_points_so_far)] <- 0
race_data$num_races_won_driver[is.na(race_data$num_races_won_driver)] <- 0
race_data$num_races_won_constructor[is.na(race_data$num_races_won_constructor)] <- 0

race_data <- race_data %>% select(-c(constructor_position_text, driver_position_text, position_Text, date, driver_final_time, time))

head(race_data[race_data$season == '2013',])
n <- 0
for(locality in unique(race_data$circuit_locality)){
  race_data$circuit_locality[race_data$circuit_locality == locality] <- n
  n <- n + 1
}
race_data$circuit_locality <- as.numeric(race_data$circuit_locality)
n <- 0
for(country in unique(race_data$circuit_country)){
  race_data$circuit_country[race_data$circuit_country == country] <- n
  n <- n + 1
}
race_data$circuit_country <- as.numeric(race_data$circuit_country)
n <- 0
for(nationality in unique(race_data$driver_nationality)){
  race_data$driver_nationality[race_data$driver_nationality == nationality] <- n
  n <- n + 1
}
race_data$driver_nationality <- as.numeric(race_data$driver_nationality)
n <- 0
for(nationality in unique(race_data$constructor_nationality)){
  race_data$constructor_nationality[race_data$constructor_nationality == nationality] <- n
  n <- n + 1
}
race_data$constructor_nationality <- as.numeric(race_data$constructor_nationality)

race_data_2 <- as.data.frame(race_data %>% select(c(season, num_rounds, driver_ID, driver_nationality, constructor_ID, constructor_nationality, season_champion)))
race_data_2 <- as.data.frame(unique(race_data_2))

rcorr(as.matrix(race_data_2))

# race_data_rf <- subset(race_data, select = -c(race_ID, date, time, circuit_locality, constructor_nationality, driver_number, driver_rank, driver_position_text, constructor_position_text, fastest_Lap, fastest_Lap_Time, fastest_Lap_Speed, lap_time, time_ps_occurred))
# rm(race_data)
# race_data_rf <- as.data.frame(dummyVars(season_champion ~ ., data = race_data_rf) %>% predict(race_data_rf))

training <- race_data %>% filter(season < 2020)

testing <- race_data %>% filter(season == 2022)

rm(race_data)

formula <- as.formula("season_champion ~ . - driver_ID")

set.seed(100)

tree <- rpart(formula= formula, data = training, method = "class", minsplit = 10, minbucket = 3)
summary(tree)

rpart.plot::prp(tree)

predict_winners.train <- predict(tree, data = training, type = "class")
pred.results.train <- as.data.frame(table(training$season_champion, predict_winners.train))
(pred.results.train$Freq[1]+pred.results.train$Freq[4])/sum(pred.results.train$Freq)

predict_winners.test <- predict(tree, newdata = testing, type = "class")
testing$prediction <- predict_winners.test
pred.results.test <- as.data.frame(table(testing$season_champion, predict_winners.test))
(pred.results.test$Freq[1]+pred.results.test$Freq[4])/sum(pred.results.test$Freq)

# ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3, savePredictions = TRUE, classProbs = TRUE)
# rf_model <- train(formula, data = training, method = "rf", trControl = ctrl, na.action = na.exclude)

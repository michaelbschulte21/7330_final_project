SELECT * FROM results
WHERE `rank` IS NOT NULL
ORDER BY race_ID, `rank`;

SELECT
res.race_ID,
rac.year AS season,
rac.round AS season_round,
s.num_rounds,
-- rac.race_name,
rac.date,
rac.time,
rac.circuit_ID,
-- cir.circuit_name,
cir.circuit_locality,
cir.circuit_country,
res.driver_ID,
-- d.number AS driver_number,
-- d.code,
datediff(rac.date, d.DOB) AS driver_age,
d.nationality AS driver_nationality,
res.constructor_ID,
-- con.constructor_name,
con.nationality AS constructor_nationality,
res.number AS driver_number,
q.position AS driver_qualifying_position,
q.q1,
q.q2,
q.q3,
res.grid,
res.position,
res.position_Text,
res.points AS driver_points,
res.laps AS num_laps_completed,
res.time AS driver_final_time,
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
res.fastest_Lap_Time,
res.fastest_Lap_Speed,
lt.lap AS lap_number,
lt.position AS lap_driver_position,
lt.time AS lap_time,
ps.stop AS stop_number,
ps.lap AS lap_ps_taken,
ps.time AS time_ps_occurred,
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
LEFT JOIN seasons s ON s.year = rac.year;
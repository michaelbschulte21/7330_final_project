UPDATE lap_times
SET time = CAST(CONCAT('00:', LPAD(FLOOR(TIME_TO_SEC(time) / 3600), 2, '0'), ':', LPAD((FLOOR(TIME_TO_SEC(time) / 60) MOD 60), 2, '0'), '.', SUBSTRING_INDEX(TIME_FORMAT(time, '%f'), '.', -1)) as time(3));

UPDATE qualifying
SET
q1 = CAST(CONCAT('00:', LPAD(FLOOR(TIME_TO_SEC(q1) / 3600), 2, '0'), ':', LPAD((FLOOR(TIME_TO_SEC(q1) / 60) MOD 60), 2, '0'), '.', SUBSTRING_INDEX(TIME_FORMAT(q1, '%f'), '.', -1)) as time(3)),
q2 = CAST(CONCAT('00:', LPAD(FLOOR(TIME_TO_SEC(q2) / 3600), 2, '0'), ':', LPAD((FLOOR(TIME_TO_SEC(q2) / 60) MOD 60), 2, '0'), '.', SUBSTRING_INDEX(TIME_FORMAT(q2, '%f'), '.', -1)) as time(3)),
q3 = CAST(CONCAT('00:', LPAD(FLOOR(TIME_TO_SEC(q3) / 3600), 2, '0'), ':', LPAD((FLOOR(TIME_TO_SEC(q3) / 60) MOD 60), 2, '0'), '.', SUBSTRING_INDEX(TIME_FORMAT(q3, '%f'), '.', -1)) as time(3));
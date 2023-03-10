use f1_master;

UPDATE results
SET time = IF(position = 1, CAST('00:03:27.071' as time(3)), CAST(ADDTIME(timediff(`time`, '03:27.000'), '00:03:27.071') as time(3)))
WHERE race_ID = '1047';
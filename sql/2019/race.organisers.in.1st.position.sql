-- seems some RACE_ORGS appear as race winners

SELECT * FROM wp_bhaa_raceresult WHERE race=2597 and position IN (1,2,3)

select race, runner, @row:=@row+1
from wp_bhaa_raceresult, (SELECT @row:=0) r
where race=2597 AND class='RAN' AND racetime IS NOT NULL order by racetime;

SELECT * FROM wp_bhaa_raceresult WHERE class='RACE_ORG' and position=1
-- 12 rows
SELECT * FROM wp_bhaa_raceresult WHERE class='RACE_ORG' and position IS NOT NULL;

UPDATE wp_bhaa_raceresult
SET position=null, actualstandard=null,poststandard=null
WHERE ID IN (
  82597,
  83873,
  83874,
  83875,
  88512,
  125200,
  125216,
  125217,
  125378,
  125379,
  125381,
  125382,
  125530
  );

SELECT * FROM wp_bhaa_raceresult
WHERE ID IN (
             82597,
             83873,
             83874,
             83875,
             88512,
             125200,
             125216,
             125217,
             125378,
             125379,
             125381,
             125382
  );

-- effected races
2597
3152
3841
5294
5229
6652
6061

call updatePositions(2597);
call updatePositions(3152);
call updatePositions(3841);
call updatePositions(5294);
call updatePositions(5229);
call updatePositions(6652);
call updatePositions(6061);

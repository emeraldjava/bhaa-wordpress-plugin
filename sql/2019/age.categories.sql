

DROP TABLE IF EXISTS wp_bhaa_agecategory;
CREATE TABLE IF NOT EXISTS wp_bhaa_agecategory(
category varchar(3) NOT NULL,
gender enum('M','W'),
agegroup enum('S','V35','V40','V45','V50','V55','V60','V65','V70','V75','V80'),
min int(3) NOT NULL,
max int(3) NOT NULL,
awards int(3) NOT NULL,
resticted boolean DEFAULT true,
PRIMARY KEY (category)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO wp_bhaa_agecategory VALUES ('M','M','S',18,34,3,false);
INSERT INTO wp_bhaa_agecategory VALUES ('W','W','S',18,34,3,false);
INSERT INTO wp_bhaa_agecategory VALUES ('M35','M','V35',35,39,0,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W35','W','V35',35,39,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M40','M','V40',40,44,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W40','W','V40',40,44,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M45','M','V45',45,49,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W45','W','V45',45,49,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M50','M','V50',50,54,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W50','W','V50',50,54,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M55','M','V55',55,59,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W55','W','V55',55,59,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M60','M','V60',60,64,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W60','W','V60',60,64,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M65','M','V65',65,69,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W65','W','V65',65,69,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M70','M','V70',70,74,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W70','W','V70',70,74,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M75','M','V75',75,79,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W75','W','V75',75,79,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('M80','M','V80',80,99,3,true);
INSERT INTO wp_bhaa_agecategory VALUES ('W80','W','V80',80,99,3,true);

SELECT * FROM wp_bhaa_agecategory;

-- age_awards table

DROP TABLE IF EXISTS wp_bhaa_raceaward;
CREATE TABLE IF NOT EXISTS wp_bhaa_raceaward(
race int(11) NOT NULL,
category varchar(3) NOT NULL,
award int(11) NOT NULL,
runner int(11) NOT NULL,
INDEX (race),
FOREIGN KEY (race)
  REFERENCES wp_bhaa_raceresult(race),
FOREIGN KEY (category)
  REFERENCES wp_bhaa_agecategory(category),
FOREIGN KEY (runner)
  REFERENCES wp_bhaa_raceresult(runner)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

SELECT * FROM wp_bhaa_raceaward;

SELECT * FROM wp_bhaa_raceresult;
-- Add new columns
ALTER TABLE wp_bhaa_raceresult ADD COLUMN `age` INT(3) AFTER `category`;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN `agecategory` varchar(3) AFTER `age`;
ALTER TABLE wp_bhaa_raceresult ADD CONSTRAINT fk_raceresults_agecat FOREIGN KEY (`agecategory`) REFERENCES wp_bhaa_agecategory(category);

-- calculate runners age
SELECT rr.race,rr.runner,rr.position,rr.category,rr.age,rr.agecategory,
COALESCE(dob.meta_value,'2019-03-13') as dob,
COALESCE(gender.meta_value,'M') as gender,
(SELECT category FROM wp_bhaa_agecategory WHERE (rr.age between min and max) and gender=COALESCE(gender.meta_value,'M')) as agecat
FROM wp_bhaa_raceresult rr
JOIN wp_users u on rr.runner=u.ID
JOIN wp_posts race on race.id=rr.race
LEFT JOIN wp_usermeta dob on (rr.runner=dob.user_id AND dob.meta_key='bhaa_runner_dateofbirth')
LEFT JOIN wp_usermeta gender on (rr.runner=gender.user_id AND gender.meta_key='bhaa_runner_gender')
WHERE race=6771 AND class="RAN";

-- set the age
UPDATE wp_bhaa_raceresult rr
JOIN wp_posts race on race.id=rr.race
JOIN wp_users u on rr.runner=u.ID
LEFT JOIN wp_usermeta dob on (rr.runner=dob.user_id AND dob.meta_key='bhaa_runner_dateofbirth')
SET age=COALESCE((YEAR(race.post_date)-YEAR(dob.meta_value)) - (RIGHT(race.post_date,5)<RIGHT(dob.meta_value,5)),18)
WHERE race=6771 AND class="RAN";

DELETE FROM wp_bhaa_raceresult
WHERE race=6771 and runner=1171


-- set the age category
UPDATE wp_bhaa_raceresult rr
  JOIN wp_posts race on race.id=rr.race
  JOIN wp_users u on rr.runner=u.ID
  LEFT JOIN wp_usermeta gender on (rr.runner=gender.user_id AND gender.meta_key='bhaa_runner_gender')
SET agecategory=(SELECT category FROM wp_bhaa_agecategory WHERE (rr.age between min and max) AND gender=COALESCE(gender.meta_value,'M'))
WHERE race=6771 AND class="RAN";

-- top three (225 rows)
SELECT * FROM wp_bhaa_raceresult rr
WHERE rr.race=6771 AND rr.class="RAN"
ORDER BY rr.agecategory,rr.position;

SELECT rr.* FROM wp_bhaa_raceresult rr
LEFT JOIN wp_bhaa_agecategory agecat on agecat.category=rr.agecategory
WHERE rr.race=6771
AND agecat.gender='W'
LIMIT 3;

SELECT * FROM wp_bhaa_raceaward WHERE race=6771

-- parameterise race, gender, category, award
INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
SELECT race,'M35','1',runner FROM wp_bhaa_raceresult rr
LEFT JOIN wp_bhaa_agecategory agecat on agecat.category='M35'
WHERE rr.race=6771
AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=6771)
AND rr.class="RAN"
ORDER BY rr.position
  LIMIT 1;
SELECT * FROM wp_bhaa_raceaward;

INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
  SELECT race,'M35','2',runner FROM wp_bhaa_raceresult rr
  LEFT JOIN wp_bhaa_agecategory agecat on agecat.category='M35'
  WHERE rr.race=6771
  AND agecat.gender='M'
  AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=6771)AND rr.class="RAN"
ORDER BY rr.position
  LIMIT 1;
SELECT * FROM wp_bhaa_raceaward;

INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
  SELECT race,'M35','3',runner FROM wp_bhaa_raceresult rr
  LEFT JOIN wp_bhaa_agecategory agecat on agecat.category='M35'
  WHERE rr.race=6771
  AND agecat.gender='M'
  AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=6771)
    AND rr.class="RAN"
ORDER BY rr.position
  LIMIT 1;
SELECT * FROM wp_bhaa_raceaward;

SELECT * FROM wp_bhaa_raceaward;
DELETE FROM wp_bhaa_raceaward;

SELECT rr.race,'M','1',rr.runner FROM wp_bhaa_raceresult rr
JOIN wp_bhaa_agecategory agecat on rr.agecategory=agecat.category
WHERE rr.race=6771
AND agecat.gender='M'
AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=6771)
AND rr.class="RAN"
ORDER BY rr.position
LIMIT 5;

SELECT rr.race,'W35','1',rr.runner FROM wp_bhaa_raceresult rr
JOIN wp_bhaa_agecategory agecat on rr.agecategory=agecat.category
WHERE rr.race=6771
AND agecat.gender='W'
AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=6771)
AND rr.class="RAN"
AND rr.agecategory="W35"
ORDER BY rr.position
LIMIT 5;


SELECT * FROM wp_bhaa_raceresult
WHERE race=6771
  AND runner=1333

SELECT a.*,r.* FROM wp_bhaa_raceaward a
JOIN wp_users r on (r.ID=a.runner)
WHERE a.race=6771
ORDER BY a.category DESC, a.position DESC


SELECT CONCAT(ra.award,'_',ra.category) as pcat, ra.*,wba.agegroup,wba.gender,
r.display_name,rr.racetime,rr.position,rr.age FROM wp_bhaa_raceaward ra
JOIN wp_users r on (r.ID=ra.runner)
JOIN wp_bhaa_raceresult rr on (rr.race=ra.race AND rr.runner=ra.runner)
JOIN wp_bhaa_agecategory wba on ra.category = wba.category
WHERE ra.race=6771
ORDER BY wba.agegroup,wba.category,ra.award;
ORDER BY wba.agegroup DESC,wba.category DESC,ra.award DESC;

SELECT * FROM wp_bhaa_raceaward
WHERE award IN (1,2,3)
AND gender IN ('M','W')

SELECT p2p_from as event,DATE(e.post_date) as edate,e.post_title as etitle,
       p2p_to as race,DATE(r.post_date) as rdate,r.post_title as rtitle
FROM wp_p2p
JOIN wp_posts e on e.id=p2p_from
JOIN wp_posts r on r.id=p2p_to
WHERE p2p_type="event_to_race";


select race, runner, @row:=@row+1 as position,class
from wp_bhaa_raceresult, (SELECT @row:=0) r
where race=7182 AND class='RAN' order by racetime;

UPDATE wp_bhaa_raceresult AS rr
  JOIN
  (
    SELECT race, runner, position, racetime, @row:=@row+1 as new_position
    FROM wp_bhaa_raceresult, (select @row:= 0) rn
    WHERE race=7182 AND class='RAN' order by racetime
  ) AS pos
ON (rr.race = pos.race AND rr.runner=pos.runner)
SET rr.position = pos.position;

UPDATE product_images AS t
  JOIN
  (
    SELECT @rownum:=@rownum+1 rownum, id, rel
    FROM product_images
           CROSS JOIN (select @rownum := 0) rn
    WHERE product_id='227'
  ) AS r ON t.id = r.id
SET t.rel = r.rownum

UPDATE wp_bhaa_raceresult
SET position=@row+1
(SELECT @row:=0) r
where race=7182 AND class='RAN' order by racetime;

SELECT * FROM wp_bhaa_agecategory;

SELECT CONCAT(ra.category,"p",ra.award) as pcat,ra.*,
       wba.agegroup,r.display_name,rr.racetime,rr.position,rr.age
FROM wp_bhaa_raceaward ra
       JOIN wp_users r on (r.ID=ra.runner)
       JOIN wp_bhaa_raceresult rr on (rr.race=ra.race AND rr.runner=ra.runner)
       JOIN wp_bhaa_agecategory wba on ra.category = wba.category
WHERE ra.race=6771
ORDER BY wba.agegroup,wba.category,ra.award;

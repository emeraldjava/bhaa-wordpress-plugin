
-- missing gender
select r.id,gender.*
from wp_users r
left join wp_usermeta gender on (gender.meta_key='bhaa_runner_gender' and gender.user_id=r.id)
where NOT EXISTS (select meta_value from wp_usermeta where meta_key='bhaa_runner_gender' and user_id=r.id);

-- missing dob
select r.id,dob.*
from wp_users r
       left join wp_usermeta dob on (dob.meta_key='bhaa_runner_dateofbirth' and dob.user_id=r.id)
where NOT EXISTS (select meta_value from wp_usermeta where meta_key='bhaa_runner_dateofbirth' and user_id=r.id);

-- invalid dob format
select *, (meta_value NOT REGEXP '^\d{4}-\d{1,2}-\d{1,2}') as regex from wp_usermeta where meta_key='bhaa_runner_dateofbirth';

SELECT meta_value FROM wp_usermeta
where meta_key='bhaa_runner_dateofbirth';

-- identify DOB not in correct format
SELECT user_id FROM wp_usermeta
WHERE meta_key='bhaa_runner_dateofbirth'
AND meta_value NOT REGEXP '[[:digit:]]{4}-[[:digit:]]{1,2}-[[:digit:]]{1,2}';

-- identify and fix DOB in format DD/MM/YYYY
SELECT *,
       STR_TO_DATE(meta_value,'%d/%m/%Y') as dob,
       DATE_FORMAT(STR_TO_DATE(meta_value,'%d/%m/%Y'),'%Y-%m-%d') as dob2
FROM wp_usermeta
WHERE meta_key='bhaa_runner_dateofbirth'
  AND meta_value REGEXP '[[:digit:]]{1,2}/[[:digit:]]{1,2}/[[:digit:]]{4}'
ORDER BY dob DESC;

UPDATE wp_usermeta
SET meta_key=DATE_FORMAT(STR_TO_DATE(meta_value,'%d/%m/%Y'),'%Y-%m-%d')
WHERE meta_key='bhaa_runner_dateofbirth'
  AND meta_value REGEXP '[[:digit:]]{1,2}/[[:digit:]]{1,2}/[[:digit:]]{4}'


-- 666
SELECT * FROM wp_users
WHERE ID NOT IN (SELECT user_id FROM wp_usermeta WHERE meta_key='bhaa_runner_gender');

-- create holding table
CREATE TABLE wp_bhaa_runner_nogender (
       ID bigint(20) NOT NULL
);
DELETE FROM wp_bhaa_runner_nogender;

INSERT INTO wp_bhaa_runner_nogender
SELECT ID FROM wp_users
WHERE ID NOT IN (SELECT user_id FROM wp_usermeta WHERE meta_key='bhaa_runner_gender');

SELECT * FROM wp_bhaa_runner_nogender;


-- Runners will no gender
SELECT race, runner, racetime, class, position, gender.meta_value as gender
FROM wp_bhaa_raceresult
       LEFT JOIN wp_usermeta gender on (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key='bhaa_runner_gender')
WHERE race=7073
  AND gender.meta_value IS NULL
  AND class='RAN'
order by position;

-- insert missing genders (BMS 6266,DCC 6652
insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT wp_bhaa_raceresult.runner,'bhaa_runner_gender','M'
FROM wp_bhaa_raceresult
       LEFT JOIN wp_usermeta gender on (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key='bhaa_runner_gender')
WHERE wp_bhaa_raceresult.race=6652
  AND gender.meta_value IS NULL
  AND wp_bhaa_raceresult.class='RAN';

SELECT race,r.post_title,rm.meta_value as racetype,
CASE rm.meta_value
WHEN 'C' THEN 'M'
ELSE rm.meta_value
END as gender,
runner,u.display_name FROM wp_bhaa_raceresult
JOIN wp_posts r ON r.id=race
JOIN wp_postmeta rm on (rm.post_id=r.id AND rm.meta_key='bhaa_race_type')
JOIN wp_users u on u.id=runner
WHERE runner in (SELECT ID FROM wp_bhaa_runner_nogender);

INSERT INTO wp_usermeta(user_id, meta_key, meta_value)
SELECT runner as user_id,
       'bhaa_runner_gender' as meta_key,
       CASE rm.meta_value
              WHEN 'C' THEN 'M'
              ELSE rm.meta_value
              END as meta_value
FROM wp_bhaa_raceresult
            JOIN wp_posts r ON r.id=race
            JOIN wp_postmeta rm on (rm.post_id=r.id AND rm.meta_key='bhaa_race_type')
            JOIN wp_users u on u.id=runner
WHERE runner in (SELECT ID FROM wp_bhaa_runner_nogender);

--
SELECT * FROM wp_users
WHERE ID NOT IN (SELECT user_id FROM wp_usermeta WHERE meta_key='bhaa_runner_gender');

SELECT u.ID,rr.id FROM wp_users u
                              JOIN wp_bhaa_raceresult rr on rr.runner=u.ID
WHERE u.ID IN (SELECT user_id FROM wp_usermeta WHERE meta_key='bhaa_runner_gender');



-- ------
-- no DOB
-- ------
SELECT * FROM wp_users
WHERE ID NOT IN (SELECT user_id FROM wp_usermeta WHERE meta_key='bhaa_runner_dateofbirth');


-- find raceresult without a runner
select * from wp_bhaa_raceresult
                     left join wp_users on wp_users.id=runner
where wp_users.id is null;

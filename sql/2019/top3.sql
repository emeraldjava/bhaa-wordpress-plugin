6771




-- first three
SELECT * FROM wp_bhaa_raceresult
WHERE race=6771
AND position<=3;

SELECT * FROM wp_bhaa_raceresult
WHERE race=6771
AND posincat<=3


SELECT * FROM wp_bhaa_raceresult
WHERE race=6771
AND posincat<=3
AND category="S";

SELECT * FROM wp_bhaa_agecategory


S	M	18	34



-- ID : 19951 / NAME : Darragh Rennicks
SELECT * FROM wp_users WHERE ID=19951;
SELECT * FROM wp_usermeta WHERE user_id=19951;
SELECT meta_value FROM wp_usermeta WHERE user_id=19951 AND meta_key='bhaa_runner_dateofbirth';

-- age calculation
SELECT meta_value as birthDate,
YEAR(meta_value) as dob_year,
CURDATE() as now,
RIGHT(CURDATE(),5) as now_md,
RIGHT(meta_value,5) as dob_md,
(YEAR(CURDATE())-YEAR(meta_value)) - (RIGHT(CURDATE(),5)<RIGHT(meta_value,5)) as age
FROM wp_usermeta WHERE user_id=19951 AND meta_key='bhaa_runner_dateofbirth';

-- top three

SET _age = (YEAR(_currentDate)-YEAR(_birthDate)) - (RIGHT(_currentDate,5)<RIGHT(_birthDate,5));
RETURN (SELECT category FROM wp_bhaa_agecategory WHERE (_age between min and max) and gender=_gender);

SELECT runner
FROM wp_bhaa_raceresult
JOIN wp_usermeta gender on (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key='bhaa_runner_gender')
WHERE race = 6771
AND class='RAN'
AND gender.meta_value='M'
ORDER BY position;


CREATE PROCEDURE `updatePositionInAgeCategory`(_raceId INT(11),_gender ENUM('M','W'))
BEGIN

 DECLARE _nextCategory VARCHAR(6);
   DECLARE no_more_rows BOOLEAN;
   DECLARE loop_cntr INT DEFAULT 0;
   DECLARE num_rows INT DEFAULT 0;
   DECLARE _catCursor CURSOR FOR select category from wp_bhaa_agecategory;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;
   OPEN _catCursor;
   SELECT FOUND_ROWS() into num_rows;
    the_loop: LOOP
    FETCH _catCursor INTO _nextCategory;
    IF no_more_rows THEN
        CLOSE _catCursor;
        LEAVE the_loop;
    END IF;
   CREATE TEMPORARY TABLE tmpCategoryRaceResult(actualposition INT PRIMARY KEY AUTO_INCREMENT, runner INT);
    INSERT INTO tmpCategoryRaceResult(runner)
    SELECT runner
    FROM wp_bhaa_raceresult
    JOIN wp_usermeta gender on (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key='bhaa_runner_gender')
    WHERE race = _raceId
    AND category = _nextCategory
    AND class='RAN'
    AND gender.meta_value=_gender
    ORDER BY position;
    UPDATE wp_bhaa_raceresult, tmpCategoryRaceResult
    SET wp_bhaa_raceresult.posincat = tmpCategoryRaceResult.actualposition
    WHERE wp_bhaa_raceresult.runner = tmpCategoryRaceResult.runner AND wp_bhaa_raceresult.race = _raceId;
    DELETE FROM tmpCategoryRaceResult;
    SET loop_cntr = loop_cntr + 1;
  DROP TEMPORARY TABLE tmpCategoryRaceResult;
  END LOOP the_loop;
END$$
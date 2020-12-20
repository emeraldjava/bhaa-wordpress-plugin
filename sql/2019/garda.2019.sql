
SELECT race, runner, racetime, class, position
FROM wp_bhaa_raceresult
WHERE race=7073




select race, runner, racetime, class, @row:=@row+1
from wp_bhaa_raceresult, (SELECT @row:=0) r
where race=7073 AND class='RAN' order by racetime;

	    https://bhaa.ie/wp-admin/post.php?post=7073&action=edit

	    14,410,1236,00:14:30,Cox,Orla,W,9,13/05/1975,B,Symantec,519,Online Member,43,B,,,40W,1,2,,M,,,,,,
15,365,20176,00:14:49,Muldowney,Maeve,W,10,24/12/1985,W,,,Member,33,W,,,SW,10,0,,M,,,,,,
16,745,-745,00:14:58,Losty,Ciara,W,,22/10/1977,B,Mentor,1,Online Day,41,B,,,40W,2,2,,D,,,,,,

select race, runner, racetime, class, position, gender.meta_value as gender, COALESCE(gender.meta_value,'F')
from wp_bhaa_raceresult
LEFT JOIN wp_usermeta gender on (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key='bhaa_runner_gender')
where race=7073 AND class='RAN' order by position;


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
			 LEFT JOIN wp_usermeta gender on (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key='bhaa_runner_gender')
WHERE race = _raceId
	AND category = _nextCategory
	AND class='RAN'
	AND COALESCE(gender.meta_value,_gender)=_gender
ORDER BY position;
UPDATE wp_bhaa_raceresult, tmpCategoryRaceResult
SET wp_bhaa_raceresult.posincat = tmpCategoryRaceResult.actualposition
WHERE wp_bhaa_raceresult.runner = tmpCategoryRaceResult.runner AND wp_bhaa_raceresult.race = _raceId;
DELETE FROM tmpCategoryRaceResult;
SET loop_cntr = loop_cntr + 1;
DROP TEMPORARY TABLE tmpCategoryRaceResult;
END LOOP the_loop;
END

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

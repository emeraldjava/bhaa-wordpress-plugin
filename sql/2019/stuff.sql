
select * from wp_bhaa_raceresult
left join wp_users on wp_users.id=runner
left join wp_usermeta on (wp_users.id=wp_usermeta.user_id and wp_usermeta.meta_key='bhaa_runner_standard')
GROUP BY user_id
HAVING count(wp_usermeta.umeta_id) = 0;

select * from wp_users
left join wp_usermeta on (wp_users.ID=wp_usermeta.user_id and wp_usermeta.meta_key='bhaa_runner_gender')
GROUP BY wp_usermeta.user_id
HAVING count(wp_usermeta.umeta_id) = 0;

-- 14289
SELECT COUNT(ID) FROM wp_users;

-- count rows of raw metadata 13613
SELECT COUNT(user_id) FROM wp_usermeta WHERE meta_key='bhaa_runner_gender';
SELECT COUNT(user_id) FROM wp_usermeta WHERE meta_key='bhaa_runner_standard';
SELECT COUNT(user_id) FROM wp_usermeta WHERE meta_key='bhaa_runner_dateofbirth';



SELECT wp_users.id as id,
TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
TRIM(first_name.meta_value) as firstname,
TRIM(last_name.meta_value) as lastname,
wp_users.user_email as email,
CASE WHEN reg.REG_paid = "10.000" THEN "M" ELSE "D" END as status,
"2018-03-30" AS renewaldate,
COALESCE(gender.meta_value,"M") as gender,
CASE WHEN house.post_title IS NOT NULL THEN TRIM(house.post_title) ELSE COALESCE(TRIM(ee_company.ANS_value),"Day Runner") END AS companyname,
COALESCE(r2c.p2p_from,1) as companyid,
CASE WHEN r2s.p2p_from IS NOT NULL THEN TRIM(sectorteam.post_title) ELSE COALESCE(TRIM(house.post_title),"Day Runner") END AS teamname,
CASE WHEN r2s.p2p_from IS NOT NULL THEN r2s.p2p_from ELSE COALESCE(r2c.p2p_from,1) END AS teamid,
COALESCE(standard.meta_value,10) as standard,
COALESCE(dob.meta_value,"1980-01-01") as dob,
reg.REG_paid as paid
FROM wp_esp_registration as reg
JOIN wp_usermeta eeAttendee on (eeAttendee.meta_value=reg.ATT_ID and eeAttendee.meta_key="wp_EE_Attendee_ID")
JOIN wp_users on (eeAttendee.user_id=wp_users.id)
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
LEFT JOIN wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = "house_to_runner")
LEFT JOIN wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = "sectorteam_to_runner")
LEFT JOIN wp_posts house on (house.id=r2c.p2p_from and house.post_type="house")
LEFT JOIN wp_posts sectorteam ON (sectorteam.id=r2s.p2p_from AND sectorteam.post_type="house")
LEFT JOIN wp_esp_answer ee_company ON (ee_company.REG_ID=reg.REG_ID and ee_company.QST_ID=12)
WHERE reg.EVT_ID=7140
AND reg.REG_paid!=0
ORDER BY lastname ASC, firstname ASC


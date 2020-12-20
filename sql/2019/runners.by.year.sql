
select u.ID, u.display_name, dor.meta_value as dor
from wp_users u
join wp_usermeta m_status
on (m_status.user_id=u.id
and m_status.meta_key="bhaa_runner_status"
and m_status.meta_value="M")
join wp_usermeta dor
on (dor.user_id=u.id
and dor.meta_key="bhaa_runner_dateofrenewal")
where MONTH(dor.meta_value)=02 AND YEAR(dor.meta_value)=2018
order by dor.meta_value ASC;

select MONTH(DATE(dor.meta_value)) as month,
  MONTHNAME(DATE(dor.meta_value)) as monthname,
  YEAR(DATE(dor.meta_value)) as year,
  count(m_status.umeta_id) as count
from wp_users
   join wp_usermeta m_status
        on (m_status.user_id=wp_users.id
          and m_status.meta_key="bhaa_runner_status"
          and m_status.meta_value="M")
   join wp_usermeta dor
        on (dor.user_id=wp_users.id and dor.meta_key="bhaa_runner_dateofrenewal")
where DATE(dor.meta_value)>=DATE("2017-01-01")
group by YEAR(DATE(dor.meta_value)), MONTHNAME(DATE(dor.meta_value))
order by YEAR(DATE(dor.meta_value)) DESC, MONTH(DATE(dor.meta_value)) DESC;

http://localhost/wp-admin/admin.php?page=bhaa_process_expresso_runner&url_link=1-0349a19ca20eae85bc473be2c9af9750&re_id=2602

-- 6907
SELECT reg.*, bhaa_id.user_id AS runner_id FROM wp_esp_registration reg
JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key='wp_EE_Attendee_ID')
WHERE REG_url_link='1-0349a19ca20eae85bc473be2c9af9750'

SELECT bhaa_id.user_id AS runner_id, reg.EVT_ID as event_id FROM wp_esp_registration reg
JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key='wp_EE_Attendee_ID')
WHERE REG_url_link='1-0349a19ca20eae85bc473be2c9af9750';

SELECT reg.* FROM wp_esp_registration reg
WHERE YEAR(REG_date)=2019
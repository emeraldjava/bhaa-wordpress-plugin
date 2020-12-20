SQL Queries #102

https://github.com/emeraldjava/bhaawp/issues/102

-- 50-DublinHalf-2014.sql

INSERT INTO wp_bhaa_raceresult(race,runner,racetime,position,racenumber,category,standard,class,company)
SELECT 3841,2075,'01:00:00',1,2075,
getAgeCategory(
(SELECT meta_value from wp_usermeta WHERE user_id=2075 and meta_key='bhaa_runner_dateofbirth'),
'2014-09-20',
(SELECT meta_value from wp_usermeta WHERE user_id=2075 and meta_key='bhaa_runner_gender')) as agecat,
(SELECT meta_value from wp_usermeta WHERE user_id=2075 and meta_key='bhaa_runner_standard') as standard,
'RAN',
(SELECT meta_value from wp_usermeta WHERE user_id=2075 and meta_key='bhaa_runner_company') as company
FROM wp_users
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017

AGM 2013

-- event breakdown
select event_slug,
(select count(distinct(rr.runner)) from wp_bhaa_raceresult rr where rr.race in
(select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=post_id)) as total,
(select count(distinct(rr.runner)) from wp_bhaa_raceresult rr
JOIN wp_usermeta gender ON (gender.user_id=rr.runner AND gender.meta_key='bhaa_runner_gender')
where rr.race in (select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=post_id)
and gender.meta_value="M") as male,
(select count(distinct(rr.runner)) from wp_bhaa_raceresult rr
JOIN wp_usermeta gender ON (gender.user_id=rr.runner AND gender.meta_key='bhaa_runner_gender')
where rr.race in (select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=post_id)
and gender.meta_value="W") as female,
(select count(distinct(rr.runner)) from wp_bhaa_raceresult rr
JOIN wp_usermeta status ON (status.user_id=rr.runner AND status.meta_key='bhaa_runner_status')
where rr.race in (select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=post_id)
and status.meta_value="M") as member,
(select count(distinct(rr.runner)) from wp_bhaa_raceresult rr
JOIN wp_usermeta status ON (status.user_id=rr.runner AND status.meta_key='bhaa_runner_status')
where rr.race in (select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=post_id)
and status.meta_value!="M") as nonbhaa
from wp_em_events
where YEAR(event_start_date)=2013

-- 1080 members
select COUNT(DISTINCT(status.user_id)) from wp_usermeta status
where status.meta_key='bhaa_runner_status'
and status.meta_value="M"
select COUNT(DISTINCT(status.user_id)) from wp_usermeta status
where status.meta_key='bhaa_runner_status'
and status.meta_value="D"
select COUNT(DISTINCT(status.user_id)) from wp_usermeta status
where status.meta_key='bhaa_runner_status'
and status.meta_value="I"

select status.meta_value,COUNT(DISTINCT(status.user_id)) from wp_usermeta status
where status.meta_key='bhaa_runner_status'
GROUP BY status.meta_value

-- new BHAA members in 2013 341
select COUNT(DISTINCT(status.user_id))
from wp_usermeta status
join wp_users u on (u.id=status.user_id)
where status.meta_key='bhaa_runner_status'
and status.meta_value="M"
and YEAR(u.user_registered)=2013

select ID,fn.meta_value,ln.meta_value,user_email from wp_users u
join wp_usermeta s on (s.user_id=u.id and s.meta_key='bhaa_runner_status' and s.meta_value="M")
join wp_usermeta fn on (fn.user_id=u.id and fn.meta_key='first_name')
join wp_usermeta ln on (ln.user_id=u.id and ln.meta_key='last_name')
where YEAR(u.user_registered)=2013

(select meta_value from wp_users where user_id=status.user_id AND meta_key='first_name') as fn,
(select meta_value from wp_users where user_id=status.user_id AND meta_key='last_name') as ln

left JOIN wp_usermeta fn ON (fn.user_id=u.id AND fn.meta_key='first_name')
left JOIN wp_usermeta ln ON (ln.user_id=u.id AND ln.meta_key='last_name')

-- all race results for 2013
select COUNT(id) from wp_bhaa_raceresult rr
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=rr.race)
join wp_em_events e on (e.post_id=e2r.p2p_from)
where YEAR(e.event_start_date)=2013 and rr.class='RAN'

-- age profile
select count(id) as runnercount, agecat, gender
from
(
select ID,gender.meta_value as gender,getAgeCategory(dob.meta_value,curdate(),'M') as agecat from wp_users
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key='bhaa_runner_dateofbirth')
where status.meta_value="M"
) t1
group by t1.agecat,t1.gender
order by t1.agecat;

select ID,user_nicename,dob.meta_value,gender.meta_value,getAgeCategory(dob.meta_value,curdate(),'M') as agecat from wp_users
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key='bhaa_runner_dateofbirth')
where status.meta_value="M";

-- dob format
select * from wp_usermeta where meta_value='18-02-74'
update wp_usermeta set meta_value='1982-07-09' where umeta_id=177381;
update wp_usermeta set meta_value='1974-02-18' where umeta_id=177413;

select *, (meta_value NOT REGEXP '^\d{4}-\d{1,2}-\d{1,2}') as regex from wp_usermeta where meta_key='bhaa_runner_dateofbirth';

select status.user_id,getagecategory(ru.dateofbirth, curdate(), ru.gender, 0) from wp_usermeta status
where status.meta_key='bhaa_runner_status'
and status.meta_value="M"

select ru.id, getagecategory(ru.dateofbirth, curdate(), ru.gender, 0) as agecat
from runner ru
where ru.status='M' and ru.dateofrenewal >= '2011-1-1'

delete from wp_em_events where event_id in (3,2351)

-- all runners in an event
select count(distinct(rr.runner)) from wp_bhaa_raceresult rr where rr.race in
(select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=2121)

-- member status M|D
select count(distinct(rr.runner)) from wp_bhaa_raceresult rr
JOIN wp_usermeta status ON (status.user_id=rr.runner AND status.meta_key='bhaa_runner_status')
where rr.race in (select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=2121)
and status.meta_value="D";

-- Gender M|W
select count(distinct(rr.runner)) from wp_bhaa_raceresult rr
JOIN wp_usermeta gender ON (gender.user_id=rr.runner AND gender.meta_key='bhaa_runner_gender')
where rr.race in (select p2p_to from wp_p2p where p2p_type='event_to_race' and p2p_from=2121)
and gender.meta_value="W";

select * from wp_p2p where p2p_type='event_to_race' and p2p_from=2121

select * from wp_bhaa_raceresult where race=2359

-- league winners
select leaguedivision,leagueposition,leaguepoints,u.user_nicename,fn.meta_value,ln.meta_value,u.user_email,mobile.meta_value from wp_bhaa_leaguesummary
join wp_users u on u.id=leagueparticipant
left JOIN wp_usermeta mobile ON (mobile.user_id=u.id AND mobile.meta_key='bhaa_runner_mobilephone')
left JOIN wp_usermeta fn ON (fn.user_id=u.id AND fn.meta_key='first_name')
left JOIN wp_usermeta ln ON (ln.user_id=u.id AND ln.meta_key='last_name')
where league=2659
and leagueposition<=10
order by leaguedivision,leagueposition
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
alsaa 2017

SELECT * FROM wp_bhaa_raceresult WHERE race=5062;

SELECT position,racetime,TIME_FORMAT(racetime, '%H:%i:%s'),ADDTIME(TIME_FORMAT(racetime, '%H:%i:%s'),'0:05:05.0') FROM wp_bhaa_raceresult WHERE race=5062;

UPDATE wp_bhaa_raceresult
SET racetime=ADDTIME(TIME_FORMAT(racetime, '%H:%i:%s'),'0:05:05.0')
WHERE race=5062;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017

#DCM 2013

-- http://dublinmarathon.ie/results/

INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,11046,'02:45:13','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,22835,'03:19:38','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,22858,'03:19:36','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,7370,'03:44:20','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,22860,'03:52:42','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,22854,'03:59:03','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,7377,'04:22:48','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2856,7373,'04:36:34','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (10,2856,23990,'03:19:38','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (13,2856,4738,'02:29:30','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (16,2856,5622,'02:32:03','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (25,2856,1716,'02:34:52','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (33,2856,5253,'02:36:47','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (52,2856,7327,'02:39:18','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (1801,2856,6549,'03:28:30','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (8732,2856,8732,'03:53:33','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7769,2856,7769,'02:59:38','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5592,2856,5592,'03:39:00','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5028,2856,5028,'03:40:10','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (80,2856,7458,'02:44:22','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (501,2856,6159,'03:05:24','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5972,2856,23756,'04:05:47','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (9383,2856,9383,'04:28:22','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (6038,2856,6038,'02:40:22','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (4693,2856,4693,'02:49:46','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (8118,2856,8118,'03:29:20','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5361,2856,5361,'03:39:44','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (23257,2856,23257,'03:30:21','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7617,2856,7617,'05:17:50','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (23296,2856,23296,'03:31:40','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (6750,2856,6750,'02:53:55','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7602,2856,7602,'05:29:28','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (4561,2856,4561,'03:52:30','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7595,2856,7595,'04:17:48','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7458,2856,7458,'02:44:13','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7382,2856,7382,'03:54:15','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5798,2856,5798,'03:50:26','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5788,2856,5788,'03:37:26','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7013,2856,7013,'03:35:59','RAN');
call updatePositions(2856);
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017

#dublin half 2013

update dublinhalf2013entry set name=CONCAT(FirstName,' ',Surname)

select * from dublinhalf2013 where position=13;

select * from dublinhalf2013entry where BHAA=7713;

INSERT INTO wp_bhaa_raceresult(race, runner, racetime, position, racenumber,class)
select 2855,e.BHAA,r.time,r.position,r.racenumber,'RAN' from dublinhalf2013entry e
join dublinhalf2013 r on (r.name=e.name)

select rr.* from wp_bhaa_raceresult rr where race=2855;
delete from wp_bhaa_raceresult where runner=7713 and racenumber

select status.meta_value,rr.* from wp_bhaa_raceresult rr
join wp_users on rr.runner=wp_users.id
join wp_usermeta standard on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_standard')
where race=2855;

select * from wp_bhaa_raceresult where race=2855;
delete from wp_bhaa_raceresult where id=32833;

select * from wp_bhaa_raceresult where race=2855 and runner=6035;
select runner,COUNT(runner) from wp_bhaa_raceresult where race=2855 group by runner;
getRunnerLeagueSummary

-- update the standard
update wp_bhaa_raceresult rr
join wp_users on rr.runner=wp_users.id
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_standard')
set rr.standard=status.meta_value
where rr.race=2855 and status.meta_value!='';

-- company runners
select meta.meta_value,rr.* from wp_bhaa_raceresult rr
join wp_users on rr.runner=wp_users.id
left join wp_usermeta meta on (meta.user_id=wp_users.id and meta.meta_key='bhaa_runner_company')
where race=2855 and meta.meta_value!='';

-- company runners
select meta.meta_value,rr.* from wp_bhaa_raceresult rr
join wp_users on rr.runner=wp_users.id
left join wp_usermeta meta on (meta.user_id=wp_users.id and meta.meta_key='bhaa_runner_company')
where race=2855 and meta.meta_value!='';

INSERT INTO wp_bhaa_raceresult(id, race, runner, racetime, position, racenumber,class) VALUES ([value-1],[value-2],[value-3],[value-4],[value-5],[value-6],[value-7],[value-8],[value-9],[value-10],[value-11],[value-12],[value-13],[value-14],[value-15],[value-16],[value-17],[value-18])

select * from wp_bhaa_raceresult where runner=7713;
select * from wp_bhaa_raceresult where runner=7016;

select * from dublinhalf2013entry
where BHAA NOT IN (select runner from wp_bhaa_raceresult where race=2855);

select * from dublinhalf2013 where name like '%Sinclair%';

INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,7373,'02:09:47','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,6446,'02:19:47','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,6448,'02:19:44','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,6350,'01:39:47','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,1549,'01:29:47','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,1627,'01:29:47','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,1515,'02:21:26','RAN');
INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,7016,'02:44:11','RAN');

INSERT INTO wp_bhaa_raceresult(race,runner,racetime,class) VALUES (2855,6933,'02:51:44','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (1300,2855,5101,'01:44:53','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (1300,2855,8732,'01:48:39','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (1,2855,7088,'01:08:21','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7175,2855,7175,'03:28:21','RAN');

INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (4693,2855,4693,'01:20:05','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (5361,2855,5361,'01:33:42','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (6750,2855,6750,'01:20:46','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7602,2855,7602,'02:21:36','RAN');
INSERT INTO wp_bhaa_raceresult(position,race,runner,racetime,class) VALUES (7595,2855,7595,'01:52:36','RAN');

call updatePositions(2855);
call updateRaceScoringSets(2855);
call updateRaceLeaguePoints(2855);
call updateLeagueData(2659);

delete from wp_bhaa_raceresult where race=2855 and runner=6933;

-- teams
select * from wp_bhaa_raceresult rr
join wp_users u on u.id=rr.runner
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=121

select * from wp_bhaa_raceresult rr
join wp_users u on u.id=rr.runner
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'sectorteam_to_runner')
where race=2855 and r2c.p2p_from=52

select * from wp_p2p where p2p_from=52
select * from wp_posts where ID=52

delete from wp_bhaa_teamresult where race=2855;
-- ladies h A
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'W',1,6,52,52,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'sectorteam_to_runner')
where race=2855 and r2c.p2p_from=52;

-- fire men A
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',7,1,159,159,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=159 and position<75 order by position;

insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'C',2,5,159,159,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=159 and position>75 order by position;

-- garda
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',8,1,94,94,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=94 and position<130 order by position;

-- RTE A
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',1,6,121,121,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=121 and position<50 order by position;

insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'B',3,4,121,121,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=121 and position>50 order by position;

-- DCC
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',4,3,93,93,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=93 and position<50 order by position;

-- revenue A
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',5,2,137,137,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=137 and position<70 order by position;

-- revenue B
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'C',1,6,137,137,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=137 and position>70 and position<120 order by position;

-- esb
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'B',1,6,97,97,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=97 and position<70 order by position;

-- eircom
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',6,1,110,110,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=110 and position<120 order by position;

-- boi
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',2,5,161,161,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=161 and position>1 order by position;

-- swords labs
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'A',3,4,204,204,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=204 and position>1 order by position;

-- zurich
insert into wp_bhaa_teamresult(class,position,leaguepoints,team,company,runner,pos,std,racetime,id,race,totalpos,totalstd)
select 'B',2,5,175,175,rr.runner,rr.position,rr.standard,rr.racetime,null,2855,1,1 from wp_bhaa_raceresult rr
join wp_users u on (u.id=rr.runner)
join wp_p2p r2c ON (r2c.p2p_to=u.id AND r2c.p2p_type = 'house_to_runner')
where race=2855 and r2c.p2p_from=175 and position>1 order by position;

update wp_bhaa_raceresult set standard=13 where race=2855 and runner=7373;
update wp_bhaa_raceresult set standard=10 where race=2855 and runner=1704;
-- update sums
UPDATE wp_bhaa_teamresult tr
JOIN (
select race,class,team,SUM(pos) as totalpos,SUM(std) as totalstd from wp_bhaa_teamresult
where race=2855 group by race,team,class
) i
ON tr.race=i.race and tr.team=i.team and tr.class=i.class
SET tr.totalpos=i.totalpos,tr.totalstd=i.totalstd;
-- update names
UPDATE wp_bhaa_teamresult tr
JOIN wp_posts h on (tr.team=h.id and h.post_type='house')
set tr.teamname=h.post_title,tr.companyname=h.post_title
where race=2855;

select * from wp_bhaa_teamresult where race=2855 order by class,totalpos;
delete from wp_bhaa_teamresult where race=2855;

-- sum postions and standards
select team,SUM(pos) as totalpos,SUM(std) as totalstd from wp_bhaa_teamresult
where race=2855 group by team,race

select MIN(totalstd),MAX(totalstd) from wp_bhaa_teamresult where class = "D" ('A','B','C','D')
select * from wp_bhaa_division
select from wp_meta where user

select wp_bhaa_teamresult.*,wp_users.display_name from wp_bhaa_teamresult
join wp_users on wp_users.id=wp_bhaa_teamresult.runner
where race=2855 order by class,position,team

call getRunnerLeagueSummary(5101,2812,'M');
select getRunnerLeagueSummary(6553,2812,'M');

update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(leagueparticipant,2812,'M') where league=2812 and leaguedivision in ('D');

select * from wp_bhaa_raceresult where race>=2596 and race<=2855 and class='PRE_REG'
delete from wp_bhaa_raceresult where race>=2596 and race<=2855 and class='PRE_REG'

select * from wp_bhaa_raceresult where runner=6553 and race>=2596 and race<=2855
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
league summary columns

call getTeamLeagueSummary(3709,161,'M');

-- list all the races for a league
SELECT *
from wp_bhaa_race_detail rd
where rd.league=3709
and rd.racetype in ('C','S','W')
and rd.racetype!='TRACK'
order by rd.eventdate asc

-- select all the races, then left join to results for an individual
SELECT *
select GROUP_CONCAT(CAST(CONCAT(IFNULL(rr.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')
from wp_bhaa_race_detail rd
left join wp_bhaa_raceresult rr on (rr.race=rd.race and rr.runner=7713)
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
order by rd.eventdate asc

-- select all the races, then left join to results for a team
SELECT *
select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')
from wp_bhaa_race_detail rd
LEFT join wp_bhaa_teamsummary ts on (rd.race=ts.race and ts.team=161 AND ts.class!='W')
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
order by rd.eventdate asc

SELECT *
select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race and ts.team=161 AND ts.class='W')
where rd.league=3709
and rd.racetype in ('C','S','W')
and rd.racetype!='TRACK'
order by rd.eventdate asc

SELECT * FROM wp_bhaa_leaguesummary
WHERE league=3709
AND leagueparticipant=161

SELECT * FROM wp_bhaa_teamresult
WHERE team=161

AND leaguedivision='W'

SELECT getLeagueMTeamSummary(leagueparticipant,league) FROM wp_bhaa_leaguesummary
WHERE league=3709 and leaguedivision='M' and leagueparticipant=161;

SELECT getLeagueWTeamSummary(leagueparticipant,league) FROM wp_bhaa_leaguesummary
WHERE league=3709 and leaguedivision='W' and leagueparticipant=161;

-- BOI womans team summer league 2014

INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,
leaguedivision,leagueposition,leaguesummary)
select
l.league as league,
'T' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'W' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT(CAST(CONCAT_WS(':',l.event,ts.leaguepoints,IF(ts.class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=3709
AND ts.class='W'
and racetype in ('C','W')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc

-- display the total number of runners in specific league division
select d.*,count(ls.leagueparticipant) from wp_bhaa_division d
join wp_bhaa_leaguesummary ls
on ls.leaguedivision=d.code
where ls.league=3637
group by d.code

SELECT ls.*,wp_users.display_name as display_name
FROM wp_bhaa_leaguesummary ls
LEFT join wp_users on wp_users.id=ls.leagueparticipant
LEFT join wp_posts on wp_posts.post_type="house" and wp_posts.id=
(select meta_value from wp_usermeta where user_id=ls.leagueparticipant and meta_key="bhaa_runner_company")
WHERE ls.league = 3637
AND ls.leaguedivision = 'A'
AND ls.leagueposition <= 10
AND ls.leaguescorecount>=2
order by league, leaguedivision, leagueposition

SELECT d.*,count(ls.leagueparticipant) as count FROM wp_bhaa_division d
JOIN wp_bhaa_leaguesummary ls on ls.leaguedivision=d.code
WHERE ls.league=3637
AND ls.leaguescorecount>=2
AND d.code='A'
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
lord mayor series 2015

CREATE TABLE IF NOT EXISTS importusers (
id varchar(5) DEFAULT NULL,
name varchar(20) DEFAULT NULL,
firstname varchar(20) DEFAULT NULL,
surname varchar(20) DEFAULT NULL,
gender varchar(1) DEFAULT "M",
dob varchar(20) DEFAULT NULL,
dob2 varchar(20) DEFAULT NULL,
email varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO wp_users(ID, user_login, user_pass, user_nicename, user_email, user_url,
user_registered, user_activation_key, user_status, display_name)
SELECT
u.ID,
CONCAT(LOWER(TRIM(firstname)),'.',LOWER(TRIM(surname))),
u.ID,
CONCAT(LOWER(TRIM(firstname)),'.',LOWER(TRIM(surname))),
u.email,
'',
CURRENT_TIMESTAMP,
'',
0,
CONCAT(LOWER(TRIM(firstname)),'.',LOWER(TRIM(surname)))
from importusers u
WHERE u.ID != "";

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT u.id,'bhaa_runner_dateofbirth',dob
FROM importusers u;

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT u.id,'bhaa_runner_gender','M'
FROM importusers u;

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT u.id,'first_name',firstname
FROM importusers u;

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT u.id,'last_name',surname
FROM importusers u;

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT u.id,'bhaa_runner_status','D'
FROM importusers u;

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT u.id,'bhaa_runner_company',4295
FROM importusers u;

insert into wp_p2p(p2p_from,p2p_to,p2p_type)
SELECT 4295,u.id,'house_to_runner'
FROM importusers u;

SELECT ID FROM importusers
WHERE name = ''
WHERE ID

DELETE FROM wp_usermeta
WHERE user_id IN (SELECT ID FROM importusers
WHERE name = '')

DELETE FROM wp_users
WHERE ID IN (SELECT ID FROM importusers
WHERE name = '')

DELETE FROM importusers WHERE name = '';

INSERT INTO wp_em_bookings(event_id, person_id, booking_spaces, booking_comment, booking_date, booking_status, booking_price)
SELECT 165,u.ID,1,"Lord Mayor Series",CURRENT_DATE,1,15.00
FROM importusers u;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
mem 2016

-- 5022 1/2 marathon : https://bhaa.ie/events/sse-airtricity-dublin-half-marathon-2016/
SELECT mem.runner,r.user_nicename,mem.time FROM mem_2016 as mem
JOIN wp_users r on r.id=mem.runner
where race=5022
ORDER BY mem.time;

INSERT INTO wp_bhaa_raceresult(race, runner, racetime, racenumber,class)
select 5022,mem.runner,mem.time,mem.runner,'RAN' from mem_2016 mem
JOIN wp_users r on (r.id=mem.runner)
where race=5022

update wp_bhaa_raceresult rr
join wp_users on rr.runner=wp_users.id
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_standard')
set rr.standard=status.meta_value
where rr.race=5022 and status.meta_value!='';

call updatePositions(5022);
call updateRaceScoringSets(5022);
call updateRaceLeaguePoints(5022);
call updateLeagueData(5022);

-- 5009 marathon : https://bhaa.ie/events/sse-airtricity-dublin-marathon-2016/
SELECT * FROM mem_2016 where race=5009;

SELECT mem.runner,r.user_nicename,mem.time FROM mem_2016 as mem
JOIN wp_users r on r.id=mem.runner
where race=5009
ORDER BY mem.time;

DELETE FROM mem_2016 where race=5009 and runner=7270;
DELETE FROM mem_2016 where race=5009 and runner=7194;

INSERT INTO wp_bhaa_raceresult(race, runner, racetime, racenumber,class)
select 5009,mem.runner,mem.time,mem.runner,'RAN' from mem_2016 mem
JOIN wp_users r on (r.id=mem.runner)
where race=5009

update wp_bhaa_raceresult rr
join wp_users on rr.runner=wp_users.id
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_standard')
set rr.standard=status.meta_value
where rr.race=5009 and status.meta_value!='';
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
renewals 2015

-- renewals 2015

select MONTHNAME(DATE(dor.meta_value)),count(id)

-- autum 2014 runners
select u.id,u.user_email,status.meta_value,dor.meta_value
from wp_users u
join wp_usermeta status on (status.user_id=u.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=u.id and dor.meta_key='bhaa_runner_dateofrenewal')
where status.meta_value='M'
AND DATE(dor.meta_value)>=DATE("2014-10-01")
AND DATE(dor.meta_value)<=DATE("2015-01-10")

-- jan 2015 runners
select u.id,u.user_email,status.meta_value,dor.meta_value
from wp_users u
join wp_usermeta status on (status.user_id=u.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=u.id and dor.meta_key='bhaa_runner_dateofrenewal')
where status.meta_value='M'
AND DATE(dor.meta_value)>=DATE("2015-01-01")
AND DATE(dor.meta_value)<=DATE("2015-02-10")

select u.id,u.user_email,status.meta_value,dor.meta_value
from wp_users u
join wp_usermeta status on (status.user_id=u.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=u.id and dor.meta_key='bhaa_runner_dateofrenewal')
where status.meta_value='M'
AND DATE(dor.meta_value)>=DATE("2013-01-01")
AND DATE(dor.meta_value)<=DATE("2014-09-30")

select u.user_email
from wp_users u
join wp_usermeta status on (status.user_id=u.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=u.id and dor.meta_key='bhaa_runner_dateofrenewal')
where status.meta_value='M'
AND DATE(dor.meta_value)>=DATE("2013-01-01")
AND DATE(dor.meta_value)<=DATE("2014-09-30")
AND u.user_email IS NOT NULL
AND u.user_email !=''
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
summer league 2014

DELETE FROM wp_bhaa_race_detail where league=3709;
INSERT INTO wp_bhaa_race_detail (league,leaguetype,event,eventname,eventdate,race,racetype,distance,unit)
select
l2e.p2p_from as league,
leaguetype.meta_value as leaguetype,
event.ID as event,
event.post_title as eventname,
em.event_start_date as eventdate,
race.ID as race,
racetype.meta_value as racetype,
racedistance.meta_value as distance,
raceunit.meta_value as raceunit
from wp_p2p l2e
join wp_posts event on (l2e.p2p_to=event.ID)
join wp_em_events em on (event.id=em.post_id)
join wp_p2p e2r on (l2e.p2p_to=e2r.p2p_from AND e2r.p2p_type='event_to_race')
join wp_posts race on (e2r.p2p_to=race.ID)
LEFT join wp_postmeta racetype on (race.ID=racetype.post_id AND racetype.meta_key='bhaa_race_type')
LEFT join wp_postmeta racedistance on (race.ID=racedistance.post_id AND racedistance.meta_key='bhaa_race_distance')
LEFT join wp_postmeta raceunit on (race.ID=raceunit.post_id AND raceunit.meta_key='bhaa_race_unit')
LEFT join wp_postmeta leaguetype on (l2e.p2p_from=leaguetype.post_id AND leaguetype.meta_key='bhaa_league_type')
where l2e.p2p_type='league_to_event' and l2e.p2p_from IN (3709)
ORDER BY eventdate;

-- update all team summary
DELETE FROM wp_bhaa_teamsummary;
INSERT INTO wp_bhaa_teamsummary
SELECT
race,
team,
teamname,
min(totalstd) as totalstd,
min(totalpos) as totalpos,
class,
min(position)as position,
max(leaguepoints) as leaguepoints
FROM wp_bhaa_teamresult
WHERE position!=0
GROUP BY race,team
ORDER BY class,position;

DELETE FROM wp_bhaa_race_detail where league=3709
SELECT * FROM wp_bhaa_race_detail where league=3709

DELETE FROM wp_bhaa_leaguesummary WHERE league=3709 AND leaguedivision="M" AND leaguedivision="W" AND
SELECT * FROM wp_bhaa_leaguesummary WHERE league=3709 AND leaguedivision="M" AND leaguedivision="W"

-- mens teams
DELETE FROM wp_bhaa_leaguesummary where league=3709 and leaguedivision='M';
INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,
leaguedivision,leagueposition,leaguesummary)
select
l.league as league,
'T' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'M' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT(CAST(CONCAT_WS(':',l.event,ts.leaguepoints,IF(ts.class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ",") AS leagues,
GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY l.eventdate SEPARATOR ',') as ls,
GROUP_CONCAT( cast( concat_ws(':',l.event,ts.leaguepoints) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=3709
AND ts.class != 'W'
and racetype in ('C','M')
GROUP BY l.league,ts.team
HAVING COALESCE(leaguepoints, 0) > 0
ORDER BY leaguepoints desc,leaguescorecount desc;

GROUP BY le.id,rr.runner

-- individual format
select * from wp_bhaa_leaguesummary
where leagueparticipant=7713;

-- womens teams
DELETE FROM wp_bhaa_leaguesummary where league=3709 and leaguedivision='W';
INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,
leaguedivision,leagueposition,leaguesummary)
select
l.league as league,
'T' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'W' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT( cast( concat_ws(':',l.event,ts.leaguepoints) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=3709
AND ts.class ='W'
and racetype in ('C','W')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc;

-- update the team summary field
update wp_bhaa_leaguesummary
set leaguesummary=getTeamLeagueSummary(leagueparticipant,league,leaguedivision)
where league=3709;

SET @A=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@A:= (@A+1))
where leaguedivision="M" and league=_leagueId ORDER BY leaguepoints DESC;
SET @b=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@b:= (@b+1))
where leaguedivision="W" and league=_leagueId ORDER BY leaguepoints DESC;

-- the league
select * from wp_bhaa_leaguesummary where league=3709 ORDER BY leaguedivision,leaguepoints DESC
-- a summary of kclub 2014 results
select * from wp_bhaa_teamsummary where race=3529
-- all kclub 2014 team results
select * from wp_bhaa_teamresult where race=3529

select * FROM wp_bhaa_race_detail where league=3709;

select * from wp_bhaa_teamsummary

select * from wp_bhaa_race_detail where league=3709
select * from wp_postmeta where post_id=3709

select * from wp_postmeta where meta_key='bhaa_league_type'

SELECT * FROM wp_bhaa_leaguesummary
WHERE league=3709
AND leagueparticipant=110;

SELECT leaguesummary,REPLACE(leaguesummary,'4,4,4,','4,') FROM wp_bhaa_leaguesummary
WHERE leaguesummary IS NOT NULL;
AND league=3709
AND leagueparticipant=110;

UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'6,6,6,','6,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'5,5,5,','5,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'5.5,5.5,5.5,','5.5,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'4,4,4,','4,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'3,3,3,','3,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'2,2,2,','2,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'1,1,1,','1,')
WHERE league=3709;
UPDATE wp_bhaa_leaguesummary
SET leaguesummary = REPLACE(leaguesummary,'0,0,0,','0,')
WHERE league=3709;

SELECT REPLACE('www.mysql.com', 'w', 'Ww');

UPDATE

select *
select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')

from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=110 AND ts.class!='W')
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
order by rd.eventdate asc

select *
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=110 AND ts.class!='W')
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
GROUP BY league,event
order by rd.eventdate asc

select CONCAT(ts.leaguepoints)
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=110 AND ts.class!='W')
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
GROUP BY league,event
order by rd.eventdate asc

select GROUP_CONCAT(CAST(CONCAT(IFNULL(subselect.x,0)) AS CHAR) SEPARATOR ',') from (
select ts.leaguepoints as x
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=110 AND ts.class!='W')
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
GROUP BY league,event
order by rd.eventdate asc)
as subselect;

select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')
SELECT *
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=110 AND ts.class!='W')
where rd.league=3709
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
GROUP BY league,event
order by rd.eventdate asc

SELECT getTeamLeagueSummary(110,3709,'M')
SELECT getLeagueMTeamSummary(110,3709)

SELECT ls.*,wp_posts.post_title as display_name

FROM wp_bhaa_leaguesummary ls

left join wp_posts on (wp_posts.id=ls.leagueparticipant and wp_posts.post_type="house")

WHERE ls.league = 3709

AND ls.leaguedivision = 'M'

order by leaguepoints desc limit 10
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
track 2013

-- event 2662 /
-- summary event 2929 / race 2928

select wp_bhaa_raceresult.* from wp_bhaa_raceresult
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=2662)
where race= e2r.p2p_to

select race,runner,position,racenumber,category,standard,actualstandard,poststandard,MAX(leaguepoints) as leaguepoints,class from wp_bhaa_raceresult
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=2662)
where race= e2r.p2p_to
group by runner;

delete from wp_bhaa_raceresult where race=2928;
insert into wp_bhaa_raceresult (race,runner,position,racenumber,category,standard,actualstandard,poststandard,leaguepoints,class)
select 2928,runner,position,racenumber,category,standard,actualstandard,poststandard,MAX(leaguepoints) as leaguepoints,class
from wp_bhaa_raceresult
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=2662)
where race= e2r.p2p_to
group by runner;

select * from wp_bhaa_raceresult where race=2928;

select * from wp_p2p e2r where e2r.p2p_type='event_to_race' and e2r.p2p_from=2662

-- update race type to track
update wp_postmeta set meta_value='TRACK'
where meta_key='bhaa_race_type' and post_id in
(2850,2868,2914,2915,2916,2917,2918,2919,2920,2921,2922,2923,2924,2925,2926,2927);

-- link tcd summary race to event
INSERT INTO bhaaie_wp.wp_p2p (
p2p_id ,
p2p_from ,
p2p_to ,
p2p_type
)
VALUES (
NULL , '2662', '2928', 'event_to_race'
);

-- link tcd event to league
INSERT INTO bhaaie_wp.wp_p2p (
p2p_id ,
p2p_from ,
p2p_to ,
p2p_type
)
VALUES (
NULL , '2659', '2662', 'league_to_event'
);

select * from wp_bhaa_raceresult where race=2850 order by position
select * from wp_bhaa_raceresult where race=2928 order by position

call updateRace(2850);
call updateRace(2868);
call updateRace(2914);
call updateRace(2915);
call updateRace(2916);
call updateRace(2917);
call updateRace(2918);
call updateRace(2919);
call updateRace(2920);
call updateRace(2921);
call updateRace(2922);
call updateRace(2923);
call updateRace(2924);
call updateRace(2925);
call updateRace(2926);
call updateRace(2927);

-- BHAA MILE
select * from wp_p2p e2r where e2r.p2p_type='event_to_race' and e2r.p2p_from=2665;
-- set the races to track
update wp_postmeta set meta_value='TRACK'
where meta_key='bhaa_race_type' and post_id in
(2853,2964,2965,2966,2967,2968,2969,2971,2972);
-- link the summary race to the event
INSERT INTO bhaaie_wp.wp_p2p (
p2p_id ,
p2p_from ,
p2p_to ,
p2p_type
)
VALUES (
NULL , '2665', '3011', 'event_to_race'
);
-- link bhaa mile event to league
INSERT INTO bhaaie_wp.wp_p2p (
p2p_id ,
p2p_from ,
p2p_to ,
p2p_type
)
VALUES (
NULL , '2659', '2665', 'league_to_event'
);

update wp_bhaa_raceresult,wp_usermeta
set wp_bhaa_raceresult.standard=wp_usermeta.meta_value
where wp_usermeta.user_id=wp_bhaa_raceresult.runner
and wp_bhaa_raceresult.race in (2853,2964,2965,2966,2967,2968,2969,2971,2972)
and wp_usermeta.meta_key='bhaa_runner_standard'
and wp_usermeta.meta_value!='';

call updateRace(2853);
call updateRace(2964);
call updateRace(2965);
call updateRace(2966);
call updateRace(2967);
call updateRace(2968);
call updateRace(2969);
call updateRace(2971);
call updateRace(2972);

-- update summary race
delete from wp_bhaa_raceresult where race=3011;
insert into wp_bhaa_raceresult (race,runner,position,racenumber,category,standard,actualstandard,poststandard,leaguepoints,class)
select 3011,runner,position,racenumber,category,standard,actualstandard,poststandard,MAX(leaguepoints) as leaguepoints,class
from wp_bhaa_raceresult
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=2665)
where race= e2r.p2p_to
group by runner;

select * from wp_bhaa_raceresult where race=3011 and runner=6762;

-- in (2853,2964,2965,2966,2967,2968,2969,2971,2972)
select * from wp_bhaa_raceresult where race=2972 order by position desc
select * from wp_users where id=6486
select * from wp_usermeta where user_id=6486

select * from wp_bhaa_raceresult where race=3011 order by position desc

delete from wp_p2p where p2p_id=2280
select * from wp_p2p e2r where e2r.p2p_type='league_to_event' and e2r.p2p_from=2659

select * from wp_bhaa_raceresult where runner = 7640 order by race desc
select * from wp_usermeta where user_id=7640

select wp_usermeta.meta_value,wp_bhaa_raceresult.* from wp_bhaa_raceresult
join wp_usermeta on (wp_usermeta.user_id=wp_bhaa_raceresult.runner and wp_usermeta.meta_key='bhaa_runner_standard')
where race=2972 order by position desc
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
winter team league

-- 3615
select id,post_title from wp_posts where post_type="league";

select * from wp_bhaa_division
-- select the men/womens races in a league
select * from wp_bhaa_race_detail
where league=3615
and racetype in ("C","M");

select * from wp_bhaa_leaguesummary where league=3615;
delete from wp_bhaa_leaguesummary where league=3615;

-- populate individual league summary table
INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,
leaguedivision,leagueposition,leaguesummary)
select
l.league as league,
'I' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'M' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT( cast( concat_ws(':',l.event,ts.leaguepoints) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=3615
and racetype in ('C','M')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc;

INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,
leaguedivision,leagueposition,leaguesummary)
select
l.league as league,
'I' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'W' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT( cast( concat_ws(':',l.event,ts.leaguepoints) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=3615
and racetype in ('C','W')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc;

update wp_bhaa_leaguesummary
set leaguesummary=getTeamLeagueSummary(leagueparticipant,league,leaguedivision)
where league=;

-- TODO update league position & league summary

-- get the order of events/races in a league
select l.race,l.event,l.eventname,l.eventdate
from wp_bhaa_race_detail l
where league=3615
and racetype in ("C","M")
order by eventdate asc

-- get the specific results for a team
select ts.,l. from wp_bhaa_teamsummary ts
join wp_bhaa_race_detail l on (l.race=ts.race and l.racetype in ("C","M") and l.league=3615)
where ts.team=97

-- return 0 where team didn't run
select l.race,l.event,l.eventname,l.eventdate,IFNULL(ts.leaguepoints,0) as points
from wp_bhaa_race_detail l
left join wp_bhaa_teamsummary ts on (l.race=ts.race and ts.team=97)
where league=3615
and racetype in ("C","M")
order by eventdate asc

-- working team summary string
select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY l.eventdate SEPARATOR ',') as sumary
from wp_bhaa_race_detail l
left join wp_bhaa_teamsummary ts on (l.race=ts.race and ts.team=97)
where league=3615
and racetype in ("C","M")
order by eventdate asc

-- this don't work!
update wp_bhaa_leaguesummary ls
set ls.leaguesummary=(
select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY l.eventdate SEPARATOR ',')
from wp_bhaa_race_detail l
left join wp_bhaa_teamsummary ts on (l.race=ts.race and ts.team=ls.leagueparticipant)
where l.league=ls.league
and l.racetype in ("C","M")
order by l.eventdate asc
)
where ls.league=3615 and ls.leaguedivision='M'
order by ls.leaguepoints desc

-- display the league table
select league,leagueparticipant,leaguepoints,leaguesummary from wp_bhaa_leaguesummary
where league=3615 and leaguedivision='M'
order by leaguepoints desc

getTeamLeagueSummary(97,3615,'M');

select league,leagueparticipant,leaguepoints,getTeamLeagueSummary(leagueparticipant,league,'M') as s
from wp_bhaa_leaguesummary
where league=3615 and leaguedivision='M'
order by leaguepoints desc

select league,leagueparticipant,leaguepoints,getTeamLeagueSummary(leagueparticipant,league,'W') as s
from wp_bhaa_leaguesummary
where league=3615 and leaguedivision='W'
order by leaguepoints desc

select league,leaguedivision,leagueparticipant,leaguepoints,
getTeamLeagueSummary(leagueparticipant,league,leaguedivision) as s
from wp_bhaa_leaguesummary
where league=3615
order by leaguedivision,leaguepoints desc

update wp_bhaa_leaguesummary
set leaguesummary=getTeamLeagueSummary(leagueparticipant,league,leaguedivision)
where league=3615;

-- top ten per division
select leagueparticipant,u.display leagueposition,leaguedivision from wp_bhaa_leaguesummary ls
join wp_users u on ls.leagueparticipant=u.ID
where league=3103
and leagueposition<=10
order by leaguedivision,leagueposition

select leaguedivision,leagueposition,leaguepoints,u.user_nicename,fn.meta_value,
ln.meta_value,u.user_email,mobile.meta_value as mobile from wp_bhaa_leaguesummary
join wp_users u on u.id=leagueparticipant
left JOIN wp_usermeta mobile ON (mobile.user_id=u.id AND mobile.meta_key='bhaa_runner_mobilephone')
left JOIN wp_usermeta fn ON (fn.user_id=u.id AND fn.meta_key='first_name')
left JOIN wp_usermeta ln ON (ln.user_id=u.id AND ln.meta_key='last_name')
where league=3103
and leagueposition<=10
order by leaguedivision,leagueposition
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp bhaa league

-- schema setup
DROP TABLE wp_bhaa_teamresult;
DROP TABLE wp_bhaa_leaguesummary;
DROP TABLE wp_bhaa_race_detail;
DROP TABLE p2p;

-- http://sqlfiddle.com/#!2/87bf94
CREATE TABLE wp_bhaa_teamresult (
id int(11) auto_increment primary key,
race int(11) NOT NULL,
class varchar(1) NOT NULL,
raceteam int(11) NOT NULL,
position int(11) NOT NULL,
team int(11) NOT NULL,
teamname varchar(20),
leaguepoints double,
runner int(11) NOT NULL
);

CREATE TABLE wp_bhaa_teamsummary (
race int(11) NOT NULL,
team int(11) NOT NULL,
teamname varchar(20),
totalstd int(11) NOT NULL, -- aka team total std value
class varchar(1) NOT NULL, --
position int(11) NOT NULL,
leaguepoints double NOT NULL
);

-- simulate DCC, Kclub, RTE races
-- I've added 'raceteam' value to the table, which makes it easier to pick a multi garda team from a specific race
-- We should only record 'leaguepoints' against the best scoring team
-- The team league summing logic can then exclude teams with league points of 0.
INSERT INTO wp_bhaa_teamresult
(race,class,raceteam,position,team,teamname,leaguepoints,runner)
VALUES
(1,'A',1,1,97,'Garda',6,1),
(1,'A',1,1,97,'Garda',6,2),
(1,'A',1,1,97,'Garda',6,3),
(1,'A',2,2,91,'ESB',5,1),
(1,'A',2,2,91,'ESB',5,2),
(1,'A',2,2,91,'ESB',5,3),
(1,'A',3,3,90,'RTE',4,1),
(1,'A',3,3,90,'RTE',4,2),
(1,'A',3,3,90,'RTE',4,3),
(1,'B',4,1,1,'1',6,1),
(1,'B',4,1,1,'1',6,2),
(1,'B',4,1,1,'1',6,3),
(1,'B',5,2,2,'2',5,1),
(1,'B',5,2,2,'2',5,2),
(1,'B',5,2,2,'2',5,3),
(1,'B',7,3,90,'RTE',0,1),
(1,'B',7,3,90,'RTE',0,2),
(1,'B',7,3,90,'RTE',0,3),
(1,'B',6,3,97,'Garda',0,1),
(1,'B',6,3,97,'Garda',0,2),
(1,'B',6,3,97,'Garda',0,3),
(4,'W',1,1,10,'Women',6,1),
(4,'W',1,1,10,'Women',6,2),
(4,'W',1,1,10,'Women',6,3),
(2,'A',1,1,1,'1',6,1),
(2,'A',1,1,1,'1',6,2),
(2,'A',1,1,1,'1',6,3),
(2,'A',2,2,91,'ESB',5,1),
(2,'A',2,2,91,'ESB',5,2),
(2,'A',2,2,91,'ESB',5,3),
(2,'A',3,3,3,'3',4,1),
(2,'A',3,3,3,'3',4,2),
(2,'A',3,3,3,'3',4,3),
(2,'C',4,1,4,'4',6,1),
(2,'C',4,1,4,'4',6,2),
(2,'C',4,1,4,'4',6,3),
(2,'W',5,1,10,'Women',6,1),
(2,'W',5,1,10,'Women',6,2),
(2,'W',5,1,10,'Women',6,3),
(3,'A',1,1,90,'RTE',6,1),
(3,'A',1,1,90,'RTE',6,2),
(3,'A',1,1,90,'RTE',6,3),
(3,'A',2,2,91,'ESB',5,1),
(3,'A',2,2,91,'ESB',5,2),
(3,'A',2,2,91,'ESB',5,3),
(3,'A',3,3,97,'Garda',4,1),
(3,'A',3,3,97,'Garda',4,2),
(3,'A',3,3,97,'Garda',4,3),
(3,'B',4,1,3,'3',6,1),
(3,'B',4,1,3,'3',6,2),
(3,'B',4,1,3,'3',6,3);

-- this really is the p2p table with type=league_to_event
-- wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
CREATE TABLE p2p (
id int(11) auto_increment primary key,
league int(11) NOT NULL,
event int(11) NOT NULL,
type varchar(20) NOT NUll
);
-- 1 is the team league (no trinity)
-- 2 is the individual league
INSERT INTO p2p
(league,event,type)
VALUES
(1,1,"league_to_event"),
(1,2,"league_to_event"),
(1,3,"league_to_event"),
(2,1,"league_to_event"),
(2,2,"league_to_event"),
(2,3,"league_to_event"),
(2,4,"league_to_event");

-- show the 5 race types with track and summary
CREATE TABLE wp_bhaa_race_detail (
id int(11) auto_increment primary key,
event int(11) NOT NULL,
eventname varchar(10) NOT NULL,
race int(11) NOT NULL,
type varchar(1) NOT NULL,
distance double
);

INSERT INTO wp_bhaa_race_detail
(event,eventname,race,type,distance)
VALUES
(1,"DCC",4,"W",2),
(1,"DCC",1,"M",4),
(2,"RTE",2,"C",5),
(3,"KCLUB",3,"C",10)
(4,"TRINITY",5,"TRACK",1)
(4,"TRINITY",6,"S",1);-- used for individ league scoring

CREATE TABLE wp_bhaa_leaguesummary (
league int(10) NOT NULL,
leaguetype enum('I','T') NOT NULL,
leagueparticipant int(10) NOT NULL,
leaguestandard int(10) NOT NULL,
leaguedivision varchar(5) NOT NULL,
leagueposition int(10) NOT NULL,
leaguescorecount int(10) NOT NULL,
leaguepoints double NOT NULL,
leaguesummary varchar(500)
);

-- SQL Queries
select * from wp_bhaa_teamresult where race=1;

-- order the best scroing teams for a specific race
select race,teamname,position,MAX(leaguepoints),class from wp_bhaa_teamresult
where race=1
group by race,team
order by class,position

-- order the best scroing teams for a specific race
select race,teamname,team,position,MAX(leaguepoints),class from wp_bhaa_teamresult
group by race,team
order by race,class,position

-- get the league totals
select teamname,team,ROUND(COUNT(race)/3) as ran,SUM(leaguepoints)/3 as total
from wp_bhaa_teamresult
where leaguepoints!=0
group by team
order by total desc

-- add the summary of race results
select teamname,team,ROUND(COUNT(race)/3) as ran,SUM(leaguepoints)/3 as total,
(select GROUP_CONCAT( cast( concat('[r=',race,':p=',leaguepoints,']') AS char ) SEPARATOR ',') ) AS summary
from wp_bhaa_teamresult
where leaguepoints!=0
group by team
order by total desc

SELECT team, teamname, TotalPts
FROM
(
SELECT team, teamname, sum(LeaguePts)as TotalPts
FROM
(
SELECT race, team, teamname, max(leaguepoints) as LeaguePts
FROM wp_bhaa_teamresult
GROUP BY race, team, teamname
) pts
GROUP BY team, teamname
ORDER BY TotalPts DESC
);

select l.ID as lid,l.post_title,
e.ID as eid,e.post_title as etitle,eme.event_start_date as edate,
r.ID as rid,r.post_title as rtitle,r_type.meta_value as rtype,
IFNULL(rr.leaguepoints,0) as points
from wp_posts l
join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
join wp_posts e on (e.id=l2e.p2p_to)
join wp_em_events eme on (eme.post_id=e.id)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
join wp_posts r on (r.id=e2r.p2p_to)
join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
left join wp_bhaa_raceresult rr on (r.id=rr.race and rr.runner=7713)
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','W','M') order by eme.event_start_date ASC

select GROUP_CONCAT(CAST(concat('[r=',rr.race,':p=',IFNULL(rr.leaguepoints,0),']') AS CHAR) ORDER BY eme.event_start_date SEPARATOR ',')
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=6762)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
) order by eme.event_start_date ASC
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
2016.renewals.sql

select MONTHNAME(DATE(dor.meta_value)),YEAR(DATE(dor.meta_value)),count(m_status.umeta_id),count(i_status.umeta_id) from wp_users
left join wp_usermeta m_status on (m_status.user_id=wp_users.id and m_status.meta_key='bhaa_runner_status' and m_status.meta_value='M')
left join wp_usermeta i_status on (i_status.user_id=wp_users.id and i_status.meta_key='bhaa_runner_status' and i_status.meta_value='I')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
where DATE(dor.meta_value)>=DATE("2013-01-01")
group by YEAR(DATE(dor.meta_value)), MONTHNAME(DATE(dor.meta_value))
order by YEAR(DATE(dor.meta_value)) DESC, MONTH(DATE(dor.meta_value));

select MONTHNAME(DATE(dor.meta_value)),YEAR(DATE(dor.meta_value)),count(m_status.umeta_id) from wp_users
join wp_usermeta m_status on (m_status.user_id=wp_users.id and m_status.meta_key='bhaa_runner_status')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
where m_status.meta_value='M'
AND DATE(dor.meta_value)>=DATE("2014-01-01")
group by MONTHNAME(DATE(dor.meta_value)), YEAR(DATE(dor.meta_value))
order by YEAR(DATE(dor.meta_value)) DESC, MONTH(DATE(dor.meta_value));

select wp_users.id, status.meta_value, MONTHNAME(DATE(dor.meta_value)),YEAR(DATE(dor.meta_value)) from wp_users
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
where DATE(dor.meta_value)>=DATE("2014-01-01")
order by YEAR(DATE(dor.meta_value)) DESC, MONTH(DATE(dor.meta_value));
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
age categories

-- pull from bhaa to wp
select * from bhaaie_members.agecategory;

DROP TABLE IF EXISTS wp_bhaa_agecategory;
CREATE TABLE IF NOT EXISTS wp_bhaa_agecategory (
category varchar(4) DEFAULT NULL,
gender enum('M','W') DEFAULT 'M',
min int(11) NOT NULL,
max int(11) NOT NULL,
PRIMARY KEY (category)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

select * from wp_bhaa_agecategory;

insert into wp_bhaa_agecategory select category,gender,min,max from bhaaie_members.agecategory;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
bhaawp

select * from company where id=330;

select count(id),min(id),max(id) from wp_posts where post_type="company"
select count(id),min(id),max(id) from wp_posts where post_type="post"
select count(id),min(id),max(id) from wp_posts where post_type="page"
select count(id),min(id),max(id) from wp_posts where post_type="house"
select count(id),min(id),max(id) from wp_posts where post_type="event"
select count(id),min(id),max(id) from wp_posts where post_type="race"

select * from company where id=574
select * from company where id=97

select runner.id,runner.company,runner.companyname,team.id,team.name,team.type
from runner
join teammember on teammember.runner=runner.id
join team on team.id=teammember.team
where runner.status!="D" and runner.company!=0 order by runner.company

DELETE FROM wp_p2p WHERE p2p_type='house_to_runner';
DELETE FROM wp_p2p WHERE p2p_type='sectorteam_to_runner';
DELETE FROM wp_p2p WHERE p2p_type='company_to_runner';

select * from wp_users where id=1597;

select * from wp_p2pmeta
delete from wp_p2pmeta

select * from wp_posts where post_type="page";

select * from team;

select * from team where type="S" order by id asc;
select team.id,team.name,sector.name from team
join sector on sector.id=team.parent
where type="S" order by id asc;

select * from team where type="C" order by id asc;

select count(id),min(id),max(id) from team where type="C" order by id asc;
select count(id),min(id),max(id) from team where type="S" order by id asc;

select * from company
left join team on team.id=company.id
where team.type="S" order by company.id;

select id from team where type="S";

select * from teammember where runner=1506
delete from teammember where runner=1506 and team=84

select runner.id as runner,runner.company,runner.companyname,team.id as team,team.name as teamname,team.type
from runner
join teammember on teammember.runner=runner.id
join team on team.id=teammember.team
where runner.status!="D" and runner.company!=0 order by runner.id limit 50

desc wp_bhaa_raceresult
desc raceresult
select * from wp_bhaa_raceresult
delete from wp_bhaa_raceresult

insert into wp_bhaa_raceresult(id,race,runner,racetime,position,racenumber,standard,company)
select 0,race,runner,racetime,position,racenumber,standard,company
from raceresult

-- team result
desc wp_bhaa_teamresult
desc teamraceresult
insert into wp_bhaa_teamresult(id,team,league,race,standardtotal,positiontotal,class,leaguepoints,status)
select id,team,league,race,standardtotal,positiontotal,class,leaguepoints,status
from teamraceresult

-- race result query
SELECT wp_bhaa_raceresult.*,wp_users.display_name,wp_posts.id,wp_posts.post_title
FROM wp_bhaa_raceresult
left join wp_users on wp_users.id=wp_bhaa_raceresult.runner
left join wp_posts on wp_posts.post_type='house' and wp_bhaa_raceresult.company=wp_posts.id
where race=2 order by position

-- runner result query
SELECT wp_bhaa_raceresult.* FROM
wp_bhaa_raceresult
join wp_users on wp_users.id=wp_bhaa_raceresult.runner
where runner=7713 order by race desc

left join wp_usermeta as cid on cid.user_id=wp_users.id and cid.meta_key="bhaa_runner_company"
left join wp_usermeta as cname on cname.user_id=wp_users.id and cname.meta_key="bhaa_runner_companyname"
-- insert users
insert into wp_users (ID,user_login,user_pass,display_name)
select id,(concat(firstname,'.',surname)),id,(concat(firstname,'.',surname)) from runner
where runner.status="D"

delete from wp_users where ID>10000

-- map the wp race to the bhaa race
select id,post_name,wp_postmeta.meta_value from wp_posts
join wp_postmeta on (wp_postmeta.post_id=wp_posts.id and wp_postmeta.meta_key='bhaa_race_id')
where wp_posts.post_type='race';

create table race_mapping
(
wp_race_id int,
bhaa_race_id int
);
select * from race_mapping where bhaa_race_id=8;

insert into race_mapping (wp_race_id,bhaa_race_id)
select id,wp_postmeta.meta_value
from wp_posts
join wp_postmeta on (wp_postmeta.post_id=wp_posts.id and wp_postmeta.meta_key='bhaa_race_id')
where wp_posts.post_type='race';
select * from race_mapping;

update wp_bhaa_raceresult
join race_mapping on race_mapping.bhaa_race_id=wp_bhaa_raceresult.race
set race = race_mapping.wp_race_id;

SELECT wp_bhaa_raceresult.*,race.id,wp_p2p.p2p_id FROM wp_bhaa_raceresult
join wp_posts as race on race.post_type='race' and race.id=wp_bhaa_raceresult.race
left join wp_p2p on (wp_p2p.p2p_from=race.id and wp_p2p.p2p_type='event_to_race')
where runner=7713 order by wp_bhaa_raceresult.race desc
left join wp_posts as event on (event.post_type='event' and event.id=wp_p2p.p2p_to)

-- update the race company details
update wp_bhaa_raceresult wp
join bhaaie_members.raceresult rr where rr.runner=wp.runner and rr.race=wp.race
set company=rr.company;

--sdcc2009 1523
update wp_bhaa_raceresult wp
join bhaaie_members.raceresult rr on (rr.runner=wp.runner and rr.race=.race)
join wp_bhaa_import import on (import.old=rr.race and import.type='race')
set company=rr.company
where wp.race=1523

select wp.*,rr.company from wp_bhaa_raceresult wp
join bhaaie_members.raceresult rr on (rr.runner=wp.runner and rr.race=
(select old from wp_bhaa_import where type='race' and new=wp.race))
where wp.race=1523

update wp_bhaa_raceresult wp
join bhaaie_members.raceresult rr on (rr.runner=wp.runner and rr.race=
(select old from wp_bhaa_import where type='race' and new=wp.race))
set company=rr.company

update wp_bhaa_raceresult wp
join bhaaie_members.raceresult rr on (rr.runner=wp.runner and rr.race=wp.race)
set wp.company=rr.company
where tt.race=201219;

SELECT id,name,tag,date,YEAR(date) as year,location FROM event order by id; desc

SELECT
race,
runner,
racetime,
position,
racenumber,
category,
raceresult.standard,
paceKM,
class
FROM raceresult
JOIN runner on runner.id=raceresult.runner
where raceresult.race>=0 and runner.status="M" and class="RAN" order by raceresult.race

select * from wp_bhaa_import where type='race'
select * from wp_bhaa_import where tag='dublinhalf2012'
select * from wp_bhaa_import where tag='ilp2011'

-- for the event and race id mapping between wp and members
desc wp_postmeta
select * from wp_postmeta
select distinct(meta_key) from wp_postmeta

select post_id,meta_value from wp_postmeta where meta_key='bhaa_race_id'
select post_id,meta_value from wp_postmeta where meta_key='bhaa_event_tag'

select post_id,meta_value,(select id from event where event.tag=meta_value)
from wp_postmeta where meta_key='bhaa_event_tag'

SELECT wp_bhaa_raceresult.* FROM wp_bhaa_raceresult where runner=7713 order by race desc

SELECT wp_bhaa_raceresult.* FROM wp_bhaa_raceresult
where runner=7713 order by race desc

select p2p_from from wp_p2p where p2p_to=207164 and wp_p2p.p2p_type="event_to_race"

SELECT wp_p2p.p2p_from as event,wp_bhaa_raceresult.* FROM wp_bhaa_raceresult
join wp_p2p on (wp_p2p.p2p_to=wp_bhaa_raceresult.race and wp_p2p.p2p_type="event_to_race")
where runner=7713 order by race desc

select * from wp_bhaa_teamresult
select * from wp_bhaa_import

select race,wp_bhaa_import.old,wp_bhaa_import.new
from wp_bhaa_teamresult
join wp_bhaa_import on (wp_bhaa_import.type='race' and wp_bhaa_import.old=wp_bhaa_teamresult.race)

update wp_bhaa_teamresult
join wp_bhaa_import on (wp_bhaa_import.type='race' and wp_bhaa_import.old=wp_bhaa_teamresult.race)
set race=wp_bhaa_import.new

-- event 206862
select p2p_to from wp_p2p where p2p_from=206862

SELECT wp_bhaa_teamresult.*,wp_posts.post_title as teamname
FROM wp_bhaa_teamresult
join wp_posts on wp_posts.post_type="house" and wp_bhaa_teamresult.team=wp_posts.id
where race=(select p2p_to from wp_p2p where p2p_from=206862)
order by class, positiontotal

SELECT wp_bhaa_teamresult.*,wp_posts.post_title as teamname
FROM wp_bhaa_teamresult
join wp_posts on wp_posts.post_type="house" and wp_bhaa_teamresult.team=wp_posts.id
where race=201219 order by class, positiontotal
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
forum

-- main forum id=2
select * from gl_forum_forums

-- general:0,bhaa:4
select * from gl_forum_categories

-- topics
select * from gl_forum_topic

-- parent
select * from gl_forum_topic where pid=0;
-- replies (uid=1 anon, uid>1 real user).
select * from gl_forum_topic where pid!=0;

select distinct(pid),subject from gl_forum_topic

-- mingle tables
select * from wp_forum_forums

select * from wp_forum_posts

-- each parent post is a thread
select * from wp_forum_threads
delete from wp_forum_threads
select * from gl_forum_topic where pid!=0;

-- insert topics
insert into wp_forum_threads
select id,1,views,subject,FROM_UNIXTIME(date),'open',0,-1,1,FROM_UNIXTIME(lastupdated)
from gl_forum_topic where pid=0;
-- insert first message for each topic
insert into wp_forum_posts
select id,comment,id,FROM_UNIXTIME(lastupdated),uid,subject,views
from gl_forum_topic where pid=0;

-- insert the replies
insert into wp_forum_posts
select 0,comment,pid,FROM_UNIXTIME(date),uid,subject,views
from gl_forum_topic where pid!=0;

-- move the replies
select * from wp_forum_posts
delete from wp_forum_posts
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
kclub 2013

select * from wp_bhaa_raceresult where race=2597;
select position, runner from wp_bhaa_raceresult where race=2597;

-- clean up NULL positions
select * from wp_bhaa_raceresult where position IS NULL
delete from wp_bhaa_raceresult where position IS NULL

update wp_bhaa_raceresult set runner=5253 where position=8 and race=2597;
-- 21 position?

SELECT wp_bhaa_raceresult.position,racenumber,wp_bhaa_raceresult.runner,wp_bhaa_raceresult.racetime,
lastname.meta_value as lastname,
firstname.meta_value as firstname,
CASE WHEN gender.meta_value='W' THEN 'F' ELSE 'M' END as gender,
dateofbirth.meta_value as dateofbirth,
standard,
'age' as age,
house.id as company,
CASE WHEN house.post_title IS NULL THEN companyname.post_title ELSE house.post_title END as companyname,
CASE WHEN sector.id IS NOT NULL THEN sector.id ELSE house.id END as teamid,
CASE WHEN sector.post_title IS NOT NULL THEN sector.post_title ELSE house.post_title END as teamname
from wp_bhaa_raceresult
JOIN wp_p2p e2r ON (wp_bhaa_raceresult.race=e2r.p2p_to AND e2r.p2p_type="event_to_race")
JOIN wp_users on (wp_users.id=wp_bhaa_raceresult.runner)
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_posts house on (house.id=r2c.p2p_from and house.post_type='house')
left join wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = 'sectorteam_to_runner')
left join wp_posts sector on (sector.id=r2s.p2p_from and house.post_type='house')
left join wp_usermeta firstname ON (firstname.user_id=wp_users.id AND firstname.meta_key = 'first_name')
left join wp_usermeta lastname ON (lastname.user_id=wp_users.id AND lastname.meta_key = 'last_name')
left join wp_usermeta gender ON (gender.user_id=wp_users.id AND gender.meta_key = 'bhaa_runner_gender')
left join wp_usermeta dateofbirth ON (dateofbirth.user_id=wp_users.id AND dateofbirth.meta_key = 'bhaa_runner_dateofbirth')
left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
left join wp_posts companyname on (companyname.id=company.meta_value and companyname.post_type='house')
where wp_bhaa_raceresult.class="RAN"
AND wp_bhaa_raceresult.race=2597 order by wp_bhaa_raceresult.position

update wp_bhaa_raceresult set standardscoringset=NULL,posinsss=NULL,leaguepoints=NULL where race=2597;
select * from wp_bhaa_raceresult where race=2597
order by standardscoringset desc,position asc;

call updateRaceScoringSets(2597);
call updateRaceLeaguePoints(2597);
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
optimize

OPTIMIZE TABLE importusers;
OPTIMIZE TABLE teamresult;
OPTIMIZE TABLE wp__bhaa_agecategory;
OPTIMIZE TABLE wp_allowphp_functions;
OPTIMIZE TABLE wp_bhaa_agecategory;
OPTIMIZE TABLE wp_bhaa_division;
OPTIMIZE TABLE wp_bhaa_import;
OPTIMIZE TABLE wp_bhaa_leaguerunnerdata;
OPTIMIZE TABLE wp_bhaa_leaguesummary;
OPTIMIZE TABLE wp_bhaa_race_detail;
OPTIMIZE TABLE wp_bhaa_raceresult;
OPTIMIZE TABLE wp_bhaa_standard;
OPTIMIZE TABLE wp_bhaa_teamresult;
OPTIMIZE TABLE wp_bhaa_teamsummary;
OPTIMIZE TABLE wp_cntctfrm_field;
OPTIMIZE TABLE wp_commentmeta;
OPTIMIZE TABLE wp_comments;
OPTIMIZE TABLE wp_em_bookings;
OPTIMIZE TABLE wp_em_bookings_relationships;
OPTIMIZE TABLE wp_em_coupons;
OPTIMIZE TABLE wp_em_email_queue;
OPTIMIZE TABLE wp_em_events;
OPTIMIZE TABLE wp_em_locations;
OPTIMIZE TABLE wp_em_meta;
OPTIMIZE TABLE wp_em_tickets;
OPTIMIZE TABLE wp_em_tickets_bookings;
OPTIMIZE TABLE wp_em_transactions;
OPTIMIZE TABLE wp_flickr_cache;
OPTIMIZE TABLE wp_layerslider;
OPTIMIZE TABLE wp_links;
OPTIMIZE TABLE wp_ngg_album;
OPTIMIZE TABLE wp_ngg_gallery;
OPTIMIZE TABLE wp_ngg_pictures;
OPTIMIZE TABLE wp_options;
OPTIMIZE TABLE wp_p2p;
OPTIMIZE TABLE wp_p2pmeta;
OPTIMIZE TABLE wp_postmeta;
OPTIMIZE TABLE wp_posts;
OPTIMIZE TABLE wp_revslider_static_slides;
OPTIMIZE TABLE wp_term_relationships;
OPTIMIZE TABLE wp_term_taxonomy;
OPTIMIZE TABLE wp_terms;
OPTIMIZE TABLE wp_usermeta;
OPTIMIZE TABLE wp_users;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
racemaster

select TRIM(wp_users.id) as id,
TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
TRIM(first_name.meta_value) as firstname,
TRIM(last_name.meta_value) as lastname,
wp_users.user_email as email,
status.meta_value as status,
gender.meta_value as gender,
company.meta_value as company,
TRIM(house.post_title) as companyname,
standard.meta_value as standard,
dob.meta_value as dob
from wp_users
join wp_bhaa_raceresult ON (wp_users.id=wp_bhaa_raceresult.runner)
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key="bhaa_runner_company")
left join wp_posts house on (house.id=company.meta_value and house.post_type="house")
left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
where wp_bhaa_raceresult.race=5202 order by lastname,firstname

-- -- esb 5294, rte 5227, kclub 5202
select wp_bhaa_raceresult.position,wp_bhaa_raceresult.racenumber,wp_bhaa_raceresult.racetime,wp_bhaa_raceresult.runner
FROM wp_bhaa_raceresult
where wp_bhaa_raceresult.race=5294 order by position
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
stored proc's

-- bhaa stored proces

-- http://www.coderrants.com/wordpress-and-stored-procedures/
-- http://wordpress.org/support/topic/how-to-call-stored-procedure-from-plugin

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$

-- only functions return values
DROP FUNCTION IF EXISTS getUsername$$
CREATE FUNCTION getUsername(_runner INT) RETURNS int(11)
BEGIN
DECLARE _result int;
SET _result = (SELECT user_nicename FROM wp_users WHERE id = _runner);
RETURN _result;
END $$

-- getRaceDistanceKm
DROP FUNCTION IF EXISTS getRaceDistanceKm$$
CREATE FUNCTION getRaceDistanceKm(_race INT) RETURNS double
BEGIN
DECLARE _unit VARCHAR(5);
DECLARE _distance DOUBLE;
SET _unit = (select meta_value from wp_postmeta where post_id=_race and meta_key='bhaa_race_unit');
SET _distance = (select meta_value from wp_postmeta where post_id=_race and meta_key='bhaa_race_distance');
SET _distance = IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN _distance;
END $$

-- getStandard
DROP FUNCTION IF EXISTS getStandard$$
CREATE FUNCTION getStandard(_raceTime TIME, _distanceKm DOUBLE) RETURNS int(11)
BEGIN
DECLARE _standard INT DEFAULT 1;
SET _standard = (
SELECT S.Standard
FROM
(
SELECT Standard, SEC_TO_TIME((((wp_bhaa_standard.slopefactor)*(_distanceKm-1)) + wp_bhaa_standard.oneKmTimeInSecs) * _distanceKm) as Expected
FROM wp_bhaa_standard
WHERE Standard <> 1
UNION ALL SELECT 1 AS Standard , SEC_TO_TIME(1) AS Expected
) S
WHERE S.Expected <= _raceTime
ORDER BY S.Standard DESC LIMIT 1
);
RETURN COALESCE(_standard, 30);
END $$

-- getAgeCategory
DROP FUNCTION IF EXISTS getAgeCategory$$
CREATE FUNCTION getAgeCategory(_birthDate DATE, _currentDate DATE, _gender ENUM('M','W')) RETURNS varchar(6) CHARSET utf8
BEGIN
DECLARE _age INT(11);
SET _age = (YEAR(_currentDate)-YEAR(_birthDate)) - (RIGHT(_currentDate,5)<RIGHT(_birthDate,5));
RETURN (SELECT category FROM wp_bhaa_agecategory WHERE (_age between min and max) and gender=_gender);
END$$

-- updatePositions by time
DROP PROCEDURE IF EXISTS updateRace$$
CREATE PROCEDURE updateRace(_race INT(11))
BEGIN
CALL updatePositions(_race);
CALL updatePositionInAgeCategory(_race);
CALL updatePositionInStandard(_race);
CALL updateRaceScoringSets(_race);
CALL updateRaceLeaguePoints(_race);
END$$

-- updatePositions by time
DROP PROCEDURE IF EXISTS updatePositions$$
CREATE PROCEDURE updatePositions(_race INT(11))
BEGIN

create temporary table if not exists tmp_raceresult(
	race int,
    runner int,
    position int
) ENGINE=MyISAM;

insert into tmp_raceresult
	select race, runner, @row:=@row+1
    from wp_bhaa_raceresult, (SELECT @row:=0) r
    where race=_race AND class='RAN' order by racetime;

alter table tmp_raceresult add index (race,runner);

update wp_bhaa_raceresult, tmp_raceresult
	set wp_bhaa_raceresult.position=tmp_raceresult.position
	where wp_bhaa_raceresult.runner=tmp_raceresult.runner
	and wp_bhaa_raceresult.race=tmp_raceresult.race;

drop table tmp_raceresult;

END$$

-- updatePositionInStandard
DROP PROCEDURE IF EXISTS updatePositionInStandard$$
CREATE PROCEDURE updatePositionInStandard(_raceId INT(11))
BEGIN

DECLARE _nextstandard INT(11);
DECLARE no_more_rows BOOLEAN;
DECLARE loop_cntr INT DEFAULT 0;
DECLARE num_rows INT DEFAULT 0;
DECLARE _standardCursor CURSOR FOR select standard from wp_bhaa_standard;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

OPEN _standardCursor;
SELECT FOUND_ROWS() into num_rows;

the_loop: LOOP

FETCH _standardCursor INTO _nextstandard;

IF no_more_rows THEN
    CLOSE _standardCursor;
    LEAVE the_loop;
END IF;

CREATE TEMPORARY TABLE tmpStandardRaceResult(actualposition INT PRIMARY KEY AUTO_INCREMENT, runner INT);
INSERT INTO tmpStandardRaceResult(runner)
SELECT runner
FROM wp_bhaa_raceresult
WHERE race = _raceId AND standard = _nextstandard and class='RAN';

UPDATE wp_bhaa_raceresult, tmpStandardRaceResult
SET wp_bhaa_raceresult.posinstd = tmpStandardRaceResult.actualposition
WHERE wp_bhaa_raceresult.runner = tmpStandardRaceResult.runner AND wp_bhaa_raceresult.race = _raceId;

DELETE FROM tmpStandardRaceResult;

SET loop_cntr = loop_cntr + 1;

DROP TEMPORARY TABLE tmpStandardRaceResult;

END LOOP the_loop;
END$$

-- updatePositionInAgeCategory
DROP PROCEDURE IF EXISTS updatePositionInAgeCategory$$
CREATE PROCEDURE updatePositionInAgeCategory(_raceId INT(11),_gender ENUM('M','W'))
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

-- updatePostRaceStandard
DROP PROCEDURE IF EXISTS updatePostRaceStandard$$
CREATE PROCEDURE updatePostRaceStandard(_raceId INT)
BEGIN
UPDATE wp_bhaa_raceresult rr_outer,
(
SELECT rr.race,rr.runner,rr.racetime,NULLIF(rr.standard,0) as standard,rr.actualstandard
FROM wp_bhaa_raceresult rr
WHERE rr.race = _raceId AND rr.class='RAN'
) t
SET rr_outer.poststandard =
CASE
WHEN t.standard IS NULL
THEN t.actualstandard
WHEN t.standard < t.actualstandard
THEN t.standard + 1
WHEN t.standard > t.actualstandard
THEN t.standard - 1
WHEN t.standard = t.actualstandard
THEN t.standard
END
WHERE rr_outer.race = t.race AND rr_outer.runner=t.runner;
-- update 'bhaa_runner_standard' meta field
--UPDATE wp_bhaa_raceresult, wp_usermeta
--SET wp_usermeta.meta_value = wp_bhaa_raceresult.poststandard
--WHERE wp_bhaa_raceresult.runner = wp_usermeta.user_id
--AND wp_usermeta.meta_key='bhaa_runner_standard'
--AND wp_bhaa_raceresult.race = _raceId
--AND COALESCE(wp_usermeta.meta_value,0) <> wp_bhaa_raceresult.poststandard;
END$$

-- updateRaceScoringSets
DROP PROCEDURE IF EXISTS updateRaceScoringSets$$
CREATE PROCEDURE updateRaceScoringSets(_race INT)
BEGIN
DECLARE _raceType ENUM('m','w','c');
DECLARE _scoringthreshold int;
DECLARE _currentstandard int;
DECLARE _runningtotal int;
DECLARE _runningtotalM int;
DECLARE _runningtotalW int;
DECLARE _scoringset int;
DECLARE _scoringsetM int;
DECLARE _scoringsetW int;

-- TODO look this up from the league
SET _scoringthreshold = 4;
SET _currentstandard  = 30;
SET _runningtotal     = 0;
SET _runningtotalM    = 0;
SET _runningtotalW    = 0;
SET _scoringset       = 1;
SET _scoringsetM      = 1;
SET _scoringsetW      = 1;

UPDATE wp_bhaa_raceresult
SET    standardscoringset = NULL
WHERE  race = _race;

CREATE TEMPORARY TABLE IF NOT EXISTS scoringstandardsets(
    standard int,
    gender ENUM('M','W') NULL,
    standardcount int NULL,
    scoringset int NULL);

SET _raceType         = (SELECT meta_value
                         FROM   wp_postmeta
                         WHERE  post_id = _race AND meta_key = 'bhaa_race_type');

/* Process Gender Race. In this case Gender is relevant as all runners
   are grouped together based on their standard and gender. */
IF (_raceType = 'C')
THEN
  INSERT INTO scoringstandardsets(standard, standardcount, scoringset, gender)
    SELECT standard, 0, 0, 'W' FROM wp_bhaa_standard
    UNION
    SELECT standard, 0, 0, 'M' FROM wp_bhaa_standard;

  UPDATE scoringstandardsets ss,
         (SELECT   r.standard, gender.meta_value AS gender, count(r.standard) AS standardcount
          FROM       wp_bhaa_raceresult r
          JOIN wp_usermeta gender ON (gender.user_id = r.runner AND gender.meta_key = 'bhaa_runner_gender')
          WHERE    r.race = _race AND COALESCE(r.standard, 0) > 0
          GROUP BY r.standard, gender.meta_value) x
  SET    ss.standardcount = x.standardcount
  WHERE  ss.standard = x.standard AND ss.gender = x.gender;

  WHILE (_currentstandard > 0)
  DO
    SET _runningtotalM      = (SELECT sum(standardcount)
                               FROM   scoringstandardsets
                               WHERE  standard >= _currentstandard AND scoringset = 0 AND gender = 'M');

    SET _runningtotalW      = (SELECT sum(standardcount)
                               FROM   scoringstandardsets
                               WHERE  standard >= _currentstandard AND scoringset = 0 AND gender = 'W');

    IF (_runningtotalM >= _scoringthreshold)
    THEN
      UPDATE scoringstandardsets
      SET    scoringset = _scoringsetM
      WHERE  standard >= _currentstandard AND scoringset = 0 AND gender = 'M';

      SET _scoringsetM   = _scoringsetM + 1;
      SET _runningtotalM = 0;
    END IF;

    IF (_runningtotalW >= _scoringthreshold)
    THEN
      UPDATE scoringstandardsets
      SET    scoringset = _scoringsetW
      WHERE  standard >= _currentstandard AND scoringset = 0 AND gender = 'W';

      SET _scoringsetW   = _scoringsetW + 1;
      SET _runningtotalW = 0;
    END IF;

    SET _currentstandard    = _currentstandard - 1;
  END WHILE;

  UPDATE scoringstandardsets
  SET    scoringset = _scoringsetW
  WHERE  scoringset = 0 AND gender = 'W';

  UPDATE scoringstandardsets
  SET    scoringset = _scoringsetM
  WHERE  scoringset = 0 AND gender = 'M';

  UPDATE wp_bhaa_raceresult
  JOIN scoringstandardsets ON scoringstandardsets.standard=wp_bhaa_raceresult.standard
  JOIN wp_usermeta gender ON (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key = 'bhaa_runner_gender')
  SET wp_bhaa_raceresult.standardscoringset = scoringstandardsets.scoringset
  WHERE gender.meta_value = scoringstandardsets.gender AND wp_bhaa_raceresult.race = _race;

ELSE
  /* Process Gender Race. In this case Gender is irrelevant as all runners
     are grouped together based on their standards only. */
  INSERT INTO scoringstandardsets(standard, standardcount, scoringset)
    SELECT   standard, 0, 0
    FROM     wp_bhaa_standard
    ORDER BY standard DESC;

  /* Count the total runners in each standard and update the temporary table
     1. Ignore Gender 2. Ignore null and Standard 0
  */
  UPDATE scoringstandardsets ss,
         (SELECT   r.standard, count(r.standard) AS standardcount
          FROM     wp_bhaa_raceresult r
          WHERE    r.race = _race AND COALESCE(r.standard, 0) > 0
          GROUP BY r.standard) x
  SET    ss.standardcount = x.standardcount
  WHERE  ss.standard = x.standard;

  WHILE (_currentstandard > 0)
  DO
    SET _runningtotal      = (SELECT sum(standardcount)
                              FROM   scoringstandardsets
                              WHERE  standard >= _currentstandard AND scoringstandardsets.scoringset = 0);

    IF (_runningtotal >= _scoringthreshold)
    THEN
      UPDATE scoringstandardsets
      SET    scoringset = _scoringset
      WHERE  standard >= _currentStandard AND scoringset = 0;


      SET _scoringset   = _scoringset + 1;
      SET _runningtotal = 0;
    END IF;

    SET _currentstandard   = _currentstandard - 1;
  END WHILE;

  /* Left overs get added to last scoring set */
  UPDATE scoringstandardsets
  SET    scoringset = _scoringset
  WHERE  scoringset = 0;

  -- SELECT * FROM scoringstandardsets;

  UPDATE wp_bhaa_raceresult, scoringstandardsets
  SET    wp_bhaa_raceresult.standardscoringset = scoringstandardsets.scoringset
  WHERE  scoringstandardsets.standard = wp_bhaa_raceresult.standard and wp_bhaa_raceresult.race = _race;
END IF;

DROP TABLE scoringstandardsets;

END$$

-- updateRaceLeaguePoints
DROP PROCEDURE IF EXISTS updateRaceLeaguePoints$$
CREATE PROCEDURE updateRaceLeaguePoints(_race INT )
BEGIN
create temporary table if not exists tmpPosInSet (
id int auto_increment,
scoringset int,
runner int,
primary key(scoringset,id)
)ENGINE=MyISAM;

insert into tmpPosInSet(runner,scoringset)
    select runner,standardscoringset
    from wp_bhaa_raceresult
    where race = _race and wp_bhaa_raceresult.standardscoringset IS NOT NULL
    order by position asc;

update wp_bhaa_raceresult, tmpPosInSet
set
wp_bhaa_raceresult.leaguepoints = (10.1 - (tmpPosInSet.id * 0.1)),
wp_bhaa_raceresult.posinsss = tmpPosInSet.id
where wp_bhaa_raceresult.runner = tmpPosInSet.runner and wp_bhaa_raceresult.race = _race;

drop table tmpPosInSet;

END$$

-- updateLeagueData
DROP PROCEDURE IF EXISTS updateLeagueData$$
CREATE PROCEDURE updateLeagueData(_leagueId INT(11))
BEGIN

DELETE FROM wp_bhaa_leaguesummary WHERE league=_leagueId;

INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,
leaguedivision,leagueposition,leaguesummary)
SELECT
le.id,
'I',
rr.runner,
ROUND(AVG(rr.standard),0),
COUNT(rr.race),
ROUND(getLeaguePointsTotal(le.id,rr.runner),1) as leaguepoints,
'A',
1,
GROUP_CONCAT( cast( concat_ws(':',e.ID,rr.leaguepoints,IF(class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary
FROM wp_bhaa_raceresult rr
inner join wp_posts r ON rr.race = r.id
inner join wp_postmeta rt on (rt.post_id=r.id and rt.meta_key = 'bhaa_race_type')
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.ID)
inner join wp_posts e ON e2r.p2p_from = e.id
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_to=e.ID)
inner JOIN wp_posts le ON l2e.p2p_from = le.id
inner JOIN wp_users ru ON rr.runner = ru.id
JOIN wp_usermeta status ON (status.user_id=rr.runner AND status.meta_key = 'bhaa_runner_status')
JOIN wp_usermeta standard ON (standard.user_id=rr.runner AND standard.meta_key = 'bhaa_runner_standard')
WHERE le.id=3709 AND class in ('RAN','RACE_ORG')
AND standard.meta_value IS NOT NULL AND status.meta_value='M'
AND rt.meta_value!='TRACK' -- exclude TRACK events
GROUP BY le.id,rr.runner
HAVING COALESCE(leaguepoints, 0) > 0;

update wp_bhaa_leaguesummary
JOIN wp_usermeta gender ON (gender.user_id=wp_bhaa_leaguesummary.leagueparticipant AND gender.meta_key = 'bhaa_runner_gender')
JOIN wp_bhaa_division d ON ((wp_bhaa_leaguesummary.leaguestandard BETWEEN d.min AND d.max) AND d.type='I' and d.gender=gender.meta_value)
set wp_bhaa_leaguesummary.leaguedivision=d.code
where league=_leagueId;

SET @A=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@A:= (@A+1)) where leaguedivision="A" and league=_leagueId ORDER BY leaguepoints DESC;
SET @b=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@b:= (@b+1)) where leaguedivision="B" and league=_leagueId ORDER BY leaguepoints DESC;
SET @c=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@c:= (@c+1)) where leaguedivision="C" and league=_leagueId ORDER BY leaguepoints DESC;
SET @d=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@d:= (@d+1)) where leaguedivision="D" and league=_leagueId ORDER BY leaguepoints DESC;
SET @e=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@e:= (@e+1)) where leaguedivision="E" and league=_leagueId ORDER BY leaguepoints DESC;
SET @f=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@f:= (@f+1)) where leaguedivision="F" and league=_leagueId ORDER BY leaguepoints DESC;
SET @g=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@g:= (@g+1)) where leaguedivision="L1" and league=_leagueId ORDER BY leaguepoints DESC;
SET @h=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@h:= (@h+1)) where leaguedivision="L2" and league=_leagueId ORDER BY leaguepoints DESC;

update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(leagueparticipant,_leagueId,'M') where
league=_leagueId and leaguedivision in ('A','B','C','D','E','F');
update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(leagueparticipant,_leagueId,'W') where
league=_leagueId and leaguedivision in ('L1','L2');

END$$

--SET GLOBAL log_bin_trust_function_creators = 1$$
DROP FUNCTION IF EXISTS getLeagueRunnerSummary$$
CREATE FUNCTION getLeagueRunnerSummary(_runner INT,_leagueId INT,_gender varchar(1)) RETURNS varchar(200)
BEGIN
DECLARE _result varchar(200);
SET _result = (
select GROUP_CONCAT(CAST(CONCAT(IFNULL(rr.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')
from wp_bhaa_race_detail rd
left join wp_bhaa_raceresult rr on (rr.race=rd.race and rr.runner=_runner)
where rd.league=_leagueId
and rd.racetype in ('C','S',_gender)
and rd.racetype!='TRACK'
order by rd.eventdate asc
);
RETURN _result;
END $$

--SET GLOBAL log_bin_trust_function_creators = 1$$
DROP FUNCTION IF EXISTS getLeagueMTeamSummary$$
CREATE FUNCTION getLeagueMTeamSummary(_team INT,_leagueId INT) RETURNS varchar(200)
BEGIN
DECLARE _result varchar(200);
SET _result = (
select GROUP_CONCAT(CAST(CONCAT(IFNULL(subselect.leaguepoints,0)) AS CHAR) SEPARATOR ',') from (
select ts.leaguepoints as leaguepoints
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=_team AND ts.class!='W')
where rd.league=_leagueId
and rd.racetype in ('C','S','M')
and rd.racetype!='TRACK'
GROUP BY league,event
order by rd.eventdate asc
) as subselect
);
RETURN _result;
END $$

--SET GLOBAL log_bin_trust_function_creators = 1$$
DROP FUNCTION IF EXISTS getLeagueWTeamSummary$$
CREATE FUNCTION getLeagueWTeamSummary(_team INT,_leagueId INT) RETURNS varchar(200)
BEGIN
DECLARE _result varchar(200);
SET _result = (
select GROUP_CONCAT(CAST(CONCAT(IFNULL(subselect.leaguepoints,0)) AS CHAR) SEPARATOR ',') from (
select ts.leaguepoints as leaguepoints
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=_team AND ts.class='W')
where rd.league=_leagueId
and rd.racetype in ('C','S','W')
and rd.racetype!='TRACK'
GROUP BY league,event
order by rd.eventdate asc
) as subselect
);
RETURN _result;
END $$

/**

    [r=',p.ID,':p=',IFNULL(rr.leaguepoints,0),']
    */
    DROP FUNCTION IF EXISTS getRunnerLeagueSummary$$
    CREATE FUNCTION getRunnerLeagueSummary(_runner INT,_leagueId INT,_gender varchar(1)) RETURNS varchar(200)
    BEGIN
    DECLARE _result varchar(200);
    SET _result = (
    select GROUP_CONCAT(CAST(CONCAT(IFNULL(rr.leaguepoints,0)) AS CHAR) ORDER BY eme.event_start_date SEPARATOR ',')
    from wp_posts event
    left join wp_bhaa_raceresult rr on (event.id=rr.race and rr.runner=_runner and rr.class!='PRE_REG')
    join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=event.id)
    join wp_em_events eme on (eme.post_id=e2r.p2p_from)
    where event.ID IN (
    select r.ID from wp_posts l
    inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
    inner join wp_posts e on (e.id=l2e.p2p_to)
    inner join wp_em_events eme on (eme.post_id=e.id)
    inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
    inner join wp_posts r on (r.id=e2r.p2p_to)
    inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
    where l.post_type='league'
    AND l.ID=_leagueId
    AND r_type.meta_value in ('C','S',_gender)
    AND r_type.meta_value!='TRACK'
    order by eme.event_start_date ASC)
    order by event.id
    );
    RETURN _result;
    END $$

DROP FUNCTION IF EXISTS getTeamLeagueSummary$$
CREATE FUNCTION getTeamLeagueSummary(_team INT,_leagueId INT,_gender varchar(1)) RETURNS varchar(200)
BEGIN
DECLARE _result varchar(200);
SET _result = (
select GROUP_CONCAT(CAST(CONCAT(IFNULL(ts.leaguepoints,0)) AS CHAR) ORDER BY rd.eventdate SEPARATOR ',')
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race and ts.team=_team)
where rd.league=_leagueId
and rd.racetype in ('C','S',_gender)
and rd.racetype!='TRACK'
order by rd.eventdate asc
);
RETURN _result;
END $$

DROP PROCEDURE IF EXISTS updateLeagueSummary$$
CREATE PROCEDURE updateLeagueSummary(_leagueId INT(11))
BEGIN

update wp_bhaa_leaguesummary set leaguesummary =
(select GROUP_CONCAT( cast( concat('[r=',p.ID,':p=',IFNULL(rr.leaguepoints,0),']') AS char ) SEPARATOR ',') AS summary
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=wp_bhaa_leaguesummary.leagueparticipant)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=_leagueId and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
order by p.id)
where leaguedivision in ('A','B','C','D','E','F') and league=_leagueId;

update wp_bhaa_leaguesummary set leaguesummary =
(select GROUP_CONCAT( cast( concat('[r=',p.ID,':p=',IFNULL(rr.leaguepoints,0),']') AS char ) SEPARATOR ',') AS summary
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=wp_bhaa_leaguesummary.leagueparticipant)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=_leagueId and r_type.meta_value in ('C','S','W') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
order by p.id)
where leaguedivision in ('L1','L2') and league=_leagueId;

END$$

-- getLeaguePointsTotal
DROP FUNCTION IF EXISTS getLeaguePointsTotal$$
CREATE FUNCTION getLeaguePointsTotal(_leagueId INT(11), _runnerId INT(11)) RETURNS double
BEGIN

DECLARE _pointsTotal DOUBLE;
DECLARE _racesToCount INT;

SET _racesToCount = (select meta_value from wp_postmeta where meta_key='races_to_score' and post_id=_leagueId);

SET _pointsTotal =
(
SELECT SUM(points) FROM
(
SELECT points ,@rownum:=@rownum+1 AS bestxpoints
FROM
(
SELECT
DISTINCT e.id,
CASE rr.leaguepoints WHEN 11 THEN 10 ELSE rr.leaguepoints END AS points
FROM wp_bhaa_raceresult rr
inner join wp_posts r ON rr.race = r.id
inner join wp_postmeta rt on (rt.post_id=r.id and rt.meta_key = 'bhaa_race_type')
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.ID)
inner join wp_posts e ON e2r.p2p_from = e.id
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_to=e.ID)
inner JOIN wp_posts le ON l2e.p2p_from = le.id
WHERE runner=_runnerId AND le.id=_leagueId
AND rr.class in ('RAN', 'RACE_ORG', 'RACE_POINTS')
AND rt.meta_value!='TRACK'
order by rr.leaguepoints desc) r1, (SELECT @rownum:=0) r2
) t where t.bestxpoints <= _racesToCount
);

RETURN _pointsTotal;

END$$

-- updateTeamLeagueSummary
DROP PROCEDURE IF EXISTS updateTeamLeagueSummary$$
CREATE PROCEDURE updateTeamLeagueSummary(_leagueId INT)
BEGIN

update wp_bhaa_teamresult set leaguepoints=1 where position>=7 and class!='R';
update wp_bhaa_teamresult set leaguepoints=(7-(position)) where class!='R' and position<=6;

DELETE FROM wp_bhaa_leaguesummary WHERE leagueType='T' and league = _leagueId;

INSERT INTO wp_bhaa_leaguesummary(
league,
leaguetype,
leagueparticipant,
leaguestandard,
leaguedivision,
leagueposition,
leaguescorecount,
leaguepoints,
leaguesummary)
SELECT
t1.league,
t1.leaguetype,
t1.leagueparticipant,
t1.leaguestandard as leaguestandard,
'W' AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.leaguescorecount,
t1.leaguepoints as leaguepoints,
t1.leaguesummary AS leaguesummary
FROM
(
SELECT
_leagueId AS league,
'T' AS leaguetype,
l.team AS leagueparticipant,
0 AS leaguestandard,
0 AS leaguedivision,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints,
GROUP_CONCAT( cast( concat_ws(':',l.event,l.leaguepoints,IF(l.class='R','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary
FROM
(
SELECT 1 AS leaguescorecount, team, race, class, MAX(leaguepoints) AS leaguepoints, e2r.p2p_from as event
FROM wp_bhaa_teamresult trr
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=trr.race)
WHERE class in ('W','R')
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;

-- t1.leaguepoints - (SELECT count(1) FROM wp_bhaa_teamresult where team = t1.leagueparticipant and class='R') as leaguepoints,
INSERT INTO wp_bhaa_leaguesummary(
league,
leaguetype,
leagueparticipant,
leaguestandard,
leaguedivision,
leagueposition,
leaguescorecount,
leaguepoints,
leaguesummary)
SELECT
t1.league,
t1.leaguetype,
t1.leagueparticipant,
t1.leaguestandard as leaguestandard,
'M' AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.leaguescorecount,
t1.leaguepoints as leaguepoints,
t1.leaguesummary AS leaguesummary
FROM
(
SELECT
_leagueId AS league,
'T' AS leaguetype,
l.team AS leagueparticipant,
0 AS leaguestandard,
0 AS leaguedivision,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints,
GROUP_CONCAT( cast( concat_ws(':',l.event,l.leaguepoints,IF(l.class='R','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary
FROM
(
SELECT 1 AS leaguescorecount, team, race, class, MAX(leaguepoints) AS leaguepoints, e2r.p2p_from as event
FROM wp_bhaa_teamresult trr
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=trr.race)
WHERE class <> 'W'
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;

update wp_bhaa_leaguesummary set leaguesummary=getTeamLeagueSummary(leagueparticipant,_leagueId,'M') where league=_leagueId and leaguedivision in ('M');
update wp_bhaa_leaguesummary set leaguesummary=getTeamLeagueSummary(leagueparticipant,_leagueId,'W') where league=_leagueId and leaguedivision in ('W');

END$$

-- updateTeamLeagueSummary
DROP PROCEDURE IF EXISTS updateTeamLeagueSummary$$
CREATE PROCEDURE updateTeamLeagueSummary(_leagueId INT)
BEGIN

select r.ID as race,r_type.meta_value as type,e.post_name as event from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
AND l.ID=2812
AND r_type.meta_value in ('C','S','M','W')
AND r_type.meta_value!='TRACK'
order by eme.event_start_date ASC

DELIMITER ;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
team results

select * from bhaaie_members.teamraceresult where race=201282

select
id,
team,
league,
(select new from wp_bhaa_import where type='race' and old=race) as race,
standardtotal,
positiontotal,
class,
leaguepoints,
status
from bhaaie_members.teamraceresult where race=201282

select * from wp_bhaa_teamresult
delete from wp_bhaa_teamresult

-- migrate the team results
insert into wp_bhaa_teamresult
select
id,
team,
league,
(select new from wp_bhaa_import where type='race' and old=race) as race,
standardtotal,
positiontotal,
class,
leaguepoints,
status
from bhaaie_members.teamraceresult where race=201282

select * from posts where
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
runner id's

SELECT MAX(ID) FROM wp_users;

-- gaps in the BHAA member range of 10000 to 9999
select l.id + 1 as start
from wp_users as l
left outer join wp_users as r on l.id + 1 = r.id
where r.id is null
and l.id>10000 and l.id<50000
limit 1;

-- gaps in the BHAA member range of 1000 to 9999
select l.id + 1 as start
from wp_users as l
left outer join wp_users as r on l.id + 1 = r.id
where r.id is null
and l.id>1000 and l.id<9999;

SELECT COUNT(ID) FROM wp_users WHERE ID>30000; -- 209 rows

SELECT MAX(ID) FROM wp_users WHERE ID<30000; -- 29963 is the max is sub 30000

SHOW TABLE STATUS FROM bhaaie_wp WHERE name LIKE 'wp_users'; -- max 990108

SELECT AUTO_INCREMENT
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bhaaie_wp'
AND TABLE_NAME = 'wp_users';

-- ALTER TABLE users AUTO_INCREMENT = 1;

SELECT ID,
(SELECT COUNT(ID) FROM wp_bhaa_raceresult WHERE runner=ID and class='RAN') as runcount,
(SELECT meta_value FROM wp_usermeta WHERE meta_key='bhaa_runner_status' and user_id=ID)
FROM wp_users WHERE ID>30000
ORDER BY ID DESC LIMIT 1000;
-- 990107

990102
SELECT * FROM wp_p2p
WHERE p2p_from=990102

UPDATE wp_users
SET ID=10143
WHERE ID=989899;

Auto Increment 990108
Max Runner 29963
Next Runner ID 10950

ALTER TABLE wp_users AUTO_INCREMENT = 30000;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
users

select * from wp_usermeta where user_id=1

select * from wp_usermeta where user_id=7713 and meta_key='bhaa_runner_company';

update wp_usermeta set meta_value=97 where user_id=7713 and meta_key='bhaa_runner_company';
update wp_usermeta set meta_value='' where user_id=7713 and meta_key='bhaa_runner_company';

select * from wp_posts where ID=1;

select * from wp_p2p where p2p_to=6704
UNION
select * from wp_p2p where p2p_from=6704

select * from wp_p2p where p2p_to=7194
UNION
select * from wp_p2p where p2p_from=7194

select * from wp_bhaa_raceresult where class='RACE_REG';
delete from wp_bhaa_raceresult where class='RACE_REG';

-- raceday-members SQL
select wp_users.id as id,wp_users.id as value,
wp_users.display_name as label,
first_name.meta_value as firstname,
last_name.meta_value as lastname,
status.meta_value as status,
gender.meta_value as gender,
dob.meta_value as dob,
company.meta_value as company,
house.post_title as companyname,
standard.meta_value as standard
from wp_users
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key="bhaa_runner_company")
left join wp_posts house on (house.id=company.meta_value and house.post_type="house")
left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
where status.meta_value IN('M','I') and wp_users.id in(6704,7194,7713) order by lastname,firstname;

-- Export SQL
SELECT wp_bhaa_raceresult.id,runner,racenumber,race,
firstname.meta_value as firstname,lastname.meta_value as lastname,
gender.meta_value as gender,dateofbirth.meta_value as dateofbirth,
standard.meta_value as standard,status.meta_value as status,
house.id as company,
CASE WHEN house.post_title IS NULL THEN companyname.post_title ELSE house.post_title END as companyname,
CASE WHEN sector.id IS NOT NULL THEN sector.id ELSE house.id END as teamid,
CASE WHEN sector.post_title IS NOT NULL THEN sector.post_title ELSE house.post_title END as teamname,
standardscoringset
from wp_bhaa_raceresult
JOIN wp_p2p e2r ON (wp_bhaa_raceresult.race=e2r.p2p_to AND e2r.p2p_type='event_to_race')
JOIN wp_users on (wp_users.id=wp_bhaa_raceresult.runner)
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_posts house on (house.id=r2c.p2p_from and house.post_type='house')
left join wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = 'sectorteam_to_runner')
left join wp_posts sector on (sector.id=r2s.p2p_from and house.post_type='house')
left join wp_usermeta firstname ON (firstname.user_id=wp_users.id AND firstname.meta_key = 'first_name')
left join wp_usermeta lastname ON (lastname.user_id=wp_users.id AND lastname.meta_key = 'last_name')
left join wp_usermeta gender ON (gender.user_id=wp_users.id AND gender.meta_key = 'bhaa_runner_gender')
left join wp_usermeta dateofbirth ON (dateofbirth.user_id=wp_users.id AND dateofbirth.meta_key = 'bhaa_runner_dateofbirth')
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
left join wp_usermeta standard ON (standard.user_id=wp_users.id AND standard.meta_key = 'bhaa_runner_standard')
left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
left join wp_posts companyname on (companyname.id=company.meta_value and companyname.post_type='house')
where wp_bhaa_raceresult.class='RACE_REG'

SELECT wp_bhaa_raceresult.id,runner,racenumber,race,
firstname.meta_value as firstname,lastname.meta_value as lastname,
gender.meta_value as gender,dateofbirth.meta_value as dateofbirth,
standard.meta_value as standard,status.meta_value as status,
house.id as companyid,
house.post_title as companyname,
CASE WHEN r2s.p2p_from IS NOT NULL THEN r2s.p2p_from ELSE r2c.p2p_from END as teamid,
CASE WHEN r2s.p2p_from IS NOT NULL THEN sectorteam.post_title ELSE house.post_title END as teamname,
standardscoringset
from wp_bhaa_raceresult
JOIN wp_p2p e2r ON (wp_bhaa_raceresult.race=e2r.p2p_to AND e2r.p2p_type='event_to_race')
JOIN wp_users on (wp_users.id=wp_bhaa_raceresult.runner)
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = 'sectorteam_to_runner')
left join wp_posts house on (house.id=r2c.p2p_from and house.post_type='house')
left join wp_posts sectorteam on (sectorteam.id=r2s.p2p_from and sectorteam.post_type='house')
left join wp_usermeta firstname ON (firstname.user_id=wp_users.id AND firstname.meta_key = 'first_name')
left join wp_usermeta lastname ON (lastname.user_id=wp_users.id AND lastname.meta_key = 'last_name')
left join wp_usermeta gender ON (gender.user_id=wp_users.id AND gender.meta_key = 'bhaa_runner_gender')
left join wp_usermeta dateofbirth ON (dateofbirth.user_id=wp_users.id AND dateofbirth.meta_key = 'bhaa_runner_dateofbirth')
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
left join wp_usermeta standard ON (standard.user_id=wp_users.id AND standard.meta_key = 'bhaa_runner_standard')
where wp_bhaa_raceresult.class='RACE_REG'

--CASE WHEN house.post_title IS NULL THEN companyname.post_title ELSE house.post_title END as companyname,
--CASE WHEN sector.id IS NOT NULL THEN sector.id ELSE house.id END as teamid,
--CASE WHEN sector.post_title IS NOT NULL THEN sector.post_title ELSE house.post_title END as teamname,

--left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
--left join wp_posts companyname on (companyname.id=company.meta_value and companyname.post_type='house')

-- create table
create table gluser_bhaarunner (
gl_users_id int(11) NOT NULL,
bhaa_runner_id int(11) NOT NULL,
email varchar(50) NOT NULL)
ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop table gluser_bhaarunner
select * from gluser_bhaarunner
delete from gluser_bhaarunner

-- insert matches
insert into gluser_bhaarunner
select gl_users.uid,runner.id,runner.email from gl_users
join runner on runner.email=gl_users.email and runner.email!='';

-- UTIL
select uid,email from gl_users
select gl_users.uid,gl_users.email,runner.id,runner.email from gl_users
join runner on runner.email=gl_users.email and runner.email!='';

-- registrar email
select * from wp_users where user_email='registrar@bhaa.ie'
update wp_users set user_email=CONCAT(user_login,'@x.com') where user_email='registrar@bhaa.ie'

-- new users
select * from wp_users where user_registered > '2013-01-01';
select * from wp_users
join wp_usermeta on wp_usermeta.user_id=wp_users.id
where user_registered > '2013-01-01'
and wp_usermeta.meta_key='bhaa_runner_status'
and wp_usermeta.meta_value='M';

-- oct - dec 2012 members
select count(id) from bhaaie_members.runner where dateofrenewal>="2012-01-01";

select count(id) from bhaaie_members.runner where
dateofrenewal between '2012-10-1' and '2012-12-31'
and status='M'

select count(id) from bhaaie_members.runner where dateofrenewal = '2013-01-01'

update bhaaie_members.runner
set dateofrenewal='2013-01-01'
where dateofrenewal between '2012-10-1' and '2012-12-31'
and status='M'

select MONTHNAME(dateofrenewal), count(id)
from bhaaie_members.runner
where status='m'
and dateofrenewal>="2013-01-01"
group by MONTHNAME(dateofrenewal)
order by MONTH(dateofrenewal);

-- non renewed runners
select count(id) from runner where YEAR(dateofrenewal)=2012 and status="M";
update runner set status="I" where YEAR(dateofrenewal)=2012 and status="M";
select count(id) from runner where YEAR(dateofrenewal)=2013 and status="M"

select count(user_id) from wp_users
join wp_usermeta m1 on (
m1.user_id=wp_users.id and
m1.meta_key='bhaa_runner_status' and
m1.meta_value='M');

-- select all wordpress users who have renewed
select wp_users.id,wp_users.user_nicename from wp_users
join wp_usermeta m1 on (
m1.user_id=wp_users.id and
m1.meta_key='bhaa_runner_status' and
m1.meta_value='M')
join wp_usermeta m2 on (
m2.user_id=wp_users.id and
m2.meta_key='bhaa_runner_dateofrenewal' and
YEAR(m2.meta_value)='2013') order by id;

-- 	INSERT INTO `runner`(`id`, `surname`, `firstname`, `gender`, `dateofbirth`, `company`, `email`, `mobilephone`,
-- `status`, `insertdate`, `dateofrenewal`)

-- select new wordpress users
select wp_users.id,mfn.meta_value,mln.meta_value,mg.meta_value,mdob.meta_value,
mc.meta_value,wp_users.user_email,mp.meta_value,ms.meta_value,mdor.meta_value,mdor.meta_value from wp_users
join wp_usermeta ms on (
ms.user_id=wp_users.id and
ms.meta_key='bhaa_runner_status' and
ms.meta_value='M')
join wp_usermeta mfn on (
mfn.user_id=wp_users.id and
mfn.meta_key='first_name')
join wp_usermeta mln on (
mln.user_id=wp_users.id and
mln.meta_key='last_name')
join wp_usermeta mg on (
mg.user_id=wp_users.id and
mg.meta_key='bhaa_runner_gender')
join wp_usermeta mdob on (
mdob.user_id=wp_users.id and
mdob.meta_key='bhaa_runner_dateofbirth')
join wp_usermeta mc on (
mc.user_id=wp_users.id and
mc.meta_key='bhaa_runner_company')
join wp_usermeta mp on (
mp.user_id=wp_users.id and
mp.meta_key='bhaa_runner_mobilephone')
join wp_usermeta mdor on (
mdor.user_id=wp_users.id and
mdor.meta_key='bhaa_runner_dateofrenewal')
where id>21000
order by id;

select * from bhaaie_members.runner where id>21000;

INSERT INTO bhaaie_members.runner(id,firstname,surname,gender,dateofbirth,company,email,
mobilephone,status,insertdate,dateofrenewal)
select wp_users.id,mfn.meta_value,mln.meta_value,mg.meta_value,mdob.meta_value,
mc.meta_value,wp_users.user_email,mp.meta_value,ms.meta_value,mdor.meta_value,mdor.meta_value from wp_users
join wp_usermeta ms on (
ms.user_id=wp_users.id and
ms.meta_key='bhaa_runner_status' and
ms.meta_value='M')
join wp_usermeta mfn on (
mfn.user_id=wp_users.id and
mfn.meta_key='first_name')
join wp_usermeta mln on (
mln.user_id=wp_users.id and
mln.meta_key='last_name')
join wp_usermeta mg on (
mg.user_id=wp_users.id and
mg.meta_key='bhaa_runner_gender')
join wp_usermeta mdob on (
mdob.user_id=wp_users.id and
mdob.meta_key='bhaa_runner_dateofbirth')
left join wp_usermeta mc on (
mc.user_id=wp_users.id and
mc.meta_key='bhaa_runner_company')
join wp_usermeta mp on (
mp.user_id=wp_users.id and
mp.meta_key='bhaa_runner_mobilephone')
join wp_usermeta mdor on (
mdor.user_id=wp_users.id and
mdor.meta_key='bhaa_runner_dateofrenewal')
where id=22964
order by wp_users.id;

UPDATE bhaaie_members.runner
join wp_users wp_users on (
wp_users.id=runner.id)
join wp_usermeta ms on (
ms.user_id=wp_users.id and
ms.meta_key='bhaa_runner_status' and
ms.meta_value='M')
join wp_usermeta mfn on (
mfn.user_id=wp_users.id and
mfn.meta_key='first_name')
join wp_usermeta mln on (
mln.user_id=wp_users.id and
mln.meta_key='last_name')
join wp_usermeta mg on (
mg.user_id=wp_users.id and
mg.meta_key='bhaa_runner_gender')
join wp_usermeta mdob on (
mdob.user_id=wp_users.id and
mdob.meta_key='bhaa_runner_dateofbirth')
left join wp_usermeta mc on (
mc.user_id=wp_users.id and
mc.meta_key='bhaa_runner_company')
join wp_usermeta mp on (
mp.user_id=wp_users.id and
mp.meta_key='bhaa_runner_mobilephone')
join wp_usermeta mdor on (
mdor.user_id=wp_users.id and
mdor.meta_key='bhaa_runner_dateofrenewal')
set
firstname=mfn.meta_value,
surname=mln.meta_value,
gender=mg.meta_value,
dateofbirth=mdob.meta_value,
company=mc.meta_value,
email=wp_users.user_email,
mobilephone=mp.meta_value,
status=ms.meta_value,
insertdate=mdor.meta_value,
dateofrenewal=mdor.meta_value
where wp_users.ID>21000;

-- update existing wp to members runners
UPDATE bhaaie_members.runner
join wp_users wp_users on (
wp_users.id=runner.id)
join wp_usermeta ms on (
ms.user_id=wp_users.id and
ms.meta_key='bhaa_runner_status' and
ms.meta_value='M')
join wp_usermeta mdor on (
mdor.user_id=wp_users.id and
mdor.meta_key='bhaa_runner_dateofrenewal' and
YEAR(mdor.meta_value)='2013')
set
runner.status=ms.meta_value,
runner.dateofrenewal=mdor.meta_value
where wp_users.id>1500 and wp_users.id<10000;

-- runners with std 30!
select * from wp_usermeta where meta_key='bhaa_runner_standard' and meta_value=30
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_agecategory

-- pull from bhaa to wp
select * from bhaaie_members.agecategory;

DROP TABLE IF EXISTS wp_bhaa_agecategory;
CREATE TABLE IF NOT EXISTS wp_bhaa_agecategory (
category varchar(6) DEFAULT NULL,
gender enum('M','W') DEFAULT 'M',
min int(11) NOT NULL,
max int(11) NOT NULL,
PRIMARY KEY (category)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

select * from wp_bhaa_agecategory;
delete from wp_bhaa_agecategory;

INSERT INTO wp_bhaa_agecategory (category, min, max) VALUES
('Senior', 18, 34),
('35', 35, 39),
('40', 40, 44),
('45', 45, 49),
('50', 50, 54),
('55', 55, 59),
('60', 60, 64),
('65', 65, 69),
('70', 70, 74),
('75', 75, 79),
('80', 80, 84),
('85', 85, 120),
('Junior', 0, 17);

insert into wp_bhaa_agecategory select category,gender,min,max from bhaaie_members.agecategory;
alter table wp_bhaa_agecategory DROP gender;

-- 35 mens
update wp_bhaa_agecategory set max=34 where category='SM';
insert into wp_bhaa_agecategory VALUES('M35','M',35,39);

SELECT DISTINCT(category) FROM wp_bhaa_raceresult;
UPDATE wp_bhaa_raceresult SET category = 'S' WHERE category = 'Senior';
UPDATE wp_bhaa_raceresult SET category = 'S' WHERE category IS NULL;

-- r7713 and race=3854
SELECT runner.id,eventdate,gender.meta_value,dob.meta_value,
getAgeCategory(dob.meta_value,eventdate,gender.meta_value) as age,
CONCAT(getAgeCategory(dob.meta_value,eventdate,gender.meta_value),gender.meta_value) as ageCat
FROM wp_bhaa_race_detail
LEFT JOIN wp_users runner ON runner.id=7713
LEFT JOIN wp_usermeta gender ON (gender.user_id=runner.id and gender.meta_key='bhaa_runner_gender')
LEFT JOIN wp_usermeta dob ON (dob.user_id=runner.id and dob.meta_key='bhaa_runner_dateofbirth')
WHERE race=3854 LIMIT 1
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_division

-- wp_bhaa_division
DROP TABLE IF EXISTS wp_bhaa_division;
CREATE TABLE IF NOT EXISTS wp_bhaa_division (
id int(11) NOT NULL AUTO_INCREMENT,
name varchar(20) DEFAULT NULL,
code varchar(2) DEFAULT NULL,
gender enum('M','W','T') DEFAULT 'M',
min int(11) NOT NULL,
max int(11) NOT NULL,
type enum('I','T') DEFAULT 'I',
PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=14;
--
-- Dumping data for table wp_bhaa_division

INSERT INTO wp_bhaa_division (id, name, code, gender, min, max, type) VALUES
(1, 'Men Division A', 'A', 'M', 1, 7, 'I'),
(2, 'Men Division B', 'B', 'M', 8, 10, 'I'),
(3, 'Men Division C', 'C', 'M', 11, 13, 'I'),
(4, 'Men Division D', 'D', 'M', 14, 16, 'I'),
(5, 'Men Division E', 'E', 'M', 17, 21, 'I'),
(6, 'Men Division F', 'F', 'M', 22, 30, 'I'),
(7, 'Women Division A', 'L1', 'W', 1, 16, 'I'),
(8, 'Women Division B', 'L2', 'W', 17, 30, 'I'),
(9, 'Mens Team League A', 'A', 'M', 1, 30, 'T'),
(10, 'Mens Team League B', 'B', 'M', 31, 38, 'T'),
(11, 'Mens Team League C', 'C', 'M', 39, 46, 'T'),
(12, 'Mens Team League D', 'D', 'M', 47, 90, 'T'),
(13, 'Womens Team League', 'W', 'W', 1, 90, 'T');

select * from wp_bhaa_division where type="I";

select code from wp_bhaa_division
where 7 between min and max and gender="W" and type="I"

select code,gender.meta_value from wp_bhaa_division
JOIN wp_usermeta gender ON (gender.user_id=id AND gender.meta_key = 'bhaa_runner_gender')
where 7 between min and max and gender="W" and type="I" and id=7713

select code,gender.meta_value,standard.meta_value from wp_bhaa_division
JOIN wp_usermeta gender ON (gender.user_id=id AND gender.meta_key = 'bhaa_runner_gender')
JOIN wp_usermeta standard ON (standard.user_id=id AND standard.meta_key = 'bhaa_runner_standard')
where standard.meta_value between min and max and gender=gender.meta_value and type="I" and id=7713

select code,gender.meta_value,standard.meta_value from wp_bhaa_division
inner JOIN wp_usermeta gender ON (gender.user_id=id AND gender.meta_key = 'bhaa_runner_gender')
inner JOIN wp_usermeta standard ON (standard.user_id=id AND standard.meta_key = 'bhaa_runner_standard')
where standard.meta_value between min and max and gender=gender.meta_value and type="I" and id=7713

select lrd.runner, d.code, lrd.pointsTotal
from leaguerunnerdata lrd
join runner r on lrd.runner = r.id
join division d on lrd.standard between d.min and d.max and d.type='I' and
d.gender=r.gender
where league=6 and runner = 7713
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_houses

-- rename the teamtype values
select * from wp_term_taxonomy where taxonomy = 'teamtype'
select * from wp_terms where term_id in (88,89,90)
update wp_terms set name='company',slug='company' where name='companyteam';
update wp_terms set name='sector',slug='sector' where name='sectorteam';
update wp_terms set name='inactive',slug='inactive' where name='inactiveteam';

-- list the runners in teams
select * from wp_users
inner join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key='bhaa_runner_company')
WHERE NOT EXISTS (
SELECT * FROM p2p_wp_usermeta standard WHERE standard.user_id=wp_users.id and standard.meta_key='bhaa_runner_standard'
)

-- runner id, company and if they are linked
select wp_users.id,wp_users.display_name,status.meta_value,dor.meta_value,company.meta_value,house.post_title,r2c.p2p_from from wp_users
left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
join wp_posts house on (house.id=company.meta_value and house.post_type='house')
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
left join wp_usermeta dor ON (dor.user_id=wp_users.id AND dor.meta_key = 'bhaa_runner_dateofrenewal')
where company.meta_value IS NOT NULL and r2c.p2p_from IS NULL and status.meta_value='M'

insert into wp_p2p (p2p_type,p2p_from,p2p_to)
select 'house_to_runner',company.meta_value,wp_users.id from wp_users
left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
join wp_posts house on (house.id=company.meta_value and house.post_type='house')
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
where company.meta_value IS NOT NULL and r2c.p2p_from IS NULL and status.meta_value='M'

-- where the two values are set but not the same
-- company.meta_value!=r2c.p2p_from

-- a specific runner
-- where wp_users.id=11046

-- list the runners not linked to teams
-- select non-active company teams with

-- list companies and number of active runner

-- select sector teams with more than 6 runners
select p2p_from,house.post_title,count(p2p_id) as total,
(select p2p_to from wp_p2p contact where contact.p2p_from=wp_p2p.p2p_from and contact.p2p_type='team_contact') as contact
from wp_p2p
join wp_posts house on (house.id=wp_p2p.p2p_from and house.post_type='house')
where p2p_type='sectorteam_to_runner'
group by p2p_from
order by total desc;

select p2p_from,house.post_title,count(p2p_id) as total,
(select p2p_to from wp_p2p contact where contact.p2p_from=wp_p2p.p2p_from and contact.p2p_type='team_contact') as contact
from wp_p2p
join wp_posts house on (house.id=wp_p2p.p2p_from and house.post_type='house')
where p2p_type='house_to_runner'
group by p2p_from
order by total desc;

-- select runners on two teams
SELECT p2p_to,
(select display_name from wp_users where id=p2p_to) as name,
MIN(p2p_id),
MIN(p2p_from),
(select post_title from wp_posts where post_type='House' and id=MIN(p2p_from)) as c1,
MAX(p2p_id),
MAX(p2p_from),
(select post_title from wp_posts where post_type='House' and id=MAX(p2p_from)) as c2,
p2p_type
FROM wp_p2p
WHERE p2p_type='house_to_runner'
GROUP BY p2p_to
HAVING count(p2p_id) > 1 limit 10;

SELECT p2p_to,
(select display_name from wp_users where id=p2p_to) as name,
MIN(p2p_id),
MIN(p2p_from),
(select post_title from wp_posts where post_type='House' and id=MIN(p2p_from)) as c1,
MAX(p2p_id),
MAX(p2p_from),
(select post_title from wp_posts where post_type='House' and id=MAX(p2p_from)) as c2,
p2p_type
FROM wp_p2p
WHERE p2p_type='sectorteam_to_runner'
GROUP BY p2p_to
HAVING count(p2p_id) > 1

-- select active teams without contacts

select count(p2p_to) from wp_p2p
where p2p_from=585 and p2p_type='house_to_runner';

select count(p2p_to) from wp_p2p
where p2p_from=97 and p2p_type='house_to_runner';

select count(p2p_to) from wp_p2p
join wp_usermeta status ON (status.user_id=wp_p2p.p2p_to AND status.meta_key = 'bhaa_runner_status' and status.meta_value='M')
where p2p_from=97 and p2p_type='house_to_runner';
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_leaguesummary

DROP TABLE IF EXISTS wp_bhaa_leaguesummary;
CREATE TABLE IF NOT EXISTS wp_bhaa_leaguesummary (
league int(10) unsigned NOT NULL,
leaguetype enum('I','T') NOT NULL,
leagueparticipant int(10) unsigned NOT NULL,
leaguestandard int(10) unsigned NOT NULL,
leaguedivision varchar(5) NOT NULL,
leagueposition int(10) unsigned NOT NULL,
leaguescorecount int(10) unsigned NOT NULL,
leaguepoints double NOT NULL,
leaguesummary varchar(500),
PRIMARY KEY (leaguetype, league, leagueparticipant, leaguedivision) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE wp_bhaa_leaguesummary ADD COLUMN leaguesummary varchar(500) DEFAULT NULL AFTER leaguepoints;

update wp_bhaa_leaguesummary set leaguesummary='{"0":{"eid":"2121","race":"2359","leaguepoints":"10"},"1":{"eid":"2123","race":"2362","leaguepoints":"10"}}';
update wp_bhaa_leaguesummary set leaguesummary=NULL;

select * from wp_bhaa_leaguesummary where league=11 and leaguedivision=

INSERT INTO wp_bhaa_import (id, tag, type, new, old) VALUES
(NULL, 'winter2013', 'league', 2492, 13);

select * from wp_posts where post_type='league';
select * from wp_posts where post_type='event';

select l.ID as lid,l.post_title,
e.ID as eid,e.post_title as etitle,
r.ID as rid,r.post_title as rtitle,r_type.meta_value as rtype
from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2492
and r_type.meta_value in ('C','M')

--inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
select runner,race,leaguepoints,e.ID as eid,e.post_title as etitle from wp_bhaa_raceresult
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=race)
inner join wp_posts e on (e.id=e2r.p2p_from)
where race in (2358,2359,2360,2362)
and runner=7713;

SELECT wp_posts., wp_p2p. FROM wp_posts
INNER JOIN wp_p2p WHERE 1=1 AND wp_posts.post_type IN ('league')
AND (wp_posts.post_status = 'publish') AND (wp_p2p.p2p_type = 'league_to_event'
AND wp_posts.ID = wp_p2p.p2p_from AND wp_p2p.p2p_to
IN (SELECT wp_posts.ID FROM wp_posts WHERE 1=1 AND wp_posts.ID IN (0)
AND wp_posts.post_type IN ('event') AND (wp_posts.post_status = 'publish')
ORDER BY wp_posts.post_date DESC )) ORDER BY wp_posts.post_date DESC

SELECT rr.runner, rr.race, rr.leaguepoints,
mrr.runner, mrr.race, mrr.points
FROM wp_bhaa_raceresult rr
LEFT JOIN wp_bhaa_import i ON ( i.type = 'race' AND i.new = rr.race )
JOIN bhaaie_members.raceresult mrr ON ( mrr.race = i.old AND mrr.runner = rr.runner )
AND rr.race >=1783
AND rr.runner=7713

update wp_bhaa_raceresult rr
left join wp_bhaa_import i on (i.type='race' and i.new=rr.race)
left join bhaaie_members.raceresult mrr on (mrr.race=i.old and mrr.runner=rr.runner)
set leaguepoints=points
where rr.race>=1783 and rr.runner=7713;

call procedure updateRaceScoringSets(2499);

select * from bhaaie_members.league

select * from wp_bhaa_raceresult where runner=7713;

select * from wp_bhaa_raceresult where runner=7713;

select * from bhaaie_members.racepointsdata where runner=7713;

select * from bhaaie_members.racepoints where runner=7713;

select * from bhaaie_members.leaguesummary where leagueid=13;
update wp_bhaa_leaguesummary set league=2492 where league=13;

INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguedivision,leagueposition,leaguescorecount,leaguepoints)
select
2492,"I",leagueparticipantid,leaguestandard,leaguedivision,leagueposition,leaguescorecount,leaguepoints
from bhaaie_members.leaguesummary where leagueid=13;

select * from wp_posts where post_type='race' AND id>=3101 AND id<=3523;

-- winter 2013
select wp_posts.post_title,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and class NOT IN ('RO','W','WO')) as total,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='A' group by race,class) as Amin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='A' group by race,class) as Amax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='A' group by race,class) as Ateams,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='B' group by race,class) as Bmin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='B' group by race,class) as Bmax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='B' group by race,class) as Bteams,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='C' group by race,class) as Cmin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='C' group by race,class) as Cmax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='C' group by race,class) as Cteams,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='D' group by race,class) as Dmin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='D' group by race,class) as Dmax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='D' group by race,class) as Dteams
from wp_posts where post_type='race' AND id>=3101 AND id<=3523;

-- summer 2013
select wp_posts.post_title,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and class NOT IN ('RO','W','WO')) as total,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='A' group by race,class) as Amin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='A' group by race,class) as Amax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='A' group by race,class) as Ateams,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='B' group by race,class) as Bmin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='B' group by race,class) as Bmax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='B' group by race,class) as Bteams,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='C' group by race,class) as Cmin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='C' group by race,class) as Cmax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='C' group by race,class) as Cteams,
(select Min(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='D' group by race,class) as Dmin,
(select Max(totalstd) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='D' group by race,class) as Dmax,
(select ROUND(COUNT(team)/3) from wp_bhaa_teamresult trr where trr.race=wp_posts.id and Class='D' group by race,class) as Dteams
from wp_posts where post_type='race' AND id>=2595 AND id<=2856;

race join event on event.id=wp_posts.event
where race.id > 2010 and race.type IN ('M','C') and event.type != "track";
and race.type IN ('M','C') and event.type != "track";
where race.id between 201200 and 201199

DROP TABLE IF EXISTS wp_bhaa_leaguerunnerdata;
CREATE TABLE IF NOT EXISTS wp_bhaa_leaguerunnerdata (
id int(11) unsigned NOT NULL AUTO_INCREMENT,
league int(11) unsigned NOT NULL,
runner int(11) unsigned NOT NULL,
racesComplete int(11) unsigned NOT NULL,
pointsTotal double DEFAULT NULL,
avgOverallPosition double NOT NULL,
standard int(11) DEFAULT NULL,
PRIMARY KEY (id)
); ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT;

call procedure getLeaguePointsTotal(2492,7713);

SELECT DISTINCT e.id,
CASE rr.leaguepoints WHEN 11 THEN 10 ELSE rr.leaguepoints END AS points
FROM wp_bhaa_raceresult rr
inner join wp_posts r ON rr.race = r.id
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.ID)
inner join wp_posts e ON e2r.p2p_from = e.id
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_to=e.ID)
inner JOIN wp_posts le ON l2e.p2p_from = le.id
WHERE runner=7713 AND le.id=2492
and rr.class in ('RAN', 'RACE_ORG', 'RACE_POINTS') order by rr.leaguepoints desc

delete from wp_bhaa_leaguesummary

call updateLeagueData(2492);

call updateLeagueData(2659);

INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,leaguedivision,leagueposition)
select
2659,"I",runner,standard,racesComplete,ROUND(pointsTotal,1),'A',1
from wp_bhaa_leaguerunnerdata
where runner=7649

DELETE FROM wp_bhaa_leaguesummary WHERE league=2659;
SELECT * FROM wp_bhaa_leaguesummary WHERE league=2659;

-- individual league summary
INSERT INTO wp_bhaa_leaguesummary(league,leaguetype,leagueparticipant,leaguestandard,leaguescorecount,leaguepoints,leaguedivision,leagueposition)
SELECT
le.id,
'I',
rr.runner,
ROUND(AVG(rr.standard),0) as std,
COUNT(rr.race) as racesran,
ROUND(getLeaguePointsTotal(le.id,rr.runner),1) as leaguepoints,
GROUP_CONCAT( cast( concat_ws(':',r.ID,rr.leaguepoints,IF(class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummaryz,
GROUP_CONCAT( cast( concat_ws(':',e.ID,rr.leaguepoints,IF(class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary,
1
FROM wp_bhaa_raceresult rr
inner join wp_posts r ON rr.race = r.id
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.ID)
inner join wp_posts e ON e2r.p2p_from = e.id
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_to=e.ID)
inner JOIN wp_posts le ON l2e.p2p_from = le.id
inner JOIN wp_users ru ON rr.runner = ru.id
JOIN wp_usermeta status ON (status.user_id=rr.runner AND status.meta_key = 'bhaa_runner_status')
JOIN wp_usermeta standard ON (standard.user_id=rr.runner AND standard.meta_key = 'bhaa_runner_standard')
WHERE le.id=2659 AND class='RAN' AND standard.meta_value IS NOT NULL AND status.meta_value='M'
AND rr.runner in (7713,1506,1501)
GROUP BY le.id,rr.runner
HAVING COALESCE(leaguepoints, 0) > 0;

-- select all race id's in a league
select r.ID as race,r_type.meta_value as type,e.post_name as name,e.id as event from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
AND l.ID=2659
AND r_type.meta_value in ('C','S','M','W')
AND r_type.meta_value!='TRACK'
order by eme.event_start_date ASC

select r.ID as race,r_type.meta_value as type,e.post_name as event from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
AND l.ID=2812
AND r_type.meta_value in ('C','S','M','W')
AND r_type.meta_value!='TRACK'
order by eme.event_start_date ASC

update wp_bhaa_leaguesummary
JOIN wp_usermeta gender ON (gender.user_id=wp_bhaa_leaguesummary.leagueparticipant AND gender.meta_key = 'bhaa_runner_gender')
JOIN wp_bhaa_division d ON ((wp_bhaa_leaguesummary.leaguestandard BETWEEN d.min AND d.max) AND d.type='I' and d.gender=gender.meta_value)
set wp_bhaa_leaguesummary.leaguedivision=d.code
where league=2659;

update wp_bhaa_leaguesummary
join wp_bhaa_leaguerunnerdata on (wp_bhaa_leaguerunnerdata.league=wp_bhaa_leaguesummary.league and wp_bhaa_leaguerunnerdata.runner=wp_bhaa_leaguesummary.leagueparticipant)
set
wp_bhaa_leaguesummary.leaguestandard=wp_bhaa_leaguerunnerdata.standard,
wp_bhaa_leaguesummary.leaguescorecount=wp_bhaa_leaguerunnerdata.racesComplete,
wp_bhaa_leaguesummary.leaguepoints=ROUND(wp_bhaa_leaguerunnerdata.pointsTotal,1);

-- update division
update wp_bhaa_leaguesummary
JOIN wp_usermeta gender ON (gender.user_id=wp_bhaa_leaguesummary.leagueparticipant AND gender.meta_key = 'bhaa_runner_gender')
JOIN wp_bhaa_division d ON ((wp_bhaa_leaguesummary.leaguestandard BETWEEN d.min AND d.max) AND d.type='I' and d.gender=gender.meta_value)
set wp_bhaa_leaguesummary.leaguedivision=d.code and league=2492;

select d.code,wp_bhaa_leaguesummary.* from wp_bhaa_leaguesummary
JOIN wp_usermeta gender ON (gender.user_id=wp_bhaa_leaguesummary.leagueparticipant AND gender.meta_key = 'bhaa_runner_gender')
JOIN wp_bhaa_division d ON ((wp_bhaa_leaguesummary.leaguestandard BETWEEN d.min AND d.max) AND d.type='I' and d.gender=gender.meta_value)

-- update position in division
select * from wp_bhaa_leaguesummary
where wp_bhaa_leaguesummary.leaguedivision="A"
order by leaguepoints desc

-- http://stackoverflow.com/questions/3196971/mysql-update-statement-to-store-ranking-positions
SET @r=0;
SELECT *, @r:= (@r+1) as Ranking FROM wp_bhaa_leaguesummary
where wp_bhaa_leaguesummary.leaguedivision="A"
ORDER BY leaguepoints DESC;

SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="A" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="B" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="C" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="D" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="E" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="F" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="L1" ORDER BY leaguepoints DESC;
SET @r=0;
UPDATE wp_bhaa_leaguesummary SET leagueposition=(@r:= (@r+1)) where wp_bhaa_leaguesummary.leaguedivision="L2" ORDER BY leaguepoints DESC;

-- top ten per division
SELECT *,wp_users.display_name
FROM wp_bhaa_leaguesummary
left join wp_users on wp_users.id=wp_bhaa_leaguesummary.leagueparticipant
WHERE leaguetype = "I"
AND leagueposition <= 10
AND league = 2659
order by league, leaguedivision desc, leaguepoints desc

SELECT leaguedivision, leagueposition,wp_users.display_name,wp_users.user_email,
mobile.meta_value as mobile,
(select post_title from wp_posts where id=company.meta_value) as company
FROM wp_bhaa_leaguesummary
left join wp_users on wp_users.id=wp_bhaa_leaguesummary.leagueparticipant
left JOIN wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
left JOIN wp_usermeta mobile ON (mobile.user_id=wp_users.id AND mobile.meta_key = 'bhaa_runner_mobilephone')
WHERE leaguetype = "I"
AND leagueposition <= 10
AND league = 2659
order by league, leaguedivision asc, leaguepoints desc

--brian maher ran 4miles in 19.06, i was checking the sp since the table sats std 30
-- i check the stanard against 6.4km and it's 1
select getStandard('00:19:06',6.4);
-- the lm race distance is 6.437376
select getRaceDistanceKm(2596);
-- put this value the sp and it gives 30
select getStandard('00:19:06',6.411);
-- something to do with rounding?

SELECT
le.id,
rr.runner,
COUNT(rr.race) as racesComplete,
getLeaguePointsTotal(le.id, rr.runner) as pointsTotal,
AVG(rr.position) as averageOverallPosition,
GROUP_CONCAT( cast( concat('[r=',r.ID,':p=',IFNULL(rr.leaguepoints,0),']') AS char ) SEPARATOR ',') AS summary,
ROUND(AVG(rr.standard),0) as standard
FROM wp_posts r
LEFT JOIN wp_bhaa_raceresult rr on (r.id=rr.race and rr.runner=7713)
JOIN wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.ID)
JOIN wp_posts e ON e2r.p2p_from = e.id
join wp_em_events eme on (eme.post_id=e.id)
JOIN wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_to=e.ID)
JOIN wp_posts le ON l2e.p2p_from = le.id
JOIN wp_users ru ON rr.runner = ru.id
JOIN wp_usermeta status ON (status.user_id=rr.runner AND status.meta_key = 'bhaa_runner_status')
JOIN wp_usermeta standard ON (standard.user_id=rr.runner AND standard.meta_key = 'bhaa_runner_standard')
WHERE le.id=2659
order by eme.event_start_date ASC

AND standard.meta_value IS NOT NULL AND status.meta_value='M'

and rr.runner=7713;

-- events in a league
select p2p_to from wp_p2p l2e
where l2e.p2p_type='league_to_event' and l2e.p2p_from=2659

-- races in a league
select l.ID as lid,l.post_title,
e.ID as eid,e.post_title as etitle,eme.event_start_date as edate,
r.ID as rid,r.post_title as rtitle,r_type.meta_value as rtype,
IFNULL(rr.leaguepoints,0) as points
from wp_posts l
join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
join wp_posts e on (e.id=l2e.p2p_to)
join wp_em_events eme on (eme.post_id=e.id)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
join wp_posts r on (r.id=e2r.p2p_to)
join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
left join wp_bhaa_raceresult rr on (r.id=rr.race and rr.runner=7713)
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','W','M') order by eme.event_start_date ASC

SELECT
2659,
rr.runner,
COUNT(rr.race) as racesComplete,
getLeaguePointsTotal(2659, rr.runner) as pointsTotal,
AVG(rr.position) as averageOverallPosition,
GROUP_CONCAT( cast( concat('[r=',r.id,':p=',IFNULL(rr.leaguepoints,0),']') AS char ) SEPARATOR ',') AS summary,
ROUND(AVG(rr.standard),0) as standard
FROM wp_posts r
LEFT JOIN wp_bhaa_raceresult rr on (r.id=rr.race and rr.runner=7713 and class in ('RAN','RACE_ORG'))
where r.id in (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
);

select p.ID,race,runner,leaguepoints,p.ID from wp_bhaa_raceresult
right join wp_posts p on p.ID=wp_bhaa_raceresult.race
where runner=7713 and p.ID in (2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855);

select p.ID,race,runner,leaguepoints,p.ID from wp_bhaa_raceresult
left join wp_posts p on p.ID IN ( 2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855)
and runner=7713;

select p.ID,race,runner,leaguepoints from wp_posts p
join wp_bhaa_raceresult on race IN ( 2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855)
and runner=7713;

-- SQL gives 11 rows
select p.ID from wp_posts p where p.ID IN (2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855);

select p.ID,IFNULL(rr.leaguepoints,0) from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=7713)
where p.ID IN (2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855)
order by p.id

select p.ID,IFNULL(rr.leaguepoints,0) from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=7713)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','W') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
order by p.id

select p.ID,IFNULL(rr.leaguepoints,0) from wp_bhaa_raceresult rr
right join wp_posts p on (p.id=rr.race and rr.runner=7713)
where p.ID IN (2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855)
order by p.id

-- summarize
select GROUP_CONCAT( cast( concat('[r=',p.ID,':p=',IFNULL(rr.leaguepoints,0),']') AS char ) SEPARATOR ',') AS summary
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=7713)
where p.ID IN (2596, 2597, 2598, 2600, 2849, 2928, 2851, 2852, 3011, 2854, 2855)
order by p.id

select GROUP_CONCAT(CAST(concat('[r=',rr.race,':p=',IFNULL(rr.leaguepoints,0),']') AS CHAR) ORDER BY eme.event_start_date SEPARATOR ',')
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=6762)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
) order by eme.event_start_date ASC

select p.ID,e2r.p2p_from,IFNULL(rr.leaguepoints,0),eme.event_start_date as points from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=6762)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
) order by eme.event_start_date ASC

update wp_bhaa_leaguesummary

inner join
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=x.leagueparticipant)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
order by p.id)
where leaguedivision in ('A','B','C','D','E','F') and league=2659;

select leagueparticipant from wp_bhaa_leaguesummary
where leaguedivision in ('A','B','C','D','E','F') and league=2659;

2666:9.7,2282:10,2285:9.9,2665:9.6,2660:9.7,2663:9.3,2278:10,2280:10,2662:9.7

2282:10,2663:9.9,2285:9.9,2662:9.7,2278:9.9,2664:9.8,2660:9.6,2280:9.9,2666:9.7

select * from wp_bhaa_leaguesummary
where league = 2806
and class="A" order by position asc

select * from wp_bhaa_leaguesummary where leagueparticipant=7713
select getRunnerLeagueSummary(7713,2659,'M');

-- team league summary
select * from wp_bhaa_leaguesummary where league=2812 and leaguetype='T' and leaguedivision='W'

select * from wp_bhaa_leaguesummary where league=2812 and leaguetype='T' and leaguedivision='M' and leagueparticipant=121
select getTeamLeagueSummary(2812,121,'M')

delete from wp_bhaa_leaguesummary where leagueparticipant=0;

SELECT *,wp_posts.post_title as display_name
FROM wp_bhaa_leaguesummary
left join wp_posts wp_posts on (wp_posts.id=wp_bhaa_leaguesummary.leagueparticipant and wp_posts.post_type="house")
WHERE league = 2806
AND leagueposition <= 10
AND leaguetype = 'T'
order by league, leaguedivision, leagueposition

SELECT * FROM wp_bhaa_leaguesummary
left join wp_posts on (wp_bhaa_leaguesummary.leagueparticipant=wp_posts.ID and wp_posts.post_type="house")
WHERE league = 2806
AND leagueposition <= 3
AND leaguetype = 'T'
order by league, leaguedivision, leagueposition

-- summer league 2013
update wp_bhaa_raceresult set standardscoringset=NULL,posinsss=NULL,leaguepoints=NULL
where race in (2595,2596,2597,2598,2600);

call updateRaceScoringSets(2595);
call updateRaceLeaguePoints(2595);
call updateRaceScoringSets(2596);
call updateRaceLeaguePoints(2596);

call updateRaceScoringSets(2597);
call updateRaceLeaguePoints(2597);

call updateRaceScoringSets(2598);
call updateRaceLeaguePoints(2598);

call updateRaceScoringSets(2600);
call updateRaceLeaguePoints(2600);

call updateLeagueData(2659);

select * from wp_bhaa_leaguesummary where leagueparticipant=7713
select * from wp_bhaa_leaguesummary where league=2659 and leaguedivision="A" order by leagueposition

select * from wp_bhaa_leaguesummary where league=2659 and leaguedivision="A" order by leagueposition

update wp_bhaa_leaguesummary set leaguesummary=NULL where leagueparticipant=7713;

select getRunnerLeagueSummary(7713,2659,'M');
update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(7713,2659,'M') where leagueparticipant=7713;

update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(leagueparticipant,2659,'M') where
league=2659 and leaguedivision in ('A','B','C','D','E','F');
update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(leagueparticipant,2659,'W') where
league=2659 and leaguedivision in ('L1','L2');

delete from wp_bhaa_leaguesummary where leagueparticipant=0;

update wp_bhaa_leaguesummary set leaguesummary =
select * fro
(select GROUP_CONCAT( cast( concat('[r=',p.ID,':p=',IFNULL(rr.leaguepoints,0),']') AS char ) SEPARATOR ',') AS summary
from wp_posts p
left join wp_bhaa_raceresult rr on (p.id=rr.race and rr.runner=wp_bhaa_leaguesummary.leagueparticipant)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2659 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
order by p.id)
where leaguedivision in ('A','B','C','D','E','F') and league=2659;

-- getTeamLeagueSummary
select * from wp_bhaa_teamresult where race>= 2170 and race<=2283 and team=159

-- get the last x team results
select race.post_title,tr.id,tr.class,tr.position,tr.leaguepoints from wp_bhaa_teamresult tr
join wp_posts race on tr.race=race.id
where team=121
group by team,race
order by race asc
limit 40;

select race.post_title,tr.class,tr.position,MAX(tr.leaguepoints) from wp_bhaa_teamresult tr
join wp_posts race on tr.race=race.id
where team=121
group by team,race
order by race asc
limit 40;

select * from wp_bhaa_leaguesummary where league=2812 and leaguedivision="M" order by leagueposition

select getTeamLeagueSummary(121,2812,'M');

-- selects too many rows
select GROUP_CONCAT(CAST(CONCAT(IFNULL( rr.leaguepoints ,0)) AS CHAR) ORDER BY eme.event_start_date SEPARATOR ',')
from wp_posts p
left join wp_bhaa_teamresult rr on (p.id=rr.race and rr.team=121)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2812 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
order by p.id

-- shows the max league points for all races in a league for RTE
select p.id,p.post_title,MAX(rr.leaguepoints) as points,IFNULL( MAX(rr.leaguepoints) ,0) as sum
from wp_posts p
left join wp_bhaa_teamresult rr on (p.id=rr.race and rr.team=121)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2812 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
group by team,race
order by p.id

-- DFB
select GROUP_CONCAT(CAST(CONCAT(IFNULL( rr.leaguepoints ,0)) AS CHAR) SEPARATOR ',')

select IFNULL(MAX(rr.leaguepoints),0) as points

select p.id,p.post_title,rr.team,MAX(rr.leaguepoints) as points,IFNULL( rr.leaguepoints ,0) as sum
from wp_posts p
left join wp_bhaa_teamresult rr on (p.id=rr.race and rr.team=159)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
where l.post_type='league'
and l.ID=2812 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK' order by eme.event_start_date ASC
)
group by rr.team,rr.race
order by p.id

select CONCAT(CAST(CONCAT(IFNULL(x.maxpoints,0)) AS CHAR) ORDER BY eme.event_start_date SEPARATOR ',')
from wp_posts p
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=p.id)
join wp_em_events eme on (eme.post_id=e2r.p2p_from)
where p.ID IN (
select r.ID as ID,MAX(rr.leaguepoints) as maxpoints from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
join wp_bhaa_teamresult rr on (r.id=rr.race and rr.team=121)
where l.post_type='league'
and l.ID=2812 and r_type.meta_value in ('C','S','M') AND r_type.meta_value!='TRACK'
group by rr.team,rr.race
order by eme.event_start_date ASC
) x
order by p.id

update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(2812,121,'M') where
league=2812 and leaguedivision in ('M');
update wp_bhaa_leaguesummary set leaguesummary=getRunnerLeagueSummary(52,2812,'W') where
league=2812 and leaguedivision in ('W');

-- delete the winter league 2013 points for the moment
delete from wp_bhaa_teamresult where race=3101;
delete from wp_bhaa_teamresult where race=3102;
delete from wp_bhaa_teamresult where race=3148;
delete from wp_bhaa_teamresult where race=3147;
delete from wp_bhaa_teamresult where race=3152;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_racedetail

-- wp_bhaa_race_detail table
DROP TABLE wp_bhaa_race_detail;
CREATE TABLE wp_bhaa_race_detail (
id int(11) auto_increment primary key,
league int(11) NULL,
leaguetype varchar(1) NULL,
event int(11) NULL,
eventname varchar(40) NULL,
eventdate date NULL,
race int(11) NULL,
racetype varchar(1) NULL,
distance varchar(4),
unit varchar(4) NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DELETE FROM wp_bhaa_race_detail;
INSERT INTO wp_bhaa_race_detail (league,leaguetype,event,eventname,eventdate,race,racetype,distance,unit)
select
l2e.p2p_from as league,
leaguetype.meta_value as leaguetype,
event.ID as event,
event.post_title as eventname,
em.event_start_date as eventdate,
race.ID as race,
racetype.meta_value as racetype,
racedistance.meta_value as distance,
raceunit.meta_value as raceunit
from wp_p2p l2e
join wp_posts event on (l2e.p2p_to=event.ID)
join wp_em_events em on (event.id=em.post_id)
join wp_p2p e2r on (l2e.p2p_to=e2r.p2p_from AND e2r.p2p_type='event_to_race')
join wp_posts race on (e2r.p2p_to=race.ID)
LEFT join wp_postmeta racetype on (race.ID=racetype.post_id AND racetype.meta_key='bhaa_race_type')
LEFT join wp_postmeta racedistance on (race.ID=racedistance.post_id AND racedistance.meta_key='bhaa_race_distance')
LEFT join wp_postmeta raceunit on (race.ID=raceunit.post_id AND raceunit.meta_key='bhaa_race_unit')
LEFT join wp_postmeta leaguetype on (l2e.p2p_from=leaguetype.post_id AND leaguetype.meta_key='bhaa_league_type')
where l2e.p2p_type='league_to_event' and l2e.p2p_from IN (3103,3615)
ORDER BY eventdate;

SELECT * FROM wp_bhaa_race_detail;
DELETE FROM wp_bhaa_race_detail;

select DISTINCT(meta_key) from wp_postmeta;
select DISTINCT(post_type) from wp_posts;
select ID,post_title from wp_posts where post_type="league";

-- 3523 the garda teams from AIB/NUI
select * from wp_bhaa_teamresult
WHERE race=3523 AND team=94
ORDER BY position,class

ALTER TABLE wp_bhaa_teamresult ADD COLUMN points DOUBLE DEFAULT NULL AFTER leaguepoints;

select race,team,teamname,MAX(leaguepoints),totalpos from wp_bhaa_teamresult
WHERE race=3523
AND team=94
GROUP BY race,team
-- ORDER BY leaguepoints desc, totalpos
limit 1;

-- http://stackoverflow.com/questions/19401155/mysql-update-max-value-with-group-by
-- http://stackoverflow.com/questions/16910050/get-row-with-highest-or-lowest-value-from-a-group-by
-- the best teams in race
select race,team,teamname,id,class,position,MAX(leaguepoints),totalpos from wp_bhaa_teamresult
WHERE race=3523
GROUP BY race,team
ORDER BY leaguepoints desc,totalpos

select * from wp_bhaa_teamresult r
inner join

-- group by race and team position, order by league points
select race,team,teamname,class,leaguepoints,position,totalpos,points from wp_bhaa_teamresult
WHERE race=3523
GROUP BY race,totalpos
ORDER BY race,team,leaguepoints desc

UPDATE wp_bhaa_teamresult oteam,
(
select i.race,i.team,i.teamname,MAX(i.leaguepoints) as bestpoints,i.totalpos,COUNT(DISTINCT(i.totalpos)) as teams from wp_bhaa_teamresult i
WHERE i.race=race
AND i.team=team
GROUP BY i.race,i.team
) best
SET oteam.points=best.bestpoints
where oteam.team=best.team
AND oteam.totalpos=best.totalpos
AND oteam.race=3523;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_raceresult

DROP TABLE IF EXISTS wp_bhaa_raceresult;
CREATE TABLE IF NOT EXISTS wp_bhaa_raceresult (
id int(11) NOT NULL AUTO_INCREMENT,
race int(11) NOT NULL,
runner int(11) NOT NULL,
racetime time,
position int(11),
racenumber int(11),
category varchar(6),
standard int(11),
actualstandard int(11),
poststandard int(11),
pace time DEFAULT NULL,
posincat int(11) DEFAULT NULL,
posinstd int(11) DEFAULT NULL,
standardscoringset int(11) DEFAULT NULL,
posinsss int(11) DEFAULT NULL,
leaguepoints double DEFAULT NULL,
class varchar(10),
company int(11),
PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

alter table wp_bhaa_raceresult add unique index(race, racenumber, class);
alter table wp_bhaa_raceresult add unique index(race, runner, class);
delete from wp_bhaa_raceresult where race=2596;
select * from wp_bhaa_raceresult where race=2596;

select COUNT() from wp_bhaa_raceresult where race=2596 and runner=7713
select COUNT() from wp_bhaa_raceresult where race=2596 and racenumber=7713

ALTER TABLE wp_bhaa_raceresult CHANGE COLUMN paceKM pace time;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN posincat int(11) DEFAULT NULL AFTER pace;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN posinstd int(11) DEFAULT NULL AFTER posincat;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN actualstandard int(11) DEFAULT NULL AFTER standard;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN poststandard int(11) DEFAULT NULL AFTER actualstandard;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN standardscoringset int(11) DEFAULT NULL AFTER poststandard;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN leaguepoints int(11) DEFAULT NULL AFTER posinstd;

-- group the league scoring set, position and points columns
ALTER TABLE wp_bhaa_raceresult MODIFY COLUMN standardscoringset int(11) DEFAULT NULL AFTER posinstd;
ALTER TABLE wp_bhaa_raceresult ADD COLUMN posinsss int(11) DEFAULT NULL AFTER standardscoringset;
ALTER TABLE wp_bhaa_raceresult MODIFY COLUMN leaguepoints double;

update wp_bhaa_raceresult set standard=NULL WHERE standard=0
update wp_bhaa_raceresult set posinsss=null,leaguepoints=null,standardscoringset=null
where race >=1783 AND runner =7713

select id,race,runner,standard,standardscoringset,gender.meta_value,posinsss,leaguepoints from wp_bhaa_raceresult
join wp_usermeta gender ON (gender.user_id=wp_bhaa_raceresult.runner AND gender.meta_key = 'bhaa_runner_gender')

and standard IS NOT NULL
where runner=7713
where race=1786
where race=2499 and standard IS NOT NULL

--1786,1787,1785,1783,1784,2358,2359,2360,2362,2505,2504
--il
call updateRaceScoringSets(1786);
call updateRaceLeaguePoints(1786);
--vf
call updateRaceScoringSets(1787);
call updateRaceLeaguePoints(1787);
--boi
call updateRaceScoringSets(1785);
call updateRaceLeaguePoints(1785);
--teachers
call updateRaceScoringSets(1783);
call updateRaceLeaguePoints(1783);
call updateRaceScoringSets(1784);
call updateRaceLeaguePoints(1784);
--sdcc
call updateRaceScoringSets(2358);
call updateRaceLeaguePoints(2358);
call updateRaceScoringSets(2359);
call updateRaceLeaguePoints(2359);
-- eircom
call updateRaceScoringSets(2360);
call updateRaceLeaguePoints(2360);
call updateRaceScoringSets(2362);
call updateRaceLeaguePoints(2362);
-- garda
call updateRaceScoringSets(2499);
call updateRaceLeaguePoints(2499);
call updateRaceScoringSets(2500);
call updateRaceLeaguePoints(2500);
--airport
call updateRaceScoringSets(2505);
call updateRaceLeaguePoints(2505);
call updateRaceScoringSets(2504);
call updateRaceLeaguePoints(2504);
--aib
call updateRaceScoringSets(2532);
call updateRaceLeaguePoints(2532);
call updateRaceScoringSets(2531);
call updateRaceLeaguePoints(2531);
--ncf
call updateRaceScoringSets(2549);
call updateRaceLeaguePoints(2549);

select * from wp_bhaa_raceresult where race=2504;
update wp_bhaa_raceresult set pace=NULL,posincat=NULL,posinstd=NULL where race=2504;
call updatePositionInStandard(2504);

-- agecategory
select distinct(category) from wp_bhaa_raceresult
update wp_bhaa_raceresult set category='Senior' where category in ('SM','SW');
update wp_bhaa_raceresult set category=SUBSTRING(category,2,2) where SUBSTRING(category,1,1) in ('M','W');
update wp_bhaa_raceresult set category='Junior' where category in ('JM','JW');
select category,SUBSTRING(category,2,2),SUBSTRING(category,1,1) from wp_bhaa_raceresult where SUBSTRING(category,1,1) in ('M','W');

-- agecategory
update wp_bhaa_raceresult set actualstandard=getStandard(racetime,getRaceDistanceKm(race)) where race=2504;

update wp_bhaa_raceresult
join bhaaie_members.agecategory
set leaguepoints=getStandard(racetime,getRaceDistanceKm(race)) where race=2504;

-- league points
select * from bhaaie_members.racepoints where runner=7713
-- pointsbyscoringset
select wp_bhaa_raceresult.runner,wp_bhaa_raceresult.race,leaguepoints,tag,wp_bhaa_import.old,pointsbyscoringset from wp_bhaa_raceresult
join wp_bhaa_import on (wp_bhaa_import.new=wp_bhaa_raceresult.race and type='race')
join bhaaie_members.racepoints on (bhaaie_members.racepoints.runner=wp_bhaa_raceresult.runner and bhaaie_members.racepoints.race=wp_bhaa_import.old)
where wp_bhaa_raceresult.runner=7713;

update wp_bhaa_raceresult set leaguepoints=10;

select * from wp_bhaa_raceresult
where race in (2358,2359,2360,2362)
and runner=7713

-- select the matching league points
select rr.race,rr.leaguepoints,mrr.points from wp_bhaa_raceresult rr
join wp_bhaa_import i on (i.type='race' and i.new=rr.race)
join bhaaie_members.raceresult mrr on (mrr.race=i.old and mrr.runner=rr.runner)
and rr.race>=1783
and rr.runner=7713;

update wp_bhaa_raceresult rr
join wp_bhaa_import i on (i.type='race' and i.new=rr.race)
join bhaaie_members.raceresult mrr on (mrr.race=i.old and mrr.runner=rr.runner)
set rr.leaguepoints=mrr.points
where rr.race>=1783
and rr.runner=7713;

select
id,
team,
league,
(select new from wp_bhaa_import where type='race' and old=race) as race,
standardtotal,
positiontotal,
class,
leaguepoints,
status
from bhaaie_members.teamraceresult where race=201282

-- select all the runners race league points!
select l.ID as lid,l.post_title,
e.ID as eid,e.post_title as etitle,eme.event_start_date as edate,
r.ID as rid,r.post_title as rtitle,r_type.meta_value as rtype,
rr.leaguepoints
from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
left join wp_bhaa_raceresult rr on (rr.race=r.id and rr.runner=7713)
where l.post_type='league'
and l.ID=2492;

-- select all race results linked to an event
select wp_bhaa_raceresult.* from wp_p2p e2r
left join wp_bhaa_raceresult on (wp_bhaa_raceresult.race=e2r.p2p_to and e2r.p2p_type='event_to_race')
where e2r.p2p_from=2278

select * from wp_p2p where p2p_type='event_to_race' and p2p_from=2278

-- select racetec RACE_REG details
SELECT wp_bhaa_raceresult.id,runner,racenumber,race,
firstname.meta_value as firstname,lastname.meta_value as lastname,
gender.meta_value as gender,dateofbirth.meta_value as dateofbirth,
status.meta_value as status,standard,
house.id as company,
CASE WHEN house.post_title IS NULL THEN companyname.post_title ELSE house.post_title END as companyname,
CASE WHEN sector.id IS NOT NULL THEN sector.id ELSE house.id END as teamid,
CASE WHEN sector.post_title IS NOT NULL THEN sector.post_title ELSE house.post_title END as teamname
from wp_bhaa_raceresult
JOIN wp_p2p e2r ON (wp_bhaa_raceresult.race=e2r.p2p_to AND e2r.p2p_type="event_to_race")
JOIN wp_users on (wp_users.id=wp_bhaa_raceresult.runner)
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_posts house on (house.id=r2c.p2p_from and house.post_type='house')
left join wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = 'sectorteam_to_runner')
left join wp_posts sector on (sector.id=r2s.p2p_from and house.post_type='house')
left join wp_usermeta firstname ON (firstname.user_id=wp_users.id AND firstname.meta_key = 'first_name')
left join wp_usermeta lastname ON (lastname.user_id=wp_users.id AND lastname.meta_key = 'last_name')
left join wp_usermeta gender ON (gender.user_id=wp_users.id AND gender.meta_key = 'bhaa_runner_gender')
left join wp_usermeta dateofbirth ON (dateofbirth.user_id=wp_users.id AND dateofbirth.meta_key = 'bhaa_runner_dateofbirth')
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
left join wp_posts companyname on (companyname.id=company.meta_value and companyname.post_type='house')
where wp_bhaa_raceresult.class="PRE_REG"
AND e2r.p2p_from=2282 order by wp_bhaa_raceresult.id desc limit 3

--left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')

left join wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key = 'bhaa_runner_company')
join wp_posts house on (house.id=company.meta_value and house.post_type='house')
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')

-- actual standard and pace

select runner,position,racetime,
SEC_TO_TIME(TIME_TO_SEC(racetime)/5.2) as pace,
getStandard(racetime,getRaceDistanceKm(race)) as actualstandard
from wp_bhaa_raceresult
where race=2549

update wp_bhaa_raceresult set pace=SEC_TO_TIME(TIME_TO_SEC(racetime)/5.2),actualstandard=getStandard(racetime,getRaceDistanceKm(race)) where race=2549

-- list all race results for a specific league
SELECT e.id,
CASE rr.leaguepoints WHEN 11 THEN 10 ELSE rr.leaguepoints END AS points
FROM wp_bhaa_raceresult rr
join wp_posts r ON rr.race = r.id
right join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.ID)
join wp_posts e ON e2r.p2p_from = e.id
right join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_to=e.ID)
JOIN wp_posts le ON l2e.p2p_from = le.id
WHERE runner=7713 AND le.id=2492

-- select a points results for all events regardless of a raceresult
select
e.ID as eid,e.post_title as etitle,eme.event_start_date as edate,
r.ID as rid,r.post_title as rtitle,r_type.meta_value as rtype,
CASE rr.leaguepoints WHEN 11 THEN 10 ELSE rr.leaguepoints END AS points,
rr.class,rr.standard
from wp_posts l
inner join wp_p2p l2e on (l2e.p2p_type='league_to_event' and l2e.p2p_from=l.ID)
inner join wp_posts e on (e.id=l2e.p2p_to)
inner join wp_em_events eme on (eme.post_id=e.id)
inner join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=e.ID)
inner join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
left join wp_bhaa_raceresult rr on (rr.race=r.id and rr.runner=7713)
where l.post_type='league'
and l.ID=2492
and r_type.meta_value in ('C','M')

-- insert pre-register runners into the race
select * from wp_em_bookings where event_id=113

insert into wp_bhaa_raceresult(race,runner,class)
select 2598,person_id,'PRE_REG'
from wp_em_bookings
join wp_users on wp_users.id=wp_em_bookings.person_id
where event_id=113
and booking_status=1
order by display_name desc

select 2598,person_id,display_name,'PRE_REG'
from wp_em_bookings
join wp_users on wp_users.id=wp_em_bookings.person_id
where event_id=113
order by display_name desc

select * from wp_bhaa_raceresult where class="RACE_REG" and race=2598
select * from wp_bhaa_raceresult where class="PRE_REG" and race=2598
delete from wp_bhaa_raceresult where class="PRE_REG" and race=2598

-- race entry stat's
select count(runner) as total,
(select count(runner) from wp_bhaa_raceresult where gender="M") as male,
(select count(runner) from wp_bhaa_raceresult where gender="W") as female
from wp_bhaa_raceresult
where race=2598

explain
select count(id) from wp_bhaa_raceresult where race=2598 and runner=7713
explain
select count(id) from wp_bhaa_raceresult where race=2598 and runner=7713 and class="RACE_REG"
explain
select exists(select * from wp_bhaa_raceresult where race=2598 and runner=7713);
select exists(select * from wp_bhaa_raceresult where race=2598 and runner=7713);

-- indexes and class alter
ALTER TABLE wp_bhaa_raceresult ADD INDEX index_race_runner (race,runner);
ALTER TABLE wp_bhaa_raceresult ADD INDEX index_race_number (race,racenumber);
ALTER TABLE wp_bhaa_raceresult ADD INDEX index_race_number_class (race,racenumber,class);
ALTER TABLE wp_bhaa_raceresult CHANGE class class VARCHAR(10) NOT NULL;

-- find raceresult without a runner
select * from wp_bhaa_raceresult
left join wp_users on wp_users.id=runner
where wp_users.id is null;

-- find runners who ran with no standard
select * from wp_bhaa_raceresult
left join wp_users on wp_users.id=runner
left join wp_usermeta on (wp_users.id=wp_usermeta.user_id and wp_usermeta.meta_key='bhaa_runner_standard')
GROUP BY user_id
HAVING count(wp_usermeta.umeta_id) = 0;

-- give break down of registered runners
select standardscoringset as type, count(*) as count
from wp_bhaa_raceresult
where race=2849
and class="RACE_REG"
group by standardscoringset;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_teamresult

-- wp_bhaa_teamresult

--Pos,RaceName,EventDescr,TeamType,Team Pos,TeamTypeId,TeamId,TempTeamId,Team Total,Team Name,Team Std,RaceNo,Name,Gender,Company,Overall Pos,Finish Time,Std,Class,Team No,Company No,RaceId,EventId
--1,BHAA NCF 5km Night XC 2013,5.2km,BHAA,1,1,26,2,17,Swords Labs,21,1782,Chris Muldoon,Male,Swords Labs,2,00:18:35,6,A,204,204,47,1
--4,BHAA NCF 5km Night XC 2013,5.2km,BHAA,8,1,1,2,160,RTE,39,1809,Terry Clarke,Male,Rte,33,00:22:07,11,B,121,121,47,1

DROP TABLE IF EXISTS wp_bhaa_teamresult;
CREATE TABLE IF NOT EXISTS wp_bhaa_teamresult (
id int(11) NOT NULL AUTO_INCREMENT,
race int(11) NOT NULL,
class varchar(1) NOT NULL,
position int(11) NOT NULL,
team int(11) NOT NULL,
teamname varchar(20),
totalpos int(11) NOT NULL,
totalstd int(11) NOT NULL,
runner int(11) NOT NULL,
pos int(11) NOT NULL,
std int(11) NOT NULL,
racetime time,
company int(11),
companyname varchar(20),
leaguepoints double(11) NOT NULL,
PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE wp_bhaa_teamresult MODIFY COLUMN leaguepoints double;

select * from wp_bhaa_teamresult
where race=2598
and class="A" order by position asc

select * from wp_bhaa_teamresult where team=0;
delete from wp_bhaa_teamresult where team=0;

-- update the team league points
update wp_bhaa_teamresult set leaguepoints=(7-(position))
update wp_bhaa_teamresult set leaguepoints=1 where leaguepoints<=0

-- 2811
SELECT
t1.league,
t1.leaguetype,
t1.leagueparticipant,
t1.leaguestandard as leaguestandard,
'W' AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.previousleagueposition,
t1.leaguescorecount,
t1.leaguepoints - (SELECT count(1) FROM wp_bhaa_teamresult where team = t1.leagueparticipant and class='OW') as leaguepoints,
t1.leaguesummary AS leaguesummary
FROM
(
SELECT
2811 AS league,
'T' AS leaguetype,
l.team AS leagueparticipant,
0 AS leaguestandard,
0 AS leaguedivision,
0 AS previousleagueposition,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints,
GROUP_CONCAT( cast( concat(l.event,':',l.leaguepoints) AS char ) SEPARATOR ',') AS leaguesummary
FROM
(
SELECT 1 AS leaguescorecount, team, race, MAX(leaguepoints) AS leaguepoints, e2r.p2p_from as event
FROM wp_bhaa_teamresult trr
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=trr.race)
WHERE class in ('W','OW')
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;

-- mens team league
SELECT
t1.league,
t1.leaguetype,
t1.leagueparticipant,
t1.leaguestandard as leaguestandard,
'M' AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.leaguescorecount,
t1.leaguepoints - (SELECT count(1) FROM wp_bhaa_teamresult where team = t1.leagueparticipant and class='O') as leaguepoints,
t1.leaguesummary AS leaguesummary
FROM
(
SELECT
2811 AS league,
'T' AS leaguetype,
l.team AS leagueparticipant,
0 AS leaguestandard,
0 AS leaguedivision,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints,
GROUP_CONCAT( cast( concat(l.event,':',l.leaguepoints) AS char ) SEPARATOR ',') AS leaguesummary
FROM
(
SELECT 1 AS leaguescorecount, team, race, MAX(leaguepoints) AS leaguepoints, e2r.p2p_from as event
FROM wp_bhaa_teamresult trr
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=race)
WHERE class <> 'W' and class <> 'OW'
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;

-- migrate old team results
select * from wp_bhaa_teamresult where race=2596
select * from teamraceresult where race=201073

-- http://stackoverflow.com/questions/13944417/mysql-convert-column-to-row-pivot-table
select
1 as id,
race,
class,
leaguepoints as position,
team,
"teamname" as teamname,
positiontotal as totalpos,
standardtotal as totalstd,
runnerfirst as runner,
leaguepoints
from teamraceresult where race=201073
UNION
select
2 as id,
race,
class,
leaguepoints as position,
team,
"teamname" as teamname,
positiontotal as totalpos,
standardtotal as totalstd,
runnersecond as runner,
leaguepoints
from teamraceresult where race=201073
UNION
select
3 as id,
race,
class,
leaguepoints as position,
team,
"teamname" as teamname,
positiontotal as totalpos,
standardtotal as totalstd,
runnerthird as runner,
leaguepoints
from teamraceresult
where race=201073
order by class, leaguepoints desc, id

select the appropriate columns and then each runner in 3 unioned queries
select x,y, runner first as runner
union
select x,y, runnersecond as runner
union
select x,y, runnerthird as runner
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_teamsummary

-- wp_bhaa_teamsummary
DROP TABLE wp_bhaa_teamsummary;
CREATE TABLE wp_bhaa_teamsummary (
race int(11) NOT NULL,
team int(11) NOT NULL,
teamname varchar(20),
totalstd int(11) NOT NULL,
position int(11) NOT NULL,
leaguepoints double NOT NULL,
PRIMARY KEY (race, team) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE wp_bhaa_teamsummary ADD COLUMN class varchar(1) DEFAULT NULL AFTER totalstd;
ALTER TABLE wp_bhaa_teamsummary ADD COLUMN totalpos int(11) DEFAULT NULL AFTER totalstd;

DELETE FROM wp_bhaa_teamsummary
-- update the team summary table
INSERT INTO wp_bhaa_teamsummary
SELECT
race,
team,
teamname,
min(totalstd) as totalstd,
min(totalpos) as totalpos,
class,
min(position)as position,
max(leaguepoints) as leaguepoints
FROM wp_bhaa_teamresult
WHERE position!=0
GROUP BY race,team
ORDER BY class,position;

SELECT * FROM wp_bhaa_teamsummary;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_bhaa_em

-- event manager SQL
-- annual membership 103, dcc 111,

select * from wp_em_events where event_id=112

-- annual membership bookings
select * from wp_em_bookings where event_id=103

select booking_id,person_id,display_name,status.meta_value from wp_em_bookings
join wp_users on wp_users.id=person_id
join wp_usermeta status on (wp_em_bookings.person_id=status.user_id and status.meta_key='bhaa_runner_status')
where event_id=103 and status.meta_value != 'M'

update wp_usermeta
join wp_em_bookings on (wp_em_bookings.person_id=wp_usermeta.user_id and wp_em_bookings.booking_status=1 and wp_em_bookings.event_id=103)
set meta_value="M"
where wp_usermeta.meta_key='bhaa_runner_status';

-- find all event books
select * from wp_em_bookings where event_id=113
and person_id=23269

select booking_id,person_id,display_name,status.meta_value from wp_em_bookings
join wp_users on wp_users.id=person_id
left join wp_usermeta status on (wp_em_bookings.person_id=status.user_id and status.meta_key='bhaa_runner_status')
where event_id=113
and (status.meta_value IS NULL or status.meta_value = '')

insert into wp_usermeta (user_id, meta_key, meta_value) VALUE (23019,'bhaa_runner_status','D');
-- where person_id in (23019,23289,23290,23301,23316,23327)
select * from wp_usermeta where user_id=23019;

-- find runner who paid annual but there status is not up to date
select status.meta_value,wp_em_bookings.* from wp_em_bookings
left join wp_usermeta status on (wp_em_bookings.person_id=status.user_id and status.meta_key='bhaa_runner_status')
where event_id=103 and booking_status=1

select status.,wp_em_bookings. from wp_em_bookings
left join wp_usermeta status on (wp_em_bookings.person_id=status.user_id and status.meta_key='bhaa_runner_status')
where event_id=112
and booking_price=15.00

--wp_em_bookings.booking_status=1 and
insert into wp_usermeta (user_id, meta_key, meta_value)
select wp_em_bookings.person_id,'bhaa_runner_status','D' from wp_em_bookings
where wp_em_bookings.event_id=113 and wp_em_bookings.booking_price=15.00;

select wp_em_bookings.person_id from wp_em_bookings
join wp_users on wp_users.id=wp_em_bookings.person_id
join wp_usermeta fn on (wp_em_bookings.person_id=fn.user_id and fn.meta_key='first_name')
join wp_usermeta ln on (wp_em_bookings.person_id=ln.user_id and ln.meta_key='last_name')
where wp_em_bookings.event_id=113
and fn.meta_value="Peter" and ln.meta_value="xMooney";

update wp_usermeta
join wp_em_bookings on (wp_em_bookings.person_id=wp_usermeta.user_id and wp_em_bookings.booking_status=1)
set meta_value="M"
where wp_usermeta.meta_key='bhaa_runner_status'
and wp_usermeta.meta_value IS NULL
and booking_price=10.00
and event_id=112;

UPDATE wp_usermeta SET meta_value="D" where meta_key="bhaa_runner_status" and user_id>=23051 and user_id<=23199;
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_em_events

-- get next event
select event_id,post_id,event_slug from wp_em_events
where event_start_date >= NOW()
order by event_start_date ASC limit 1;

-- get the next events race details
select e.event_id,e.post_id,e.event_slug,r.id,
r_dist.meta_value as dist,r_type.meta_value as type,r_unit.meta_value as unit
from wp_em_events e
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e.post_id=e2r.p2p_from)
join wp_posts r on (r.id=e2r.p2p_to)
inner join wp_postmeta r_dist on (r_dist.post_id=r.id and r_dist.meta_key='bhaa_race_distance')
inner join wp_postmeta r_type on (r_type.post_id=r.id and r_type.meta_key='bhaa_race_type')
inner join wp_postmeta r_unit on (r_unit.post_id=r.id and r_unit.meta_key='bhaa_race_unit')
where event_start_date >= NOW()
order by event_start_date ASC, dist DESC limit 2;

-- get last event
select *,wp_postmeta.meta_value as tag from wp_em_events
left join wp_postmeta on (wp_postmeta.post_id=wp_em_events.post_id and wp_postmeta.meta_key='bhaa_event_tag')
where event_start_date <= NOW()
order by event_start_date DESC limit 1;

select event_id,post_id,event_slug,
(select MAX(p2p_to) from wp_p2p where p2p_from=post_id) as race
from wp_em_events
where event_start_date >= DATE(NOW())
order by event_start_date ASC limit 1;

select * from wp_p2p where p2p_from=2663

select * from wp_bhaa_raceresult
join wp_posts r on (r.id=wp_bhaa_raceresult.race)
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_to=r.id)
where class="RACE_REG" and e2r.p2p_from=2278

-- tidy up
update wp_em_events
set event_start_date = '2013-01-01'
where event_id=103;
delete from wp_em_events where event_id=3;

-- select the 2013 events
select event_slug,e2r.p2p_to from wp_em_events
join wp_p2p e2r on (e2r.p2p_type='event_to_race' and e2r.p2p_from=post_id)
where event_id>=104;

select * from wp_posts where post_type="event"
select event.id,name,tag,
(select count(distinct(rr.runner)) from raceresult rr join race on rr.race=race.id where race.event=event.id and rr.class="RAN") as total,
(select count(distinct(rr.runner)) from raceresult rr join race on rr.race=race.id join runner on runner.id=rr.runner where race.event=event.id and runner.gender="M" and rr.class="RAN") as male,
(select count(distinct(rr.runner)) from raceresult rr join race on rr.race=race.id join runner on runner.id=rr.runner where race.event=event.id and runner.gender="W" and rr.class="RAN") as female,
(select count(distinct(rr.runner)) from raceresult rr join race on rr.race=race.id join runner on runner.id=rr.runner where race.event=event.id and runner.status="M" and rr.class="RAN") as bhaa,
(select count(distinct(rr.runner)) from raceresult rr join race on rr.race=race.id join runner on runner.id=rr.runner where race.event=event.id and runner.status="D" and rr.class="RAN") as day,
(select count(trr.team) from teamraceresult trr join race on trr.race=race.id where race.event=event.id and trr.class in ('A','B','C','D','W')) as teams
@emeraldjava
Owner Author
emeraldjava commented on Jul 28, 2017
wp_users

-- select distinct gender values
select distinct(gender.meta_value) from wp_users u
join wp_usermeta gender on (gender.user_id=u.id AND gender.meta_key = 'bhaa_runner_gender');

M - 6000
W - 2765
a:1:{i:0;s:1:"M";} - 20

    14
    a:1:{i:0;s:1:"W";} - 3
    a:2:{i:0;s:1:"M";i:1;s:1:"M";} - 1
    F - 10

select count(id) from wp_users u
join wp_usermeta gender on (gender.user_id=u.id AND gender.meta_key = 'bhaa_runner_gender')
where gender.meta_value='F';

update wp_usermeta set meta_value='W' where meta_key = 'bhaa_runner_gender' and meta_value='F';
update wp_usermeta set meta_value='W' where meta_key = 'bhaa_runner_gender' and meta_value='a:1:{i:0;s:1:"W";}';
update wp_usermeta set meta_value='M' where meta_key = 'bhaa_runner_gender' and meta_value='';
update wp_usermeta set meta_value='M' where meta_key = 'bhaa_runner_gender' and meta_value='a:1:{i:0;s:1:"M";}';
update wp_usermeta set meta_value='M' where meta_key = 'bhaa_runner_gender' and meta_value='a:2:{i:0;s:1:"M";i:1;s:1:"M";}';

-- dor dates 2013
select distinct(dor.meta_value) from wp_users u
join wp_usermeta dor on (dor.user_id=u.id AND dor.meta_key = 'bhaa_runner_dateofrenewal')
where YEAR(dor.meta_value)=2013 order by dor.meta_value desc;

-- select wp renewed but not upated in members
select wp_users.user_nicename,wp_users.id,status.meta_value,dor.meta_value,runner.id,runner.status,runner.dateofrenewal from wp_users
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
join bhaaie_members.runner runner on runner.id=wp_users.id
where runner.status!='M' and YEAR(dor.meta_value)=2013;

-- select wp users who are behind the members db
select wp_users.user_nicename,wp_users.id,status.meta_value,dor.meta_value,runner.id,runner.status,runner.dateofrenewal from wp_users
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
join bhaaie_members.runner runner on runner.id=wp_users.id
where runner.status='M' and status.meta_value='I';
and runner.id=6028

update wp_users
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
join bhaaie_members.runner runner on runner.id=wp_users.id
set
status.meta_value=runner.status,
dor.meta_value=runner.dateofrenewal
where runner.status='M' and YEAR(runner.dateofrenewal)=2013;

-- handle new wp user not in the members db
select user_nicename,id,user_registered from wp_users where YEAR(user_registered)=2013;

-- list the two max id's
select MAX(id) from wp_users;
select MAX(id) from bhaaie_members.runner;

INSERT INTO bhaaie_members.runner(id,firstname,surname,gender,dateofbirth,company,email,mobilephone,status,insertdate,dateofrenewal)
select wp_users.id,mfn.meta_value,mln.meta_value,mg.meta_value,mdob.meta_value,mc.meta_value,wp_users.user_email,mp.meta_value,ms.meta_value,mdor.meta_value,mdor.meta_value from wp_users
join wp_usermeta ms on (
ms.user_id=wp_users.id and
ms.meta_key='bhaa_runner_status')
join wp_usermeta mfn on (
mfn.user_id=wp_users.id and
mfn.meta_key='first_name')
join wp_usermeta mln on (
mln.user_id=wp_users.id and
mln.meta_key='last_name')
join wp_usermeta mg on (
mg.user_id=wp_users.id and
mg.meta_key='bhaa_runner_gender')
join wp_usermeta mdob on (
mdob.user_id=wp_users.id and
mdob.meta_key='bhaa_runner_dateofbirth')
left join wp_usermeta mc on (
mc.user_id=wp_users.id and
mc.meta_key='bhaa_runner_company')
join wp_usermeta mp on (
mp.user_id=wp_users.id and
mp.meta_key='bhaa_runner_mobilephone')
join wp_usermeta mdor on (
mdor.user_id=wp_users.id and
mdor.meta_key='bhaa_runner_dateofrenewal')
where id>=22965
order by wp_users.id;

-- match runners with missing standards runner/raceresult
select * from wp_users
join wp_bhaa_raceresult on (wp_bhaa_raceresult.runner=wp_users.id and wp_bhaa_raceresult.class="RAN")
inner join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
inner join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key='bhaa_runner_standard')
where standard.meta_value=0 or standard.meta_value IS NULL

select * from wp_users
inner join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
WHERE NOT EXISTS (
SELECT * FROM wp_usermeta standard WHERE standard.user_id=wp_users.id and standard.meta_key='bhaa_runner_standard'
)

-- validate the wp_users status and dor
select u.id,u.user_nicename,dor.meta_value,status.meta_value from wp_users u
left join wp_usermeta dor on (dor.user_id=u.id AND dor.meta_key = 'bhaa_runner_dateofrenewal')
left join wp_usermeta status on (status.user_id=u.id AND status.meta_key = 'bhaa_runner_status')
where YEAR(dor.meta_value)!=2013 and status.meta_value='I' and u.id=5143;

-- 5143
update wp_usermeta
join wp_users on wp_users.id=wp_usermeta.user_id
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
set status.meta_value='I'
where YEAR(dor.meta_value)!=2013;

-- fix the usernames 22935,22821,22966 - 85 mismatched names
select id,display_name,first_name.meta_value,last_name.meta_value from wp_users
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
where id>1 and display_name!=CONCAT(first_name.meta_value,' ',last_name.meta_value);
YEAR(user_registered)=2013 and

update wp_users
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
set display_name=CONCAT(first_name.meta_value,' ',last_name.meta_value)
where id>1 and display_name!=CONCAT(first_name.meta_value,' ',last_name.meta_value);
--YEAR(user_registered)=2013 and

-- registration autocomplete query
select wp_users.id as id,wp_users.id as value,
wp_users.display_name as label,
first_name.meta_value as firstname,
last_name.meta_value as lastname,
status.meta_value as status,
gender.meta_value as gender,
dob.meta_value as dob,
company.meta_value as company,
standard.meta_value as standard
from wp_users
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key='bhaa_runner_dateofbirth')
left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key='bhaa_runner_company')
left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key='bhaa_runner_standard')
where status.meta_value in ('M') order by id

-- list members with company and team details
select wp_users.id as id,
first_name.meta_value as firstname,
last_name.meta_value as lastname,
gender.meta_value as gender,
standard.meta_value as standard,
dob.meta_value as dob,
CASE WHEN house.post_title IS NULL THEN companyname.post_title ELSE house.post_title END as companyname
from wp_users
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key='bhaa_runner_dateofbirth')
left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key='bhaa_runner_company')
left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key='bhaa_runner_standard')
left join wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = 'house_to_runner')
left join wp_posts house on (house.id=r2c.p2p_from and house.post_type='house')
left join wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = 'sectorteam_to_runner')
left join wp_posts sector on (sector.id=r2s.p2p_from and house.post_type='house')
left join wp_posts companyname on (companyname.id=company.meta_value and companyname.post_type='house')
where status.meta_value in ('M') order by id

select wp_users.user_nicename,wp_users.id,status.meta_value as s,dor.meta_value as dor,runner.id,runner.status,runner.dateofrenewal from wp_users
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
join bhaaie_members.runner runner on runner.id=wp_users.id
where runner.status='M' and YEAR(dateofrenewal)=2013
and status.meta_value = ''
and runner.id=8991

-- insert status meta data
insert into wp_usermeta (user_id, meta_key, meta_value)
SELECT wp_users.id,'bhaa_runner_status',runner.status from wp_users
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
join bhaaie_members.runner runner on runner.id=wp_users.id
where runner.status='M' and YEAR(dateofrenewal)=2013
and status.meta_value = ''

insert into wp_usermeta (user_id, meta_key, meta_value)
SELECT wp_users.id,'bhaa_runner_dateofrenewal',runner.dateofrenewal from wp_users
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
join bhaaie_members.runner runner on runner.id=wp_users.id
where runner.status='M' and YEAR(dateofrenewal)=2013
and dor.meta_value = ''

-- fix runners with status M and year 2012!
select wp_users.id,wp_users.display_name,status.meta_value,dor.meta_value from wp_users
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
left join wp_usermeta dor ON (dor.user_id=wp_users.id AND dor.meta_key = 'bhaa_runner_dateofrenewal')
where status.meta_value='M' and dor.meta_value<='2012-09-30';

-- disable 853 rows
update wp_usermeta
join wp_users on wp_users.id=wp_usermeta.user_id
join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status' and status.meta_value='M')
join wp_usermeta dor on (dor.user_id=wp_users.id and dor.meta_key='bhaa_runner_dateofrenewal')
set status.meta_value='I'
where dor.meta_value<='2012-09-30';

-- select distinct day members 3970
select wp_users.id as id,wp_users.id as value,
wp_users.display_name as label,
first_name.meta_value as firstname,
last_name.meta_value as lastname,
status.meta_value as status,
gender.meta_value as gender,
dob.meta_value as dob,
company.meta_value as company,
standard.meta_value as standard
from wp_users
left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key='bhaa_runner_dateofbirth')
left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key='bhaa_runner_company')
left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key='bhaa_runner_standard')
where status.meta_value in ('D') order by id;

-- validate date of births -- wp_users.id,wp_users.display_name,status.meta_value,dor.meta_value
select distinct(dob.meta_value) from wp_users
left join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
left join wp_usermeta dob ON (dob.user_id=wp_users.id AND dob.meta_key = 'bhaa_runner_dateofbirth')
where status.meta_value='M' and dob.meta_value='01/12/1982'
-- fix 2013-11-13,01/12/1982,07/12/1982,2023-07-13
-- 5143,6241,22226
update wp_usermeta set meta_value='1982-12-01' where meta_value='01/12/1982';
update wp_usermeta set meta_value='1982-12-07' where meta_value='07/12/1982';
update wp_usermeta set meta_value='1993-11-13' where meta_value='2013-11-13';
update wp_usermeta set meta_value='1993-07-13' where meta_value='2023-07-13';

select count(ID) from wp_users;

-- match missing bhaa_runner_status meta
select wp_users.id,runner.id,
CASE WHEN runner.status IS NULL THEN 'D' ELSE runner.status END as status,
CASE WHEN dor.meta_value IS NULL THEN '1990-01-01' ELSE dor.meta_value END as dor
from wp_users
left join bhaaie_members.runner runner on runner.id=wp_users.id
left join wp_usermeta dor on (dor.meta_key='bhaa_runner_dateofrenewal' and dor.user_id=wp_users.id)
where NOT EXISTS (select meta_value from wp_usermeta where meta_key='bhaa_runner_standard' and user_id=wp_users.id)
--left join wp_usermeta dob on (dob.meta_key='bhaa_runner_dateofbirth' and dob.user_id=wp_users.id)

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT wp_users.id,'bhaa_runner_dateofrenewal',
CASE WHEN dor.meta_value IS NULL THEN '1990-01-01' ELSE dor.meta_value END from wp_users
left join bhaaie_members.runner runner on runner.id=wp_users.id
left join wp_usermeta dor on (dor.meta_key='bhaa_runner_dateofrenewal' and dor.user_id=wp_users.id)
where NOT EXISTS (select meta_value from wp_usermeta where meta_key='bhaa_runner_standard' and user_id=wp_users.id)

insert into wp_usermeta(user_id, meta_key, meta_value)
SELECT wp_users.id,'bhaa_runner_status',
CASE WHEN runner.status IS NULL THEN 'D' ELSE runner.status END from wp_users
left join bhaaie_members.runner runner on runner.id=wp_users.id
where NOT EXISTS (select meta_value from wp_usermeta where meta_key='bhaa_runner_standard' and user_id=wp_users.id)

-- mail chimp email
select fn.meta_value,ln.meta_value,user_email from wp_users
join wp_usermeta fn ON (fn.user_id=wp_users.id AND fn.meta_key = 'first_name')
join wp_usermeta ln ON (ln.user_id=wp_users.id AND ln.meta_key = 'last_name')
join wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key = 'bhaa_runner_status')
where wp_users.id>=10000 and status.meta_value!="M" and user_email IS NOT NULL and user_email != ''
order by id desc limit 600

select * FROM wp_usermeta
WHERE umeta_id NOT IN (
SELECT MIN(umeta_id)
FROM wp_usermeta where wp_usermeta.meta_key='bhaa_runner_status'
GROUP BY user_id, meta_key, meta_value
)

SELECT * FROM wp_usermeta where wp_usermeta.meta_key='bhaa_runner_status' and wp_usermeta.user_id=23265

SELECT count(umeta_id) FROM wp_usermeta where wp_usermeta.meta_key='bhaa_runner_status';
SELECT count(umeta_id), count(distinct(user_id)) FROM wp_usermeta where wp_usermeta.meta_key='bhaa_runner_status';

delete from wp_users where id=23534
select * from wp_users where id=23534
select count(id) as isrunner from wp_users where id=23527
select count(id) from wp_users where id=7713
select count(id) from wp_users where id=0

-- orphaned runners
select r.id,r.display_name
from wp_users r
left join wp_bhaa_raceresult rr on r.id=rr.runner
join wp_usermeta status ON (status.user_id=r.id AND status.meta_key = 'bhaa_runner_status')
where status.meta_value='d' and rr.runner is null;

delete r
from wp_users r
left join wp_bhaa_raceresult rr on r.id=rr.runner
join wp_usermeta status ON (status.user_id=r.id AND status.meta_key = 'bhaa_runner_status')
where status.meta_value='d' and rr.runner is null;

-- fix duplicate status details
SELECT user_id, count(umeta_id) as Total
FROM wp_usermeta
WHERE wp_usermeta.meta_key='bhaa_runner_status'
GROUP BY user_id
HAVING count(umeta_id) > 1 limit 100;

SELECT user_id,
MIN(umeta_id),
MAX(umeta_id)
FROM wp_usermeta
WHERE wp_usermeta.meta_key='bhaa_runner_status'
GROUP BY user_id
HAVING count(umeta_id) > 1 limit 10;

CREATE TABLE IF NOT EXISTS tmp_status(
user_id int,
umeta_min int,
umeta_max int,
umeta_min_val VARCHAR(1),
umeta_max_val VARCHAR(1)
);

INSERT INTO tmp_status
SELECT user_id, MIN(umeta_id), MAX(umeta_id),NULL,NULL
FROM wp_usermeta
WHERE wp_usermeta.meta_key='bhaa_runner_status'
GROUP BY user_id
HAVING count(umeta_id) > 1;

select * from tmp_status;
-- update the values
update tmp_status set umeta_min_val=(select meta_value from wp_usermeta where umeta_id=umeta_min);
update tmp_status set umeta_max_val=(select meta_value from wp_usermeta where umeta_id=umeta_max);

-- check for equal and delete the max
select * from tmp_status where umeta_min_val=umeta_max_val;
select * from tmp_status where umeta_min_val!=umeta_max_val;

delete wp_usermeta from wp_usermeta
join tmp_status on tmp_status.umeta_max=umeta_id;
order by umeta_max desc;
delete from tmp_status
order by umeta_max desc;
select * from tmp_status;

DROP TABLE tmp_status;

-- match duplicate runners
-- http://wordpress.stackexchange.com/questions/27846/list-all-authors-by-matching-custom-meta-data-on-a-category-page
select * from wp_users where ID IN (12364,8450);

select * from wp_users WHERE 1=1 AND ( (wp_usermeta.meta_key = 'last_name'
AND CAST(wp_usermeta.meta_value AS CHAR) = 'Paul')
AND (mt1.meta_key = 'first_name'
AND CAST(mt1.meta_value AS CHAR) = 'Paul')
AND (mt2.meta_key = 'id' AND CAST(mt2.meta_value AS CHAR) != '1') )

select * from wp_users where SOUNDEX(display_name) LIKE SOUNDEX('%dave carroll%');

?id=12364
http://bhaa.ie/runner/?id=8450

-- find runner who ran with missing standard

SELECT SQL_CALC_FOUND_ROWS rr.races,wp_users.* FROM wp_users
INNER JOIN wp_usermeta ON (wp_users.ID = wp_usermeta.user_id)
LEFT JOIN wp_usermeta AS mt1 ON (wp_users.ID = mt1.user_id AND mt1.meta_key = 'bhaa_runner_standard')
left outer join (
SELECT runner, COUNT(race) as races
FROM wp_bhaa_raceresult
GROUP BY runner) rr on (wp_users.ID = rr.runner)
WHERE ( (wp_usermeta.meta_key = 'bhaa_runner_status' AND CAST(wp_usermeta.meta_value AS CHAR) = 'M')
AND mt1.user_id IS NULL ) AND races>=1
ORDER BY races DESC, ID ASC;

select id from wp_users
JOIN wp_usermeta AS status ON (wp_users.ID = status.user_id AND status.meta_key = 'bhaa_runner_status')
JOIN wp_usermeta AS standard ON (wp_users.ID = standard.user_id AND standard.meta_key = 'bhaa_runner_standard')
where status.meta_value='M' and standard.meta_value=30;

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

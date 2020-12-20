-- bhaaie_wp 6599
select
l2e.p2p_from as league,
leaguetype.meta_value as leaguetype,
event.ID as event,
event.post_title as eventname,
event.post_date as eventdate,
race.ID as race,
racetype.meta_value as racetype,
racedistance.meta_value as distance,
raceunit.meta_value as raceunit
from wp_p2p l2e
join wp_posts event on (l2e.p2p_to=event.ID)
join wp_p2p e2r on (l2e.p2p_to=e2r.p2p_from AND e2r.p2p_type="event_to_race")
join wp_posts race on (e2r.p2p_to=race.ID)
LEFT join wp_postmeta racetype on (race.ID=racetype.post_id AND racetype.meta_key="bhaa_race_type")
LEFT join wp_postmeta racedistance on (race.ID=racedistance.post_id AND racedistance.meta_key="bhaa_race_distance")
LEFT join wp_postmeta raceunit on (race.ID=raceunit.post_id AND raceunit.meta_key="bhaa_race_unit")
LEFT join wp_postmeta leaguetype on (l2e.p2p_from=leaguetype.post_id AND leaguetype.meta_key="bhaa_league_type")
where l2e.p2p_type="league_to_event" and l2e.p2p_from IN (6599)
ORDER BY eventdate


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

-- mens
select
l.league as league,
'T' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'M' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT(CAST(CONCAT_WS(':',l.event,ts.leaguepoints,IF(ts.class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=6599
AND ts.class!='W'
and racetype in ('C','M')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc

--womens
select
l.league as league,
'T' as leaguetype,
ts.team as leagueparticipant,
ROUND(AVG(ts.totalstd),0) as leaguestandard,
COUNT(ts.race) as leaguescorecount,
ROUND(SUM(ts.leaguepoints),0) as leaguepoints,
'M' as leaguedivision,
1 as leagueposition,
GROUP_CONCAT(CAST(CONCAT_WS(':',l.event,ts.leaguepoints,IF(ts.class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=6599
AND ts.class='W'
and racetype in ('C','W')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc


-- says 6 ladies teams
SELECT * FROM wp_bhaa_leaguesummary
WHERE league=6599
AND leaguetype='T'
AND leaguedivision='W'

54
94
161
212
5109
6119

SELECT *,
getLeagueWTeamSummary(leagueparticipant,6599) as x
FROM wp_bhaa_leaguesummary
WHERE league=6599


SELECT *,
FROM wp_bhaa_leaguesummary;

SELECT * FROM wp_bhaa_teamsummary
WHERE leag
SELECT getLeagueWTeamSummary(54,6599);

--CREATE FUNCTION getLeagueWTeamSummary(_team INT,_leagueId INT) RETURNS varchar(200)
select GROUP_CONCAT(CAST(CONCAT(IFNULL(subselect.leaguepoints,0)) AS CHAR) SEPARATOR ',')
from (
  select ts.leaguepoints as leaguepoints
  from wp_bhaa_race_detail rd
  left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=54 AND ts.class='W')
  where rd.league=6599
  and rd.racetype in ('C','S','W')
  and rd.racetype!='TRACK'
  order by rd.eventdate asc
) as subselect;

-- 54,94, 6119
select ts.*,rd.*
from wp_bhaa_race_detail rd
left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=6119 AND ts.class='W')
where rd.league=6599
and rd.racetype in ('C','S','W')
and rd.racetype!='TRACK'
order by rd.eventdate asc


select rd.*
from wp_bhaa_race_detail rd
where rd.league=6599
order by rd.event

-- load wp_bhaa_Race_detail
INSERT INTO wp_bhaa_race_detail (league,leaguetype,event,eventname,eventdate,race,racetype,distance,unit)
select
l2e.p2p_from as league,
leaguetype.meta_value as leaguetype,
event.ID as event,
event.post_title as eventname,
event.post_date as eventdate,
race.ID as race,
racetype.meta_value as racetype,
racedistance.meta_value as distance,
raceunit.meta_value as raceunit
from wp_p2p l2e
join wp_posts event on (l2e.p2p_to=event.ID)
join wp_p2p e2r on (l2e.p2p_to=e2r.p2p_from AND e2r.p2p_type="event_to_race")
join wp_posts race on (e2r.p2p_to=race.ID)
LEFT join wp_postmeta racetype on (race.ID=racetype.post_id AND racetype.meta_key="bhaa_race_type")
LEFT join wp_postmeta racedistance on (race.ID=racedistance.post_id AND racedistance.meta_key="bhaa_race_distance")
LEFT join wp_postmeta raceunit on (race.ID=raceunit.post_id AND raceunit.meta_key="bhaa_race_unit")
LEFT join wp_postmeta leaguetype on (l2e.p2p_from=leaguetype.post_id AND leaguetype.meta_key="bhaa_league_type")
where l2e.p2p_type="league_to_event" and l2e.p2p_from IN (6599)
ORDER BY eventdate

-- not sure what this is doing
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
ORDER BY class,position



select * from wp_bhaa_teamresult

--

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
GROUP_CONCAT(CAST(CONCAT_WS(':',l.event,ts.leaguepoints,IF(ts.class='RACE_ORG','RO',NULL)) AS char ) SEPARATOR ',') AS leaguesummary,
from wp_bhaa_race_detail l
join wp_bhaa_teamsummary ts on l.race=ts.race
where league=6599
AND ts.class!='W'
and racetype in ('C','M')
GROUP BY l.league,ts.team
ORDER BY leaguepoints desc,leaguescorecount desc


select GROUP_CONCAT(CAST(CONCAT(IFNULL(subselect.leaguepoints,0)) AS CHAR) SEPARATOR ',')
from (
  select rd.*,ts.leaguepoints as leaguepoints
  from wp_bhaa_race_detail rd
  left join wp_bhaa_teamsummary ts on (rd.race=ts.race AND ts.team=137 AND ts.class='W')
  where rd.league=6674
  and rd.racetype in ('C','S','W')
  and rd.racetype!='TRACK'
  order by rd.eventdate asc
) as subselect;
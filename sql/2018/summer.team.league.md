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
order by rd.id asc
) as subselect
);
RETURN _result;
END $$

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
order by rd.id asc
) as subselect
);
RETURN _result;
END $$
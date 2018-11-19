# Leagues

A BHAA league is a custom post type with a title and standard wordpress fields. We use the p2p to link events to a league. The custom actions allow us to populate, update and export the league data.

Action
1. Delete - delete the data for this league
2. Populate - recalculates the league positions. See the race CPT for the __Update League__ action.
3. Export Top Ten - Dumps the top ten in each division for a given league

## List Leagues

Use the __category__ to control the current and most recent leagues

![Leagues](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/leagues/leagues.PNG)

## Add League

In general there are 4 leagues per year, with individual and team leagues for the summer and winter seasons.

1. Name - follow the standard naming convention of the leagues.
2. Races To Score - how many evnets should be included
3. Type - Individual or Team league

![New League](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/leagues/new-league.PNG)

## Link events

See the 'Connected Events' elements on the bottom right. This allows you to link the events that count for this league.

![Link Events to Leagues](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/leagues/league-link-event.PNG)

## Edit League

It might be the case that an event is cancelled or added to a league.

![Edit Leagues](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/leagues/edit-league.PNG)


Notes
1. There are 8 individual divisions.
2. There are 2 team divisions.
3. A league can be of type Individual or Team.

### Scoring - Individual Process

1. The key routines to generate individual scores for an event is updateRacePointsByEventId. Which uses a cursor to loop through each race within an event.

2. The first step in updateRacePointsByEventId is to call the routine InitRacePointsData.  This populates the table RacePointsData with the runners from the race. Class='RAN'.

3. Next updateRacePointsByEventId calls the routine addRacePointsDataScoringSets which updates the table RacePointsData with the scoringset which each runner belongs too.  This value is also stored in RacePointsData.

4. Next up updateRacePointsByEventId calls addRacePointDataPositions.  This routine again updates RacePointsData with the runners position in set, standard and age.

5. After this updateRacePointsByEventId  calls addAllRacePoints. This routine populates the table racepoints with the score a runner would get for 2 scoring methods (scoring set and standard).

It is worth pausing here to consider all we have done to date is group runners and score them using 2 algorithms.  All of these steps were added to support multiple scoring methods.  These tables only ever feed back to the main tables
and are never accessed. They were accessed for reporting when we did some examples of different leagues and scorings.

6. UpdateRacePointsByEventId then calls the routine synchRaceResultByRaceId. This routine updates Raceresults with values from RacePointsData positioninstandard and positioninagecategory.  It also copys the points for scoring set to table raceresult from table racepoints.  This calculates pace per km for RaceResult as well for some reason.

7. Now that Raceresult table is up to date UpdateRacePointsByEventId falls back into the old process and calls routine UpdateLeagueData which populates the table LeagueRunnerData.  This tables holds the key information for the individual league.  Total races, points, Avg(standard) so they can move divisions.

8. Finally UpdateRacePointsByEventId  calls the routine UpdateIndividualLeagueSummary . This populates the table LeagueSummary table which is used to efficiently show the top 10 runners for each division.  This is a generic table where both team and individual leagues can be summarised.

Team scoring

1. The team results are populated in the table teamraceresult and are summarised in LeagueSummary table.

** More to follow as I need to dig out my notes on team scoring, probably take me a week ;-)

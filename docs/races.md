# Races

Represents a specific BHAA race

## Race details

The race meta data fields

1. Distance - The race distance
2. Unit - Miles or KM
3. Type - Combined, Male or Women

## Race Actions

Custom actions for a specific race

1. Delete Results - Delete rows from the __wp_bhaa_raceresult__ table.
2. Load Results - Parses the csv data and populates the database.
3. Positions - Update the positions, used after a new Result has been added.
4. Pace - calculates the runners pace based on their time and the race distance.
5. Pos_in_cat - Determines the age category positions.
6. Pos_in_std - Determines the position within the standard.
7. Update Stds - Update the runners standard based on their time.
8. League Points - Calculate the league points for each runner in this race.
9. Delete Teams - Delete the team data.
10. Load Teams - Load the team data.
11. Edit Results - Edit the race result details.

## List Races

View all races by distance and type

![Races](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/races/races.PNG)

## Add Race

![Add Race](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/races/add-race.PNG)

List the race to an event. Add race organiser details, this assigns league points to the organising team and its runners.

![Race Connections](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/races/add-race-connections.PNG)

## Edit Race

![Edit Race](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/races/edit-race.PNG)

![Edit Race Results](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/races/edit-race-results.PNG)

![Edit Runner Result](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/docs/images/races/edit-race-result-runner.PNG)

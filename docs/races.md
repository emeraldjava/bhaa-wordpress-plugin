# Races

Represents a specific BHAA race

<!--ts-->
   * [Races](#races)
      * [Setup Race details](#setup-race-details)
      * [Upload Race Results](#upload-race-results)
      * [Race Actions](#race-actions)
      * [List Races](#list-races)
      * [Add Race](#add-race)
      * [Edit Race](#edit-race)
<!--te-->

## Setup Race Details

The race meta data fields

1. Distance - The race distance
2. Unit - Miles or KM
3. Type - Combined, Male or Women

## Upload Race Results

There is a section ‘BHAA Races’ which allow you create and edit race details. In all cases the ‘Race’ should already be created. There are two large textareas, the first for the individual results and the second for the team results. It’s just a matter of copy/pasting the csv results to these textareas. Hit the ‘Update’ button to save the results.

With the results saved into the race, we now select the options to

    Load Results – this action takes the text details and inserts raceresult details against the specific runners.
    Positions – updated the position value.
    Pace – calculates the runners pace for the race distance.
    Pos Cat – determines the runners position within there age category.
    Poc Std – calculates the position within the runners standard.
    Post Race Standard – updated the runners standard by +/-1 depending on the race time.
    League – every bodies favorite does the league points calculation.

Once the 7 buttons have been hit the race results are ready.

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

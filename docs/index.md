![bhaa logo](https://github.com/emeraldjava/bhaa_wordpress_plugin/raw/master/src/front/img/bhaa_logo_transparent.png)

# BHAA Help

This help guide documents the main featues of the bhaa website and how the bhaawp plugin implement the custom BHAA rules and concepts.

The website is based on a standard wordpress database schema. We use a 'events-manager' plugin to manage our events. We use the 'wp_user' table to represent the BHAA runner. We have a number of wordpress custom post types which allow us to create and edit BHAA races, teams and leagues.

# Custom Post Types

Allows us to handle common BHAA elements as standard wordpress posts, with custom meta field and actions.

1. [Races](races.md) - handles the specific details of each race at a BHAA event. Record the distance and race type and allows us to record individual and team results.
2. [Leagues](leagues.md) - allows us to link specific events to a league and aggregate runners scores to the overall league table.
3. [Houses](houses.md) - represents a company and allows us to link runners to companies for team results.

# Runner

1. [Runner](runner.md) - Each BHAA member is handled as an extended wordpress user.
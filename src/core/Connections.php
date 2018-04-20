<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 21:04
 */

namespace BHAA\core;
use BHAA\utils\Loadable;
use BHAA\utils\Loader;

/**
 * Class Connections
 *
 * Use the short codes on the house and runner page.
 *  echo 'x'. do_shortcode('[p2p_connected type=house_to_runner mode=ol]');
    echo 'xy'. do_shortcode('[p2p_related type=house_to_runner mode=ol]');

 * https://github.com/scribu/wp-posts-to-posts/issues/261
 *
 * @package BHAA\core
 */
class Connections implements Loadable {
    
    const EVENT_TO_RACE = 'event_to_race';
    const LEAGUE_TO_EVENT = 'league_to_event';
    const HOUSE_TO_RUNNER = 'house_to_runner';
    const SECTORTEAM_TO_RUNNER = 'sectorteam_to_runner';
    const TEAM_CONTACT = 'team_contact';
    // indicates a runner who will get 10 league points for organsing a race
    const RACE_ORGANISER = 'race_organiser';
    // indicates a team that 6 leagues points for organising an event
    const TEAM_POINTS = 'team_points';

    public function registerHooks(Loader $loader) {
        $loader->add_action('p2p_init',$this,'bhaa_connection_types');
        $loader->add_action('p2p_created_connection',$this,'bhaa_p2p_created_connection');
        $loader->add_action('p2p_created_connection',$this,'bhaa_p2p_delete_connections');
        $loader->add_filter('p2p_user_admin_column_link',$this,'bhaa_change_user_to_house_column_url',10,2);
        $loader->add_filter('p2p_user_admin_column_link',$this,'bhaa_change_house_to_user_column_url',10,2);
    }

    function bhaa_connection_types() {

        p2p_register_connection_type( array(
            'name' => Connections::EVENT_TO_RACE,
            'from' => 'espresso_events',
            'to' => 'race',
            'admin_column' => true,
            'cardinality' => 'one-to-many',
            'title' => array( 'from' => 'Races', 'to' => 'Event' )
        ));
        p2p_register_connection_type( array(
            'name' => Connections::LEAGUE_TO_EVENT,
            'from' => 'league',
            'to' => 'espresso_events',
            'cardinality' => 'many-to-many'
        ));
        p2p_register_connection_type( array(
            'name' => Connections::HOUSE_TO_RUNNER,
            'from' => 'house',
            'to' => 'user',
            'cardinality' => 'one-to-many',
            'admin_column' => true,
            'title' => array( 'from' => 'Company Runners', 'to' => 'Company' )
        ));
        p2p_register_connection_type( array(
            'name' => Connections::SECTORTEAM_TO_RUNNER,
            'from' => 'house',
            'to' => 'user',
            'cardinality' => 'one-to-many',
            'admin_column' => true,
            'title' => array( 'from' => 'Sector Team Runners', 'to' => 'Sector Team' )
        ));
        p2p_register_connection_type( array(
            'name' => Connections::TEAM_CONTACT,
            'from' => 'house',
            'to' => 'user',
            'cardinality' => 'one-to-one',
            //'admin_column' => true,
            'title' => array( 'from' => 'Team Contact', 'to' => 'Team Contact' )
        ));
        p2p_register_connection_type( array(
            'name' => Connections::RACE_ORGANISER,
            'from' => 'race',
            'to' => 'user',
            'cardinality' => 'many-to-many',
            'title' => array( 'from' => 'Race Organiser', 'to' => 'Race Organiser')
        ));
        p2p_register_connection_type( array(
            'name' => Connections::TEAM_POINTS,
            'from' => 'race',
            'to' => 'house',
            'cardinality' => 'many-to-many',
            'title' => array( 'from' => 'Team Points', 'to' => 'Team Points')
        ));
    }

    /**
     * On the user admin page, have the correct URL to the house.
     * https://github.com/scribu/wp-posts-to-posts/pull/477#issuecomment-107669604
     * @param $link
     * @param $item
     * @return string
     */
    function bhaa_change_user_to_house_column_url( $link, $item ) {
        if( Connections::HOUSE_TO_RUNNER === $item->p2p_type )
            return add_query_arg( array( 'post' => $item->get_id(), 'action' => 'edit' ), admin_url('post.php') );
        return $link;
    }

    function bhaa_change_house_to_user_column_url( $link, $item ) {
        if( 'house' === get_current_screen()->post_type &&
            Connections::HOUSE_TO_RUNNER === $item->p2p_type )
            return add_query_arg( array( 'id' => $item->get_id(), 'page' => 'bhaa_admin_runner' ), admin_url('admin.php') );
        return $link;
    }

    function bhaa_p2p_created_connection($p2p_id) {
        $connection = p2p_get_connection( $p2p_id );
        if($connection->p2p_type == Connections::RACE_ORGANISER) {
            $raceResult = new RaceResult();
            $raceResult->addRaceOrganiser($connection->p2p_from,$connection->p2p_to);
        } elseif($connection->p2p_type == Connections::TEAM_POINTS) {
            $teamResult = new TeamResult($connection->p2p_from);
            $res = $teamResult->addTeamOrganiserPoints($connection->p2p_to);
        }
    }

    function bhaa_p2p_delete_connections($p2p_id) {
        $connection = p2p_get_connection( $p2p_id );
        if($connection->p2p_type == Connections::RACE_ORGANISER) {
            $raceResult = new RaceResult();
            $raceResult->deleteRaceOrganiser($connection->p2p_from,$connection->p2p_to);
        } elseif($connection->p2p_type == Connections::TEAM_POINTS) {
            $teamResult = new TeamResult($connection->p2p_from);
            $res = $teamResult->deleteTeamOrganiserPoints($connection->p2p_to);
        }
    }
}
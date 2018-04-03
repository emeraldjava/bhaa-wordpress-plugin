<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 21:04
 */

namespace BHAA\core;

class Connections {
    
    const EVENT_TO_RACE = 'event_to_race';
    const LEAGUE_TO_EVENT = 'league_to_event';
    const HOUSE_TO_RUNNER = 'house_to_runner';
    const SECTORTEAM_TO_RUNNER = 'sectorteam_to_runner';
    const TEAM_CONTACT = 'team_contact';
    // indicates a runner who will get 10 league points for organsing a race
    const RACE_ORGANISER = 'race_organiser';
    // indicates a team that 6 leagues points for organising an event
    const TEAM_POINTS = 'team_points';

    function __construct() {
        add_action('p2p_init',array(&$this,'bhaa_connection_types'));
        add_action('p2p_created_connection',array($this,'bhaa_p2p_created_connection'));
        add_action('p2p_delete_connections',array($this,'bhaa_p2p_delete_connections'));
    }

    function bhaa_connection_types() {

        p2p_register_connection_type( array(
            'name' => Connections::EVENT_TO_RACE,
            'from' => 'event',
            'to' => 'race',
            'cardinality' => 'one-to-many'
        ));
        p2p_register_connection_type( array(
            'name' => Connections::LEAGUE_TO_EVENT,
            'from' => 'league',
            'to' => 'event',
            'cardinality' => 'many-to-many'
        ));
        p2p_register_connection_type( array(
            'name' => Connections::HOUSE_TO_RUNNER,
            'from' => 'house',
            'to' => 'user',
            'cardinality' => 'one-to-many',
            'title' => array( 'from' => 'Company Runner', 'to' => 'Company' )
        ));
        p2p_register_connection_type( array(
            'name' => Connections::SECTORTEAM_TO_RUNNER,
            'from' => 'house',
            'to' => 'user',
            'cardinality' => 'one-to-many',
            'title' => array( 'from' => 'Sector Team Runner', 'to' => 'Sector Team' )
        ));
        p2p_register_connection_type( array(
            'name' => Connections::TEAM_CONTACT,
            'from' => 'house',
            'to' => 'user',
            'cardinality' => 'one-to-one',
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
}
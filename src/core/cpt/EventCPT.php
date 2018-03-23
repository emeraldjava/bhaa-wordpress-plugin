<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:29
 */

namespace BHAA\core\cpt;

use BHAA\utils\Actionable;

class EventCPT implements Actionable {

    public function get_actions() {
        return array(
            'init' => 'bhaa_register_cpt_event'
        );
    }

    function bhaa_register_cpt_event() {
        $eventLabels = array(
            'name' => _x( 'Events', 'event' ),
            'singular_name' => _x( 'Event', 'event' ),
            'add_new' => _x( 'Add New', 'event' ),
            'add_new_item' => _x( 'Add New Event', 'event' ),
            'edit_item' => _x( 'Edit Event', 'event' ),
            'new_item' => _x( 'New Event', 'event' ),
            'view_item' => _x( 'View Event', 'event' ),
            'search_items' => _x( 'Search Events', 'event' ),
            'not_found' => _x( 'No events found', 'event' ),
            'not_found_in_trash' => _x( 'No events found in Trash', 'event' ),
            'parent_item_colon' => _x( 'Parent Event:', 'event' ),
            'menu_name' => _x( 'BHAA Events', 'event' ),
        );

        $eventArgs = array(
            'labels' => $eventLabels,
            'hierarchical' => true,
            'description' => 'BHAA Event Details',
            'supports' => array('title','editor','excerpt','thumbnail','comments'),// add 'page-attributes' for parent hierarchy
            'taxonomies' => array('sector','category'),
            'public' => true,
            'show_ui' => true,
            'show_in_menu' => true,
            'show_in_nav_menus' => true,
            'publicly_queryable' => true,
            'exclude_from_search' => false,
            'has_archive' => true,
            'query_var' => true,
            'can_export' => true,
            'rewrite' => true,
            'capability_type' => 'post'
        );
        register_post_type( 'event', $eventArgs );
    }
}
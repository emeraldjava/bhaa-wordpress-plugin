<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 22:41
 */

namespace BHAA\core\runner;

use WP_User_Query;

class RunnerManager {

    /**
     * https://code.tutsplus.com/tutorials/mastering-wp_user_query--cms-23204
     * https://wordpress.stackexchange.com/questions/219686/how-can-i-get-a-list-of-users-by-their-role
     * https://generatewp.com/wp_user_query/
     *
     */
    public function getMembers() {
        $args = array(
            'role'    => 'bhaamember',
            'orderby' => 'display_name',
            'order'   => 'ASC',
            'meta_query' => array(
                'relation' => 'OR',
                array('key' => 'first_name','compare' => 'like', 'value' => $query),
                array('key' => 'bhaa_runner_status','compare'=>'!=','value'=>'D')
            )
        );

        // The Query
        $user_query = new WP_User_Query( $args );

        // User Loop
        if ( ! empty( $user_query->get_results() ) ) {
            echo '<p>Total Members ' . $user_query->get_total() . '</p>';
            foreach ( $user_query->get_results() as $user ) {
                echo '<p>' . $user->display_name . '</p>';
            }
        } else {
            echo 'No users found.';
        }
    }


    /**
     * https://tommcfarlin.com/wordpress-user-role/
     * @param $user_id
     */
    public function set_user_role( $user_id ) {
        // Define a user role based on its index in the array.
        $roles = array(
            'bhaamember',
            'subscriber'
        );
        $role = $roles[1];
        // Set the user's role (and implicitly remove the previous role).
        $user = new WP_User( $user_id );
        $user->set_role( $role );
    }

    function getMembersNotInRole() {
        $args = array(
            'number' => 25,
            'fields' => 'all',
            'meta_query' => array(
                array('key' => 'Runner::BHAA_RUNNER_STATUS','compare' => '=', 'value' => 'M')
                )
        );
        error_log(print_r($args,true));
        // https://stackoverflow.com/questions/24163215/use-wp-user-query
        $user_query = new WP_User_Query( $args );
        $runners = $user_query->get_results();
    }
}
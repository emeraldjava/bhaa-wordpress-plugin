<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 22:41
 */

namespace BHAA\admin\manager;

class RunnerManager {

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
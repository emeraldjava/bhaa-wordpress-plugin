<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 22:41
 */

namespace BHAA\admin\manager;

class RunnerManager {

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
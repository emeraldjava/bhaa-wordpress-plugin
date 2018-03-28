<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 23/03/2018
 * Time: 12:58
 */

namespace BHAA\core\race;

/**
 * Class RaceResult
 * @package BHAA\core\race
 */
class RaceResult {

    function getRaceResults($race) {
        global $wpdb;
        $query = "SELECT wp_bhaa_raceresult.*,
                first_name.meta_value AS firstname, 
                UPPER(last_name.meta_value) AS surname,
                wp_users.user_nicename,gender.meta_value as gender,
                wp_posts.id as cid,wp_posts.post_title as cname
                FROM wp_bhaa_raceresult
                left join wp_users on wp_users.id=wp_bhaa_raceresult.runner
                join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
                join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
                left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
                left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key='bhaa_runner_company')
                left join wp_posts on (wp_posts.post_type='house' and company.meta_value=wp_posts.id)
                where race=%d and wp_bhaa_raceresult.class='RAN' and position<=500 ORDER BY position";
        $SQL = $wpdb->prepare($query,$race);
        //error_log($SQL);
        return $wpdb->get_results($SQL,OBJECT);
    }
}
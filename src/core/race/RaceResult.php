<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 23/03/2018
 * Time: 12:58
 */

namespace BHAA\core\race;


class RaceResult {

    function getRaceResults($race) {
        global $wpdb;
        $query = 'SELECT wp_bhaa_raceresult.*,wp_users.display_name,
			wp_users.user_nicename,gender.meta_value as gender,
			wp_posts.id as cid,wp_posts.post_title as cname
			FROM wp_bhaa_raceresult
			left join wp_users on wp_users.id=wp_bhaa_raceresult.runner
			left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
			left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key="bhaa_runner_company")
			left join wp_posts on (wp_posts.post_type="house" and company.meta_value=wp_posts.id)
			where race=5609 and wp_bhaa_raceresult.class="RAN" and position<=500 ORDER BY position';
        return $wpdb->get_results($query,OBJECT);
    }
}
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
    public function getBHAAMembers() {
        global $wpdb;
        $SQL = 'SELECT wp_users.id AS id,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) AS label,
            TRIM(first_name.meta_value) AS firstname,
            TRIM(last_name.meta_value) AS lastname,
            wp_users.user_email AS email,
            status.meta_value AS status,
            renewaldate.meta_value AS renewaldate,
            gender.meta_value AS gender,
            TRIM(house.post_title) AS companyname,
            company.meta_value AS companyid,
            CASE WHEN r2s.p2p_from IS NOT NULL THEN TRIM(sectorteam.post_title) ELSE TRIM(house.post_title) END AS teamname,
            CASE WHEN r2s.p2p_from IS NOT NULL THEN r2s.p2p_from ELSE r2c.p2p_from END AS teamid,
            IFNULL(standard.meta_value,0) AS standard,
            dob.meta_value AS dob
            FROM wp_users
            JOIN wp_usermeta capabilities on (capabilities.user_id=wp_users.id and capabilities.meta_key="wp_capabilities")
            LEFT JOIN wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = "house_to_runner")
            LEFT JOIN wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = "sectorteam_to_runner")
            LEFT JOIN wp_usermeta first_name ON (first_name.user_id=wp_users.id AND first_name.meta_key="first_name")
            LEFT JOIN wp_usermeta last_name ON (last_name.user_id=wp_users.id AND last_name.meta_key="last_name")
            LEFT JOIN wp_usermeta dob ON (dob.user_id=wp_users.id AND dob.meta_key="bhaa_runner_dateofbirth")
            LEFT JOIN wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key="bhaa_runner_status")
            LEFT JOIN wp_usermeta gender ON (gender.user_id=wp_users.id AND gender.meta_key="bhaa_runner_gender")
            LEFT JOIN wp_usermeta company ON (company.user_id=wp_users.id AND company.meta_key="bhaa_runner_company")
            LEFT JOIN wp_usermeta standard ON (standard.user_id=wp_users.id AND standard.meta_key="bhaa_runner_standard")
            LEFT JOIN wp_usermeta renewaldate ON (renewaldate.user_id=wp_users.id AND renewaldate.meta_key="bhaa_runner_dateofrenewal")
            LEFT JOIN wp_posts house ON (house.id=company.meta_value AND house.post_type="house")
            LEFT JOIN wp_posts sectorteam ON (sectorteam.id=r2s.p2p_from AND sectorteam.post_type="house")
            WHERE capabilities.meta_value LIKE("%bhaamember%") AND TRIM(IFNULL(wp_users.display_name,"")) <> ""
            ORDER BY lastname,firstname';
        //error_log($SQL);
        return $wpdb->get_results($SQL,ARRAY_A);
    }

    public function getEventOnlineMembers() {
        global $wpdb;
        $SQL = 'SELECT wp_users.id as id,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
            TRIM(first_name.meta_value) as firstname,
            TRIM(last_name.meta_value) as lastname,
            wp_users.user_email as email,
            CASE WHEN reg.REG_paid = "10.000" THEN "M" ELSE "D" END as status,
            "2018-03-30" AS renewaldate,
            COALESCE(gender.meta_value,"M") as gender,
            COALESCE(TRIM(house.post_title),"Day Runner") as companyname,
            COALESCE(company.meta_value,1) as companyid,
            COALESCE(TRIM(house.post_title),"Day Runner") as teamname,
            COALESCE(company.meta_value,1) as teamid,
            COALESCE(standard.meta_value,10) as standard,
            COALESCE(dob.meta_value,"1980-01-01") as dob
            FROM wp_esp_registration as reg
            JOIN wp_usermeta eeAttendee on (eeAttendee.meta_value=reg.ATT_ID and eeAttendee.meta_key="wp_EE_Attendee_ID")
            JOIN wp_users on (eeAttendee.user_id=wp_users.id)
            left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
            left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
            left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
            left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
            left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
            left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key="bhaa_runner_company")
            left join wp_posts house on (house.id=company.meta_value and house.post_type="house")
            left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
            WHERE reg.EVT_ID=5654
            AND reg.REG_paid!=0
            ORDER BY lastname ASC, firstname ASC';
        return $wpdb->get_results($SQL,ARRAY_A);
    }
    
    public function getNewOnlineBHAAMembers(){
        global $wpdb;
        $SQL = 'SELECT wp_users.id as id,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
            TRIM(first_name.meta_value) as firstname,
            TRIM(last_name.meta_value) as lastname,
            wp_users.user_email as email,
            CASE WHEN reg.REG_paid = "15.000" THEN "M" ELSE "D" END as status,
            "2018-03-30" AS renewaldate,
            COALESCE(gender.meta_value,"M") as gender,
            COALESCE(TRIM(house.post_title),"Day Runner") as companyname,
            COALESCE(company.meta_value,1) as companyid,
            COALESCE(TRIM(house.post_title),"Day Runner") as teamname,
            COALESCE(company.meta_value,1) as teamid,
            COALESCE(standard.meta_value,10) as standard,
            COALESCE(dob.meta_value,"1980-01-01") as dob
            FROM wp_esp_registration as reg
            JOIN wp_usermeta eeAttendee on (eeAttendee.meta_value=reg.ATT_ID and eeAttendee.meta_key="wp_EE_Attendee_ID")
            JOIN wp_users on (eeAttendee.user_id=wp_users.id)
            left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
            left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
            left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
            left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
            left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
            left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key="bhaa_runner_company")
            left join wp_posts house on (house.id=company.meta_value and house.post_type="house")
            left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
            WHERE reg.EVT_ID=5651
            AND reg.REG_paid!=0
            ORDER BY lastname ASC, firstname ASC';
        return $wpdb->get_results($SQL,ARRAY_A);
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
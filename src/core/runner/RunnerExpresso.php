<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 28/12/18
 * Time: 22:16
 */

namespace BHAA\core\runner;


class RunnerExpresso {

    /**
     * Return the BHAA Runner ID for the given registration, if it exists.
     * @param $reg_url_link
     * @return arrayR
     */
    function getBhaaIdForRegistration($reg_url_link) {
        global $wpdb;
        $SQL = $wpdb->prepare('SELECT bhaa_id.user_id FROM wp_esp_registration reg
            JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key="wp_EE_Attendee_ID")
            WHERE REG_url_link=%s',$reg_url_link);
        error_log('getBhaaIdForRegistration() SQL:'.$SQL);
        $bhaa_runner_id = $wpdb->get_var($SQL);
        error_log('getBhaaIdForRegistration() '.print_r($bhaa_runner_id));
        return print_r($bhaa_runner_id);
    }

    /**
     * Load the details from the saved answers and update the runner.
     */
    function getBhaaAnswersForRegistration() {

    }

    // annual membership 2019 = EVT_ID:6876
//    function setEventExpressoRunnerDetails($primary_reg,$dob,$gender,$company) {
//        error_log(sprintf('%s,%s,%s,%s',$primary_reg,$dob,$gender,$company));
//        global $wpdb;
//        $SQL = $wpdb->prepare('SELECT * FROM wp_esp_registration WHERE REG_url_link="%s"',$primary_reg);
//        error_log($SQL);
//        $vv = $wpdb->get_row($SQL);//,'ARRAY_A');
//        error_log(var_dump($vv));
//    }
}
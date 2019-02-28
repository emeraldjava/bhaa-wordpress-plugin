<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 28/12/18
 * Time: 22:16
 */

namespace BHAA\core\runner;


class RunnerExpresso {

    function getAnnualMembershipEventId() {
        return 6907;
    }

    function getEventForRegistration($reg_url_link) {
        global $wpdb;
        $SQL = $wpdb->prepare("SELECT reg.EVT_ID as event_id FROM wp_esp_registration reg
            WHERE REG_url_link=%s",$reg_url_link);
        $event = $wpdb->get_row($SQL,ARRAY_A);
        error_log('getEventForRegistration() SQL:'.$SQL.'->'.printf($event));
        return $event;
    }

    /**
     * Return the BHAA Runner ID for the given registration, if it exists.
     * @param $reg_url_link
     * @return arrayR
     */
    function getRunnerAndEventForRegistration($reg_url_link) {
        global $wpdb;
        $SQL = $wpdb->prepare("SELECT bhaa_id.user_id AS runner_id, reg.EVT_ID as event_id FROM wp_esp_registration reg
            JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key='wp_EE_Attendee_ID')
            WHERE REG_url_link=%s",$reg_url_link);
        $runner_event = $wpdb->get_row($SQL,ARRAY_A);
        error_log('getRunnerAndEventForRegistration() SQL:'.$SQL.'->'.printf($runner_event));
        return $runner_event;
    }

    /**
     * Get the recorded answers for the registered runner.
     * -> SELECT QST_ID,ANS_value FROM wp_esp_answer WHERE REG_ID=2366 ORDER BY QST_ID ASC
     */
    function getBhaaAnswersForRegistration($reg_id) {
        global $wpdb;
        $SQL = $wpdb->prepare("SELECT QST_ID,ANS_value FROM wp_esp_answer WHERE REG_ID=%d ORDER BY QST_ID ASC",$reg_id);
        $answers = $wpdb->get_results($SQL,ARRAY_A);
        //error_log('getBhaaIdForRegistration() SQL:'.$SQL.'; ->'.print_r($answers,true));
        return $answers;
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
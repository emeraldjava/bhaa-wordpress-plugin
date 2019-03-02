<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 04/04/2018
 * Time: 17:25
 */

namespace BHAA\admin;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;
use BHAA\core\race\RaceResult;
use BHAA\core\race\TeamResult;
use BHAA\core\cpt\RaceCpt;

class RaceAdminController extends AbstractAdminController implements Loadable {

    private $raceResult;

    function __construct() {
        parent::__construct();
        $this->raceResult = new RaceResult();
    }

    public function registerHooks(Loader $loader) {
        // save / delete specific rows or race result data
        $loader->add_action('admin_action_bhaa_race_result_save',$this,'bhaa_race_result_save');
        $loader->add_action('admin_action_bhaa_race_result_delete',$this,'bhaa_race_result_delete');

        // csv data actions
        $loader->add_action('admin_action_bhaa_race_load_results',$this,'bhaa_race_load_results');
        $loader->add_action('admin_action_bhaa_race_delete_results',$this,'bhaa_race_delete_results');
        $loader->add_action('admin_action_bhaa_race_load_team_results',$this,'bhaa_race_load_team_results');
        $loader->add_action('admin_action_bhaa_race_delete_team_results',$this,'bhaa_race_delete_team_results');

        // TODO $loader->add_action('admin_action_bhaa_race_add_result',$this,'bhaa_race_add_result');
        $loader->add_action('admin_action_bhaa_race_positions',$this,'bhaa_race_positions');
        $loader->add_action('admin_action_bhaa_race_pace',$this,'bhaa_race_pace');
        $loader->add_action('admin_action_bhaa_race_pos_in_cat',$this,'bhaa_race_pos_in_cat');
        $loader->add_action('admin_action_bhaa_race_pos_in_std',$this,'bhaa_race_pos_in_std');
        $loader->add_action('admin_action_bhaa_race_update_standards',$this,'bhaa_race_update_standards');
        $loader->add_action('admin_action_bhaa_race_league',$this,'bhaa_race_league');
    }

    public function bhaa_race_result_save() {
        error_log("bhaa_race_result_save() ".$_POST['bhaa_race']);
        $this->raceResult->updateRaceResult(
            $_POST['bhaa_raceresult_id'],
            $_POST['bhaa_race'],
            $_POST['bhaa_runner'],
            $_POST['bhaa_time'],
            $_POST['bhaa_pre_standard'],
            $_POST['bhaa_post_standard'],
            $_POST['bhaa_number']
        );
        $this->raceResult->updatePositions($_POST['bhaa_race']);
        wp_redirect(admin_url('edit.php?post_type=race&page=bhaa_race_edit_results&id='.$_POST['bhaa_race']));
    }

    public function bhaa_race_result_delete() {
        error_log("bhaa_race_result_delete() ".$_POST['bhaa_race']);
        $this->raceResult->deleteRaceResult($_POST['bhaa_raceresult_id']);
        $this->raceResult->updatePositions($_POST['bhaa_race']);
        wp_redirect(admin_url('edit.php?post_type=race&page=bhaa_race_edit_results&id='.$_POST['bhaa_race']));
    }

    function bhaa_race_load_results() {
        if(wp_verify_nonce($_GET['_wpnonce'],'bhaa_race_load_results')) {
            $race = get_post($_GET['post_id']);
            $resultText = $race->post_content;
            $this->raceResult->processRaceResults($race->ID, $race->post_content);
            wp_redirect(wp_get_referer());
            exit();
        }
    }
    function bhaa_race_delete_results() {
        if(wp_verify_nonce($_GET['_wpnonce'],'bhaa_race_delete_results')) {
            $this->raceResult->deleteRaceResults($_GET['post_id']);
            //queue_flash_message("bhaa_race_delete_results ".$_GET['post_id']);
            wp_redirect(wp_get_referer());
            exit();
        }
    }
    function bhaa_race_positions() {
        $this->raceResult->updatePositions($_GET['post_id']);
        //queue_flash_message("bhaa_race_positions");
        wp_redirect( $_SERVER['HTTP_REFERER'] );
        exit();
    }
    function bhaa_race_pace() {
        $this->raceResult->updateRacePace($_GET['post_id']);
        //queue_flash_message("bhaa_race_pace ".$_GET['post_id']);
        wp_redirect( $_SERVER['HTTP_REFERER'] );
        exit();
    }
    function bhaa_race_pos_in_cat() {
        $this->raceResult->updateRacePosInCat($_GET['post_id']);
        //queue_flash_message("bhaa_race_pos_in_cat");
        wp_redirect(wp_get_referer());
        exit();
    }
    function bhaa_race_pos_in_std() {
        $this->raceResult->updateRacePosInStd($_GET['post_id']);
        //queue_flash_message("bhaa_race_pos_in_std");
        wp_redirect(wp_get_referer());
        exit();
    }
    function bhaa_race_update_standards() {
        $this->raceResult->updatePostRaceStd($_GET['post_id']);
        //queue_flash_message("bhaa_race_update_standards");
        wp_redirect(wp_get_referer());
        exit();
    }
    function bhaa_race_league() {
        $this->raceResult->updateLeague($_GET['post_id']);
        //queue_flash_message("bhaa_race_league");
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_race_load_team_results() {
        $teamResult = new TeamResult($_GET['post_id']);
        $teamResultBlob = get_post_meta($_GET['post_id'],RaceCpt::BHAA_RACE_TEAM_RESULTS,true);
        $teamResults = explode("\n",$teamResultBlob);
        error_log('Number of team results '.sizeof($teamResults));
        foreach($teamResults as $result){
            $details = explode(',',$result);
            error_log('team result '.print_r($details,true));
            $teamResult->addResult($details);
        }
        //queue_flash_message("bhaa_race_load_team_results :: ".sizeof($teamResults));
        wp_redirect(wp_get_referer());
        exit();
    }
    function bhaa_race_delete_team_results(){
        error_log('bhaa_race_delete_team_results');
        $teamResult = new TeamResult($_GET['post_id']);
        $teamResult->deleteResults();
        //queue_flash_message("bhaa_race_delete_team_results");
        wp_redirect(wp_get_referer());
        exit();
    }
    function bhaa_race_add_result() {
        //$newRaceResult = RaceResult::get_instance()->addDefaultResult($_POST['post_id']);
        //queue_flash_message("bhaa_race_add_result");
        //$url = admin_url('edit.php?post_type=race&page=bhaa_race_edit_result&raceresult='.$newRaceResult);
        //wp_redirect($url);
    }
}
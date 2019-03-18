<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 04/04/2018
 * Time: 17:25
 */

namespace BHAA\core\race;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;
use BHAA\admin\AbstractAdminController;
use BHAA\core\Mustache;

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

        // sub-menu
        $loader->add_action('admin_menu', $this, 'bhaa_race_sub_menu');

        // TODO $loader->add_action('admin_action_bhaa_race_add_result',$this,'bhaa_race_add_result');
        $loader->add_action('admin_action_bhaa_race_positions',$this,'bhaa_race_positions');
        $loader->add_action('admin_action_bhaa_race_pace',$this,'bhaa_race_pace');
        $loader->add_action('admin_action_bhaa_race_pos_in_cat',$this,'bhaa_race_pos_in_cat');
        $loader->add_action('admin_action_bhaa_race_pos_in_std',$this,'bhaa_race_pos_in_std');
        $loader->add_action('admin_action_bhaa_race_update_standards',$this,'bhaa_race_update_standards');
        $loader->add_action('admin_action_bhaa_race_league',$this,'bhaa_race_league');

        $loader->add_action('admin_action_bhaa_race_age_and_cat',$this,'bhaa_race_age_and_cat');
        $loader->add_action('admin_action_bhaa_race_awards',$this,'bhaa_race_awards');
    }

    function get_bhaa_race_admin_url_links($postId) {
        return array(
            'bhaa_race_positions' => $this->generate_race_admin_url_link('bhaa_race_positions',$postId,'Positions'),
            'bhaa_race_pace' => $this->generate_race_admin_url_link('bhaa_race_pace',$postId,'Pace'),
            'bhaa_race_pos_in_cat' => $this->generate_race_admin_url_link('bhaa_race_pos_in_cat',$postId,'Pos_in_cat'),
            'bhaa_race_pos_in_std' => $this->generate_race_admin_url_link('bhaa_race_pos_in_std',$postId,'Pos_in_std'),
            'bhaa_race_update_standards' => $this->generate_race_admin_url_link('bhaa_race_update_standards',$postId,'Update Stds'),
            'bhaa_race_league' => $this->generate_race_admin_url_link('bhaa_race_league',$postId,'League Points'),
            'bhaa_race_age_and_cat' => $this->generate_race_admin_url_link('bhaa_race_age_and_cat',$postId,'Age & Cat'),
            'bhaa_race_awards' => $this->generate_race_admin_url_link('bhaa_race_awards',$postId,'Awards')
        );
    }

    private function generate_race_admin_url_link($action,$post_id,$link_title) {
        $adminURL = add_query_arg(
            array('action'=>$action,
                'post_type'=>'race',
                'post_id'=>$post_id
            ),admin_url());
        return '<a href='.wp_nonce_url($adminURL, $action).'>'.$link_title.'</a>';
    }

    /**
     * Add sub-menus under the BHAA Races to edit all race results or a specific one. Make first parameter null to hide.
     * 'edit.php?post_type=race'
     */
    function bhaa_race_sub_menu() {
        // see http://websitesthatdontsuck.com/2011/11/adding-a-sub-menu-to-a-custom-post-type/ - 'edit.php?post_type=race'
        add_submenu_page( null, 'BHAA Race Admin', 'BHAA Race Admin',
            'manage_options', 'bhaa_edit_raceresults',
            array($this,'bhaa_edit_raceresults'));
        // make first element null to hide - 'edit.php?post_type=race'
        add_submenu_page( null, 'Edit RaceResult', 'Edit RaceResult',
            'manage_options', 'bhaa_edit_raceresult',
            array($this,'bhaa_edit_raceresult'));
        //add_submenu_page(null, 'BHAA Race Admin', 'Race',
        //    'manage_options', 'bhaa_admin_raceresult', array($this, 'bhaa_admin_edit_raceresult'));
    }

    function bhaa_edit_raceresults() {
        //error_log('bhaa_race_edit_results '.$_GET['id']);
        $raceResult = new RaceResult();
        $res = $raceResult->getRaceResults($_GET['id']);
        // call the template
        $mustache = new Mustache();
        $raceResultTable = $mustache->renderTemplate(
            'edit.race.results.individual',
            array(
                'runners'=>$res,
                'isAdmin'=>true,
                'formUrl'=>'link',
                'racename'=>'racename',
                'dist'=>'dist',
                'unit'=>'unit',
                'type'=>'type'));
        set_query_var( 'raceResultTable', $raceResultTable );

        // dirty
        $bhaa_race_admin_url_links =  implode(' | ', $this->get_bhaa_race_admin_url_links($_GET['id']));
        set_query_var( 'bhaa_race_admin_url_links', $bhaa_race_admin_url_links );
        //error_log($bhaa_race_admin_url_links);
        include plugin_dir_path( __FILE__ ) . 'partials/edit.raceresults.php';
//        include plugin_dir_path( __FILE__ ) . 'partials/race/race-admin.php';
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
    function bhaa_race_delete_team_results() {
        error_log('bhaa_race_delete_team_results');
        $teamResult = new TeamResult($_GET['post_id']);
        $teamResult->deleteResults();
        //queue_flash_message("bhaa_race_delete_team_results");
        wp_redirect(wp_get_referer());
        exit();
    }
    // BHAA Race specific actions
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
    function bhaa_race_age_and_cat() {
        parent::flashMessage("bhaa_race_age_and_cat()");
        wp_redirect(wp_get_referer());
        exit();
    }
    function bhaa_race_awards() {
        parent::flashMessage("bhaa_race_awards");
        wp_redirect(wp_get_referer());
        exit();
    }
    // Specific race result row actions
    function bhaa_edit_raceresult() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $raceResultObj = new RaceResult();
        $raceResult = $raceResultObj->getRaceResult($_GET['raceresult']);
        $link = admin_url('admin.php');
        include_once( 'partials/edit.raceresult.php' );
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
    function bhaa_race_add_result() {
        //$newRaceResult = RaceResult::get_instance()->addDefaultResult($_POST['post_id']);
        //queue_flash_message("bhaa_race_add_result");
        //$url = admin_url('edit.php?post_type=race&page=bhaa_race_edit_result&raceresult='.$newRaceResult);
        //wp_redirect($url);
    }
    function bhaa_race_result_delete() {
        error_log("bhaa_race_result_delete() ".$_POST['bhaa_race']);
        $this->raceResult->deleteRaceResult($_POST['bhaa_raceresult_id']);
        $this->raceResult->updatePositions($_POST['bhaa_race']);
        wp_redirect(admin_url('edit.php?post_type=race&page=bhaa_race_edit_results&id='.$_POST['bhaa_race']));
    }

}
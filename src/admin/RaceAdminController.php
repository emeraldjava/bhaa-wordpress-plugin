<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 04/04/2018
 * Time: 17:25
 */

namespace BHAA\admin;

use BHAA\utils\Actionable;
use BHAA\utils\Filterable;
use BHAA\core\race\RaceResult;

class RaceAdminController implements Filterable, Actionable {

    private $raceResult;

    function __construct() {
        $this->raceResult = new RaceResult();
    }

    public function get_filters() {
        return array();
    }

    public function get_actions() {
        return array(
            'admin_menu' => 'bhaa_admin_race_sub_menu',
            'admin_action_bhaa_race_result_save' => 'bhaa_race_result_save',
            'admin_action_bhaa_race_result_delete' => 'bhaa_race_result_delete'
        );
    }

    public function bhaa_admin_race_sub_menu() {
        add_submenu_page(null, 'BHAA Race Admin', 'Race',
            'manage_options', 'bhaa_admin_raceresult', array($this, 'bhaa_admin_edit_raceresult'));
    }

    function bhaa_admin_edit_raceresult() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }

        $raceResult = $this->raceResult->getRaceResult($_GET['raceresult']);
        $link = admin_url('admin.php');
        $raceLink = $this->generate_edit_raceresult_link($raceResult->race);
        include_once( 'partials/bhaa_admin_raceresult.php' );
    }

    function generate_edit_raceresult_link($post_id) {
        return '<a href='.admin_url('edit.php?post_type=race&page=bhaa_race_edit_results&id='.$post_id).'>Edit Results</a>';
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
}
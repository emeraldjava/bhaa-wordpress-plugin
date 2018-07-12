<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 05/04/2018
 * Time: 16:12
 */

namespace BHAA\admin;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;
use BHAA\core\league\IndividualLeague;
use BHAA\core\league\TeamLeague;
use BHAA\core\cpt\LeagueCPT;

class LeagueAdminController extends AbstractAdminController implements Loadable {

    function __construct() {
        parent::__construct();
    }

    public function registerHooks(Loader $loader) {
        $loader->add_action('admin_action_bhaa_league_delete',$this,'bhaa_league_delete');
        $loader->add_action('admin_action_bhaa_league_populate',$this,'bhaa_league_populate');
        $loader->add_action('admin_action_bhaa_league_top_ten',$this,'bhaa_league_top_ten');
    }

    /**
     * Handle the URL GET call to edit.php
     * http://wordpress.stackexchange.com/questions/82761/how-can-i-link-post-row-actions-with-a-custom-action-function?rq=1
     */
    function bhaa_league_delete() {
        if(wp_verify_nonce($_GET['_wpnonce'],'bhaa_league_delete')) {
            $leagueId = $_GET['post_id'];
            $leagueHandler = $this->getLeagueHandler($leagueId);
            $leagueHandler->deleteLeague();
            $this->wpFlashMessages->queue_flash_message("bhaa_league_delete ".$leagueId);
            //error_log('bhaa_league_delete');
            wp_redirect($_SERVER['HTTP_REFERER']);
            exit();
        }
    }

    /**
     * Handle submit of the FORM
     * http://wordpress.stackexchange.com/questions/10500/how-do-i-best-handle-custom-plugin-page-actions
     */
    function bhaa_league_populate() {
        if(wp_verify_nonce($_GET['_wpnonce'],'bhaa_league_populate')) {

            $leagueId = $_GET['post_id'];
            $leagueHandler = $this->getLeagueHandler($leagueId);
            $leagueHandler->loadLeague();
            $this->wpFlashMessages->queue_flash_message("bhaa_league_populate ".$leagueId);
            //error_log('bhaa_league_populate');
            wp_redirect($_SERVER['HTTP_REFERER']);
            exit();
        }
    }

    function bhaa_league_top_ten() {
        if(wp_verify_nonce($_GET['_wpnonce'],'bhaa_league_top_ten')) {
            error_log('bhaa_league_top_ten');
            $leagueId = $_GET['post_id'];
            $leagueHandler = $this->getLeagueHandler($leagueId);
            $leagueHandler->exportLeagueTopTen();
            wp_redirect($_SERVER['HTTP_REFERER']);
            exit();
        }
    }

    private function getLeagueHandler($leagueid) {
        $type = get_post_meta($leagueid,LeagueCpt::BHAA_LEAGUE_TYPE,true);
        if($type=='I')
            return new IndividualLeague($leagueid);
        else
            return new TeamLeague($leagueid);
    }
}
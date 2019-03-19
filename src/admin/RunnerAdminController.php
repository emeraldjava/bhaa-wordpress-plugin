<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 16/03/2018
 * Time: 08:52
 */

namespace BHAA\admin;

use BHAA\core\runner\RunnerManager;
use BHAA\utils\Loadable;
use BHAA\utils\Loader;
use BHAA\core\runner\Runner;
use BHAA\core\runner\RunnerExpresso;

class RunnerAdminController extends AbstractAdminController implements Loadable {

    var $runnerManager;

    public function __construct() {
        parent::__construct();
        $this->runnerManager = new RunnerManager();
    }

    public function registerHooks(Loader $loader) {
        $loader->add_action('admin_menu',$this,'bhaa_admin_sub_menu');
        $loader->add_action('admin_action_bhaa_runner',$this,'bhaa_admin_runner');
        $loader->add_action('admin_action_bhaa_runner_renew_action',$this,'bhaa_runner_renew_action');
        $loader->add_action('admin_action_bhaa_runner_rename_action',$this,'bhaa_runner_rename_action');
        $loader->add_action('admin_action_bhaa_runner_email_action',$this,'bhaa_runner_email_action');
        $loader->add_action('admin_action_bhaa_runner_gender_action',$this,'bhaa_runner_gender_action');
        $loader->add_action('admin_action_bhaa_runner_dob_action',$this,'bhaa_runner_dob_action');
        $loader->add_action('admin_action_bhaa_runner_standard_action',$this,'bhaa_runner_standard_action');
        $loader->add_action('admin_action_bhaa_runner_status_action',$this,'bhaa_runner_status_action');
        $loader->add_action('admin_action_bhaa_runner_merge_action',$this,'bhaa_runner_merge_action');
        //add_action('admin_action_bhaa_runner_move_action',array($this,'bhaa_runner_move_action'));

        $loader->add_action('admin_action_bhaa_process_expresso_runners',$this,'bhaa_process_expresso_runners');
        $loader->add_action('admin_action_bhaa_process_expresso_runner',$this,'bhaa_process_expresso_runner');

        $loader->add_filter('user_row_actions',$this,'bhaa_user_row_actions_runner_link',10,2);
        $loader->add_filter('manage_users_columns',$this,'bhaa_manage_users_columns',10,3);
        $loader->add_filter('manage_users_custom_column',$this,'bhaa_manage_users_custom_column',10,3);
        $loader->add_filter('user_row_actions',$this,'bhaa_user_row_actions_runner_link',10,2);
    }

    public function bhaa_admin_sub_menu() {
        add_submenu_page('bhaa', 'BHAA Expresso Runners Admin', 'ExpressoRunners',
            'manage_options', 'bhaa_admin_runners', array($this, 'bhaa_admin_expresso_runners'));
        add_submenu_page(null, 'BHAA Runner Admin', 'Runner',
            'manage_options', 'bhaa_admin_runner', array($this, 'bhaa_admin_runner'));
        add_submenu_page(null, 'BHAA Runner Admin', 'Espresso',
            'manage_options', 'bhaa_process_expresso_runner', array($this, 'bhaa_process_expresso_runner'));

        add_submenu_page('bhaa', 'Fix Runners Meta', 'Runners Meta',
            'manage_options', 'bhaa_admin_runners_meta', array($this, 'bhaa_admin_runners_meta'));
    }

    public function bhaa_admin_expresso_runners() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $rows = $this->runnerManager->listEERegisteredRunners();
        include_once( 'partials/bhaa_admin_runners.php' );
    }

    function bhaa_process_expresso_runners() {
        //current_user_can('edit_users') &&
        error_log('bhaa_process_expresso_runners');
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_process_expresso_runners')) {
            $rows = $this->runnerManager->processEventExpressoRunners();
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_process_expresso_runner() {
        //current_user_can('edit_users') &&
        error_log('bhaa_process_expresso_runner');
        //if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_process_expresso_runner')) {

        $runnerExpresso = new RunnerExpresso();
        $runnerAndEvent = $runnerExpresso->getRunnerAndEventForRegistration(trim($_GET['url_link']));
        error_log('runner_id '.$runnerAndEvent['runner_id']);
        error_log('event_id  '.$runnerAndEvent['event_id']);

        $answers = $runnerExpresso->getBhaaAnswersForRegistration($_GET['re_id']);
        if(sizeof($answers)==3) {
            error_log('dob '.$answers[0]['ANS_value']);
            error_log('company '.$answers[1]['ANS_value']);
            error_log('gender '.$answers[2]['ANS_value']);

            $runnerManager = new RunnerManager();
            // use the values from the array and get the BHAA meta-data
            $runnerManager->setCustomBhaaMetaData($runnerAndEvent['runner_id'],$answers[0]['ANS_value'],$answers[1]['ANS_value'],$answers[2]['ANS_value']);
            if($runnerAndEvent['event_id']=6907) {
                $runnerManager->renew($runnerAndEvent['runner_id']);
            }

        } else {
            error_log("No answers");
        }
        error_log('bhaa_process_expresso_runner');
        $this->bhaa_admin_expresso_runners();
    }

    function bhaa_admin_runners_meta() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $xx = new RunnerUserListTable();
        echo $xx->table();
    }

    public function bhaa_admin_runner() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $runner = new Runner($_REQUEST['id']);
        if($runner->getID()!=null)
            $matchedRunners = $this->runnerManager->findMatchingRunners($_REQUEST['id']);
        include_once( 'partials/bhaa_admin_runner.php' );
    }

    function bhaa_runner_renew_action() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_renew_action')) {
            $this->runnerManager->renew($_POST['id']);
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_rename_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_rename_action')) {
            $first_name = $_POST['first_name'];
            wp_update_user( array ( 'ID' => $_POST['id'], 'first_name' => $first_name ) ) ;
            $last_name = $_POST['last_name'];
            wp_update_user( array ( 'ID' => $_POST['id'], 'last_name' => $last_name ) ) ;
            wp_update_user( array ('ID' => $_POST['id'], 'display_name' => $first_name." ".$last_name));
            wp_update_user( array ('ID' => $_POST['id'], 'user_nicename' =>  $first_name."-".$last_name));
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_gender_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_gender_action')) {
            update_user_meta($_POST['id'],'bhaa_runner_gender',trim($_POST['gender']));
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_dob_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_dob_action')) {
            error_log('bhaa_runner_dob_action '.$_POST['id'].' -> '.$_POST['dob']);
            update_user_meta($_POST['id'],'bhaa_runner_dateofbirth',trim($_POST['dob']));
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_standard_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_standard_action')) {
            update_user_meta($_POST['id'],'bhaa_runner_standard',trim($_POST['standard']));
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_status_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_status_action')) {
            update_user_meta($_POST['id'],'bhaa_runner_status',trim($_POST['status']));
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_user_row_actions_runner_link( $actions, $user ) {
        if ( current_user_can('manage_options') ) {
            $actions['bhaa_runner_view'] =
                sprintf('<a target="_new" href="./admin.php?page=bhaa_admin_runner&id='.$user->ID.'">Runner</a>');
        }
        return $actions;
    }

    function bhaa_runner_email_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_email_action')) {
            error_log('bhaa_runner_email_action '.$_POST['id'].' -> '.$_POST['email']);
            wp_update_user( array ( 'ID' => $_POST['id'], 'user_email' => trim($_POST['email']) ) ) ;
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_merge_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_merge_action')) {
            $this->runnerManager->mergeRunner($_POST['id'],$_POST['delete']);
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_runner_move_action() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_merge_action')) {
            error_log('bhaa_runner_move_action');
            //$nextRunnerId = RunnerAdmin::get_instance()->getNextRunnerId();
            //$this->mergeRunner($nextRunnerId,$_GET['delete'],true);
        }
        //wp_redirect(home_url().'/runner/?id='.$nextRunnerId);
        exit();
    }

    /**
     * via - https://code.tutsplus.com/articles/quick-tip-make-your-custom-column-sortable--wp-25095
     */
    function bhaa_order_users_by_column( $query ) {
        global $pagenow;
        if ( ! is_admin() || 'users.php' !== $pagenow ) {
            return;
        }
        if( 'Status' == $query->get('orderby') ) {
            $query->set('meta_key',Runner::BHAA_RUNNER_STATUS);
            $meta_query = array(
                array(
                    'key' => Runner::BHAA_RUNNER_STATUS,
                    'value' => 'M'//'meta_value'
                )
            );
            //$query->set('meta_compare','LIKE');
            $query->set( 'meta_query', $meta_query);
            //error_log('RunnerAdminController.bhaa_order_users_by_column '.var_dump($query));
        }
    }

    function bhaa_manage_users_columns( $column ) {
        //error_log('RunnerAdminController.bhaa_manage_users_columns');
        unset($column['posts']);
        //unset($column['role']);
        $column[Runner::BHAA_RUNNER_STATUS] = __('Status', Runner::BHAA_RUNNER_STATUS);
        $column[Runner::BHAA_RUNNER_GENDER] = __('Gender', Runner::BHAA_RUNNER_GENDER);
        //$column[Runner::BHAA_RUNNER_DATEOFRENEWAL] = __('Renewal', Runner::BHAA_RUNNER_DATEOFRENEWAL);
        $column[Runner::BHAA_RUNNER_DATEOFBIRTH] = __('DoB', Runner::BHAA_RUNNER_DATEOFBIRTH);
        //$column[Runner::BHAA_RUNNER_COMPANY] = __('Company', Runner::BHAA_RUNNER_COMPANY);
        //$column[Connections::HOUSE_TO_RUNNER] = __('Team', Connections::HOUSE_TO_RUNNER);
        //$column[Connections::SECTORTEAM_TO_RUNNER] = __('SectorTeam', Connections::SECTORTEAM_TO_RUNNER);
        return $column;
    }

    function bhaa_manage_users_custom_column( $val, $column_name, $user_id ) {
        $user = get_userdata( $user_id );
        switch ($column_name) {
            case Runner::BHAA_RUNNER_STATUS:
                return get_user_meta($user_id,Runner::BHAA_RUNNER_STATUS,true);
                break;
            case Runner::BHAA_RUNNER_GENDER:
                return get_user_meta($user_id,Runner::BHAA_RUNNER_GENDER,true);
                break;
//            case Runner::BHAA_RUNNER_DATEOFRENEWAL:
//                return get_user_meta($user_id,Runner::BHAA_RUNNER_DATEOFRENEWAL,true);
//                break;
            case Runner::BHAA_RUNNER_DATEOFBIRTH:
                return get_user_meta($user_id,Runner::BHAA_RUNNER_DATEOFBIRTH,true);
                break;
//            case Runner::BHAA_RUNNER_COMPANY:
//                $company = get_user_meta($user_id,Runner::BHAA_RUNNER_COMPANY,true);
//                if(isset($company))
//                    return sprintf('<a target="_new" href="%s">%s</a>',get_edit_post_link($company),get_the_title($company));
//                else
//                    return get_the_title($company);
//                //return post_permalink(get_user_meta($user_id,Runner::BHAA_RUNNER_COMPANY,true));
//                //return get_user_meta($user_id,Runner::BHAA_RUNNER_COMPANY,true);
//                break;
//            case Connections::HOUSE_TO_RUNNER:
//                $team = p2p_get_connections(Connections::HOUSE_TO_RUNNER,array('to'=>$user_id));
//                //var_dump( $teams );
//                if(sizeof($team)==1)
//                    return sprintf('<a target="_new" href="%s">%s</a>',get_edit_post_link($team[0]->p2p_from),get_the_title($team[0]->p2p_from));
//                else
//                    return 'N/A';
//            case Connections::SECTORTEAM_TO_RUNNER :
//                $sectorTeam = p2p_get_connections(Connections::SECTORTEAM_TO_RUNNER,array('to'=>$user_id));
//                //var_dump( get_edit_post_link($sectorTeam[0]->p2p_from) );
//                if(sizeof($sectorTeam)==1)
//                    return sprintf('<a target="_new" href="%s">%s</a>',get_edit_post_link($sectorTeam[0]->p2p_from),get_the_title($sectorTeam[0]->p2p_from));
//                else
//                    return 'N/A';
//                break;
            default:
        }
        return '';
    }
}
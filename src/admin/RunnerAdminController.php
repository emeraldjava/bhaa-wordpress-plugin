<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 16/03/2018
 * Time: 08:52
 */

namespace BHAA\admin;

use BHAA\admin\manager\RunnerManager;
use BHAA\utils\Actionable;
use BHAA\utils\Filterable;
use BHAA\front\runner\Runner;
use BHAA\front\connections\Connections;

class RunnerAdminController implements Filterable, Actionable {

    private $runnerManager;

    public function __construct() {
        $this->runnerAdminMessage = '';
    }

    public function get_filters() {
        //error_log('RunnerAdminController.get_filters');
        return array(
            'manage_users_columns' => 'bhaa_manage_users_columns',
            'manage_users_custom_column' => array('bhaa_manage_users_custom_column',10,3),
            //'manage_users_sortable_columns' => 'bhaa_manage_users_sortable_column'
            //'user_row_actions' => array('bhaa_user_row_actions_runner_link',10,2)
        );
    }

    public function get_actions() {
        return array(
            'admin_menu' => 'bhaa_admin_sub_menu',
            'admin_action_bhaa_runner_assign_to_role'=>'bhaa_runner_assign_to_role'
        );
    }

    public function bhaa_admin_sub_menu() {
        add_submenu_page('bhaa', 'BHAA Runner Admin', 'Runner',
            'manage_options', 'bhaa_admin_runner', array($this, 'bhaa_admin_runner'));
    }

    public function bhaa_admin_runner() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $runnerManager = new RunnerManager();
        include_once( 'partials/bhaa_admin_runners.php' );
    }

    function bhaa_runner_assign_to_role() {
        if(wp_verify_nonce($_REQUEST['_wpnonce'], 'bhaa_runner_assign_to_role')) {
            error_log("bhaa_runner_assign_to_role :: ".$_REQUEST['members']);
        }
        wp_redirect(wp_get_referer());
        exit();
    }

    function bhaa_manage_users_sortable_column( $columns ) {
        $column[Runner::BHAA_RUNNER_STATUS] = __('Status', Runner::BHAA_RUNNER_STATUS);
        return $column;
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
        //$column[Runner::BHAA_RUNNER_DATEOFBIRTH] = __('DoB', Runner::BHAA_RUNNER_DATEOFBIRTH);
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
//            case Runner::BHAA_RUNNER_DATEOFBIRTH:
//                return get_user_meta($user_id,Runner::BHAA_RUNNER_DATEOFBIRTH,true);
//                break;
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

    function bhaa_user_row_actions_runner_link( $actions, $user ) {
        if ( current_user_can('manage_options') ) {
            $actions['bhaa_runner_view'] = '<a target="_new" href="/runner/?id='.$user->ID.'">Runner</a>';
        }
        return $actions;
    }

    function setRunnerManager(RunnerManager $runnerManager){
        $this->runnerManager=$runnerManager;
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:13
 */

namespace BHAA\admin;

use BHAA\core\runner\RunnerManager;
use BHAA\utils\Loadable;
use BHAA\utils\Loader;
use League\Csv\Writer;
use SplTempFileObject;
use Michelf\Markdown;

class AdminController extends AbstractAdminController implements Loadable {

    /**
     * The ID of this plugin.
     */
    private $plugin_name;

    /**
     * The version of this plugin.
     */
    private $version;

    /**
     * Initialize the class and set its properties.
     */
    public function __construct( $plugin_name, $version ) {
        parent::__construct();
        $this->plugin_name = $plugin_name;
        $this->version = $version;
    }

    public function registerHooks(Loader $loader) {
        $loader->add_action('admin_enqueue_scripts',$this,'bhaa_admin_enqueue_styles');
        $loader->add_action('admin_enqueue_scripts',$this,'bhaa_admin_enqueue_scripts');
        $loader->add_action('admin_menu',$this,'bhaa_admin_menu');
        $loader->add_action('admin_action_bhaa_export_members',$this,'bhaa_export_members');
        $loader->add_action('admin_action_bhaa_registrar_export_members',$this,'bhaa_registrar_export_members');
        $loader->add_action('admin_action_bhaa_registrar_export_inactive_members',$this,'bhaa_registrar_export_inactive_members');
        $loader->add_action('admin_action_bhaa_registrar_export_day_members',$this,'bhaa_registrar_export_day_members');
        $loader->add_action('admin_action_bhaa_registrar_export_online',$this,'bhaa_registrar_export_online');
        $loader->add_action('admin_action_bhaa_registrar_export_new_online_members',$this,'bhaa_registrar_export_new_online_members');

        $loader->add_action('admin_notices', $this->wpFlashMessages, 'show_flash_messages');
    }

    function bhaa_export_members() {
        error_log('bhaa_export_members');
        $runnerManager = new RunnerManager();
        $user_query = $runnerManager->getMembers();
        include_once('partials/bhaa_admin_runners.php');
        wp_redirect( $_SERVER['HTTP_REFERER'] );
        exit();
    }

    function bhaa_admin_menu() {
        add_menu_page('BHAA Admin Page', 'BHAA',
            'manage_options', 'bhaa', array($this, 'bhaa_admin_main'));
        add_submenu_page('bhaa', 'BHAA Help', 'Help',
            'manage_options', 'bhaa_admin_help', array($this, 'bhaa_admin_help'));
    }

    function bhaa_admin_main() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $exportBHAAMembersLink = $this->generate_admin_url_link('Export BHAA Members','bhaa_registrar_export_members');
        $exportBHAAInactiveMembersLink = $this->generate_admin_url_link('Export Inactive Members','bhaa_registrar_export_inactive_members');
        $exportBHAADayMembersLink = $this->generate_admin_url_link('Export Day Members','bhaa_registrar_export_day_members');
        $exportEventMembersLink = $this->generate_admin_url_link('Export Pre-Registered Online Members','bhaa_registrar_export_online');

        $exportNewBHAAMembersLink = $this->generate_admin_url_link('Export New Online BHAA Members','bhaa_registrar_export_new_online_members');
        include_once( 'partials/bhaa_admin_main.php' );
    }

    /**
     * Export the existing members
     */
    function bhaa_registrar_export_members() {
        $runnerManager = new RunnerManager();
        $bhaaMembers = $runnerManager->getBHAAMembers();
        // https://csv.thephpleague.com/9.0/connections/output/
        // https://mattstauffer.com/blog/export-an-eloquent-collection-to-a-csv-with-league-csv/
        $csv = Writer::createFromFileObject(new SplTempFileObject());
        foreach ($bhaaMembers as $runner) {
            $csv->insertOne($runner);
        }
        $csv->output('bhaa.members.'.date("y.m.d-H.m.s").'.csv');
        die;
    }

    function bhaa_registrar_export_inactive_members() {
        $runnerManager = new RunnerManager();
        $bhaaMembers = $runnerManager->getBHAAMembers("I");
        $csv = Writer::createFromFileObject(new SplTempFileObject());
        foreach ($bhaaMembers as $runner) {
            $csv->insertOne($runner);
        }
        $csv->output('bhaa.inactive.'.date("y.m.d-H.m.s").'.csv');
        die;
    }

    function bhaa_registrar_export_day_members() {
        $runnerManager = new RunnerManager();
        $bhaaMembers = $runnerManager->getBHAAMembers("D");
        $csv = Writer::createFromFileObject(new SplTempFileObject());
        foreach ($bhaaMembers as $runner) {
            $csv->insertOne($runner);
        }
        $csv->output('bhaa.day.'.date("y.m.d-H.m.s").'.csv');
        die;
    }

    function bhaa_registrar_export_online() {
        $runnerManager = new RunnerManager();
        $nextEvent = $runnerManager->getNextEventId();
        $eventPost = get_post( $nextEvent[0] );
        $registeredOnline = $runnerManager->getEventOnlineMembers($nextEvent[0]);
        $csv = Writer::createFromFileObject(new SplTempFileObject());
        foreach ($registeredOnline as $runner) {
            $csv->insertOne($runner);
        }
        $csv->output('bhaa.online.'.$eventPost->post_name.'.'.date("y.m.d-H.m.s").'.csv');
        die;
    }

    function bhaa_registrar_export_new_online_members(){
        $runnerManager = new RunnerManager();
        $registeredOnline = $runnerManager->getNewOnlineBHAAMembers();
        $csv = Writer::createFromFileObject(new SplTempFileObject());
        foreach ($registeredOnline as $runner) {
            $csv->insertOne($runner);
        }
        $csv->output('bhaa.new.online.members.'.date("y.m.d-H.m.s").'.csv');
        die;
    }

    private function generate_admin_url_link($name,$action) {
        $nonce = wp_create_nonce( $action );
        $link = admin_url('admin.php?action='.$action);
        return '<a href='.$link.'>'.$name.'</a>';
    }

    /**
     * Register the stylesheets for the admin area.
     */
    public function bhaa_admin_enqueue_styles() {
        //error_log(plugin_dir_url( __FILE__ ) . 'css/bhaa_wordpress_plugin-admin.css');
        wp_enqueue_style( $this->plugin_name.'_admin_css',
            plugin_dir_url( __FILE__ ) . 'css/bhaa_wordpress_plugin-admin.css',
            array(), $this->version, 'all' );
        // CSS
        wp_register_style('prefix_bootstrap', '//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css');
        wp_enqueue_style('prefix_bootstrap');
    }

    /**
     * Register the JavaScript for the admin area.
     */
    public function bhaa_admin_enqueue_scripts() {
        //error_log(plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-admin.js');
        wp_enqueue_script( $this->plugin_name.'_admin_js',
            plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-admin.js',
            array( 'jquery' ), $this->version, false );
        // JS
        //wp_register_script('prefix_bootstrap', '//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js');
        //wp_enqueue_script('prefix_bootstrap');
    }

    public function bhaa_admin_help() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        include_once( 'partials/bhaa_help.php' );
    }
}
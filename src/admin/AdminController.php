<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:13
 */

namespace BHAA\admin;

use BHAA\core\runner\RunnerManager;
use BHAA\utils\Actionable;

use League\Csv\Writer;
use SplTempFileObject;

class AdminController implements Actionable {

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
        $this->plugin_name = $plugin_name;
        $this->version = $version;
        add_action('admin_enqueue_scripts', array($this,'bhaa_admin_enqueue_styles'));
        add_action('admin_enqueue_scripts', array($this,'bhaa_admin_enqueue_scripts'));
    }

    /**
     * Was
     *     $this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_styles' );
     *     $this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_scripts' );
     * in the Main class
     * @return array
     *
     */
    public function get_actions() {
        return array(
            'admin_menu' => 'bhaa_admin_menu',
            'admin_action_bhaa_export_members' => 'bhaa_export_members',
            'admin_action_bhaa_registrar_export_members' => 'bhaa_registrar_export_members'
        );
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
    }

    function bhaa_admin_main() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        $exportMembersLink = $this->generate_admin_url_link('Export Members','bhaa_registrar_export_members');
        include_once( 'partials/bhaa_admin_main.php' );
    }

    /**
     * Export the existing members
     */
    function bhaa_registrar_export_members() {
        $runnerManager = new RunnerManager();
        $user_query = $runnerManager->getMembers();

        // https://csv.thephpleague.com/9.0/connections/output/
        // https://mattstauffer.com/blog/export-an-eloquent-collection-to-a-csv-with-league-csv/
        $csv = Writer::createFromFileObject(new SplTempFileObject());
        foreach ($user_query as $person) {
            $csv->insertOne($person);
        }
        $csv->output('bhaa-members.'.date("y.m.d-H.m.s").'.csv');
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
    }

    /**
     * Register the JavaScript for the admin area.
     */
    public function bhaa_admin_enqueue_scripts() {
        //error_log(plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-admin.js');
        wp_enqueue_script( $this->plugin_name.'_admin_js',
            plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-admin.js',
            array( 'jquery' ), $this->version, false );
    }
}
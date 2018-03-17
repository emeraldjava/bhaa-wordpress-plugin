<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:13
 */

namespace BHAA\admin;

use BHAA\utils\Actionable;

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
            'admin_enqueue_scripts' => 'enqueue_styles',
            'admin_enqueue_scripts' => 'enqueue_scripts',
            'admin_menu' => 'bhaa_admin_menu'
        );
    }

    public function bhaa_admin_menu() {
        add_menu_page('BHAA Admin Menu Title', 'BHAA',
            'manage_options', 'bhaa', array(&$this, 'bhaa_admin_main'));
    }

    function bhaa_admin_main() {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        include_once( 'partials/bhaa_admin_main.php' );
    }

    /**
     * Register the stylesheets for the admin area.
     */
    public function enqueue_styles() {
        wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/plugin-name-admin.css', array(), $this->version, 'all' );
    }

    /**
     * Register the JavaScript for the admin area.
     */
    public function enqueue_scripts() {
        wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/plugin-name-admin.js', array( 'jquery' ), $this->version, false );
    }
}
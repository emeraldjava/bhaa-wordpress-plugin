<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:14
 */

namespace BHAA\front;

use BHAA\utils\Actionable;

class Controller implements Actionable {

    private $plugin_name;
    private $version;

    /**
     * Initialize the class and set its properties.
     */
    public function __construct( $plugin_name, $version ) {
        $this->plugin_name = $plugin_name;
        $this->version = $version;
        add_action('wp_enqueue_scripts', array($this,'bhaa_enqueue_styles'));
        add_action('wp_enqueue_scripts', array($this,'bhaa_enqueue_scripts'));
    }

    public function get_actions() {
        return array();
    }

    /**
     * Register the stylesheets for the public-facing side of the site.
     */
    public function bhaa_enqueue_styles() {
        //error_log(plugin_dir_url( __FILE__ ) . 'css/bhaa_wordpress_plugin-public.css');
        wp_enqueue_style( $this->plugin_name.'_css', plugin_dir_url( __FILE__ ) . 'css/bhaa_wordpress_plugin-public.css', array(), $this->version, 'all' );
    }

    /**
     * Register the stylesheets for the public-facing side of the site.
     */
    public function bhaa_enqueue_scripts() {
        //error_log(plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-public.js');
        wp_enqueue_script( $this->plugin_name.'_js', plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-public.js', array( 'jquery' ), $this->version, false );
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:14
 */

namespace BHAA\front;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;

class Controller implements Loadable {

    private $plugin_name;
    private $version;

    /**
     * Initialize the class and set its properties.
     */
    public function __construct( $plugin_name, $version ) {
        $this->plugin_name = $plugin_name;
        $this->version = $version;
    }

    public function registerHooks(Loader $loader) {
        $loader->add_action('wp_enqueue_scripts',$this,'bhaa_enqueue_styles');
        $loader->add_action('wp_enqueue_scripts',$this,'bhaa_enqueue_scripts');
        $loader->add_action('login_head', $this,'bhaa_login_head');

        $loader->add_filter('login_headerurl',$this,'bhaa_login_headerurl');
        $loader->add_filter('login_headertitle',$this,'bhaa_login_headertitle');
        $loader->add_filter('login_redirect', $this,'bhaa_login_redirect', 10, 3 );
    }

    /**
     * Redirect non-admins to the homepage after logging into the site
     * See https://tommcfarlin.com/redirect-non-admin/
     * @since 	1.0
     */
    function bhaa_login_redirect( $redirect_to, $request, $user  ) {
        return (isset($user->roles) && is_array($user->roles) && in_array('administrator', $user->roles)) ? admin_url() : site_url();
    }

    function bhaa_login_head() {
        echo '<style>
            body.login #login h1 a {
            background: url('.plugin_dir_url(__FILE__).'/img/bhaa_logo_transparent.png) no-repeat center top transparent;
            height: 120px;
            width: 200px;
        }</style>';
    }

    function bhaa_login_headerurl( $url ) {
        return get_bloginfo( 'url' );
    }

    function bhaa_login_headertitle() {
        return 'BHAA - For runners, by runners!';
    }

    /**
     * Register the stylesheets for the public-facing side of the site.
     */
    public function bhaa_enqueue_styles() {
        //error_log(plugin_dir_url( __FILE__ ) . 'css/bhaa_wordpress_plugin-public.css');
        wp_enqueue_style( $this->plugin_name.'_css', plugin_dir_url( __FILE__ ) . 'css/bhaa_wordpress_plugin-public.css', array(), $this->version, 'all' );
        // JS
        wp_register_script('prefix_bootstrap', '//maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js');
        wp_enqueue_script('prefix_bootstrap');
    }

    /**
     * Register the stylesheets for the public-facing side of the site.
     */
    public function bhaa_enqueue_scripts() {
        //error_log(plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-public.js');
        wp_enqueue_script( $this->plugin_name.'_js', plugin_dir_url( __FILE__ ) . 'js/bhaa_wordpress_plugin-public.js', array( 'jquery' ), $this->version, false );
        // CSS
        wp_register_style('prefix_bootstrap', '//maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css');
        wp_enqueue_style('prefix_bootstrap');
    }
}
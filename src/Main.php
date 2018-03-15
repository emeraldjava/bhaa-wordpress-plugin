<?php
namespace BHAA;
/**
 * The core plugin class.
 *
 * This is used to define internationalization, admin-specific hooks, and
 * public-facing site hooks.
 *
 * Also maintains the unique identifier of this plugin as well as the current
 * version of the plugin.
 */
class Main {
    /**
     * The loader that's responsible for maintaining and registering all hooks that power the plugin.
     */
    protected $loader;
    /**
     * The unique identifier of this plugin.
     */
    protected $plugin_name;
    /**
     * The current version of the plugin.
     */
    protected $version;

    protected $leagueCpt;
    /**
     * Define the core functionality of the plugin.
     *
     * Set the plugin name and the plugin version that can be used throughout the plugin.
     * Load the dependencies, define the locale, and set the hooks for the admin area and
     * the public-facing side of the site.
     */
    public function __construct() {
        $this->plugin_name = 'bhaa_wordpress_plugin';
        $this->version = '1.0.0';
        $this->loader = new utils\Loader();

        $this->leagueCpt = new front\cpt\LeagueCPT();

        $this->set_locale();
        $this->define_admin_hooks();
        $this->define_public_hooks();
    }
    /**
     * Define the locale for this plugin for internationalization.
     * Uses the Internationalization class in order to set the domain and to register the hook with WordPress.
     */
    private function set_locale() {
        $plugin_i18n = new utils\Internationalization();
        $plugin_i18n->set_domain( $this->get_plugin_name() );
        $this->loader->add_action( 'plugins_loaded', $plugin_i18n, 'load_plugin_textdomain' );
    }
    /**
     * Register all of the hooks related to the admin area functionality of the plugin.
     */
    private function define_admin_hooks() {
        $plugin_admin = new admin\AdminController( $this->get_plugin_name(), $this->get_version() );
        $this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_styles' );
        $this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_scripts' );

        // register the league admins hook
        $this->loader->add_action('admin_menu', $this->leagueCpt,'bhaa_league_populate_metabox');
        $this->loader->add_action('admin_action_bhaa_league_delete',$this->leagueCpt,'bhaa_league_delete');
        $this->loader->add_action('admin_action_bhaa_league_populate',$this->leagueCpt,'bhaa_league_populate');
        $this->loader->add_action('admin_action_bhaa_league_top_ten',$this->leagueCpt,'bhaa_league_top_ten');
    }
    /**
     * Register all of the hooks related to the public-facing functionality of the plugin.
     */
    private function define_public_hooks() {
        $plugin_public = new front\Controller( $this->get_plugin_name(), $this->get_version() );
        $this->loader->add_action('wp_enqueue_scripts', $plugin_public, 'enqueue_styles' );
        $this->loader->add_action('wp_enqueue_scripts', $plugin_public, 'enqueue_scripts' );

        // league CPT hooks and filters
        $this->loader->add_action('init', $this->leagueCpt,'registerLeagueCPT');
        $this->loader->add_action('add_meta_boxes', $this->leagueCpt, 'bhaa_league_meta_data');
        $this->loader->add_action('save_post', $this->leagueCpt,'bhaa_league_save_meta_data');
        $this->loader->add_filter('post_row_actions', $this->leagueCpt,'bhaa_league_post_row_actions',0,2);
        $this->loader->add_filter('single_template', $this->leagueCpt,'bhaa_single_league_template');
    }
    /**
     * Run the loader to execute all of the hooks with WordPress.
     */
    public function run() {
        $this->loader->run();
    }
    /**
     * The name of the plugin used to uniquely identify it within the context of
     * WordPress and to define internationalization functionality.
     */
    public function get_plugin_name() {
        return $this->plugin_name;
    }
    /**
     * The reference to the class that orchestrates the hooks with the plugin.
     */
    public function get_loader() {
        return $this->loader;
    }
    /**
     * Retrieve the version number of the plugin.
     */
    public function get_version() {
        return $this->version;
    }
}
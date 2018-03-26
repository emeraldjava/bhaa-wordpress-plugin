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
        $this->set_locale();

        // register the front
        $this->loader->register(new front\Controller( $this->get_plugin_name(), $this->get_version()));

        // register the BHAA objects with support actions and filters.
        $this->loader->register(new admin\AdminController( $this->get_plugin_name(), $this->get_version()));
        //$this->loader->register(new admin\RunnerAdminController());

        // register the core objects
        $this->loader->register(new core\cpt\EventCPT());
        $this->loader->register(new core\cpt\RaceCPT());
        $this->loader->register(new core\cpt\LeagueCPT());

    }
    /**
     * Define the locale for this plugin for internationalization.
     * Uses the Internationalization class in order to set the domain and to register the hook with WordPress.
     */
    private function set_locale() {
        $plugin_i18n = new utils\Internationalization();
        $plugin_i18n->set_domain( $this->get_plugin_name() );
        $this->loader->register($plugin_i18n);
    }

    /**
     * Run the loader to execute all of the hooks with WordPress.
     */
    public function run() {
        $this->loader->loadActionsAndFilters();
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
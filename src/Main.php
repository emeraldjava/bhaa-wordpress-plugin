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
    public function __construct($version) {
        $this->plugin_name = 'bhaa_wordpress_plugin';
        $this->version = $version;
        $this->loader = new utils\Loader();
        $this->set_locale();
    }

    function registerObjects() {
        // register the front
        $controller = new front\Controller( $this->get_plugin_name(), $this->get_version());
        $controller->registerHooks($this->loader);

        // register the BHAA objects with support actions and filters.
        if(is_admin()) {
            $adminController = new admin\AdminController($this->get_plugin_name(), $this->get_version());
            $adminController->registerHooks($this->loader);
            $runnerAdminController = new admin\RunnerAdminController();
            $runnerAdminController->registerHooks($this->loader);
            $raceAdminController = new admin\RaceAdminController();
            $raceAdminController->registerHooks($this->loader);
            $leagueAdminController = new admin\LeagueAdminController();
            $leagueAdminController->registerHooks($this->loader);
            $registrarAdminController = new admin\RegistrarAdminController();
            $registrarAdminController->registerHooks($this->loader);
        }

        // register the core objects
        $raceCpt = new core\cpt\RaceCPT();
        $raceCpt->registerHooks($this->loader);
        $houseCpt = new core\cpt\HouseCPT();
        $houseCpt->registerHooks($this->loader);
        $leagueCpt = new core\cpt\LeagueCPT();
        $leagueCpt->registerHooks($this->loader);
        $connections = new core\Connections();
        $connections->registerHooks($this->loader);
        $eventExpresso = new core\eventexpresso\EventExpresso();
        $eventExpresso->registerHooks($this->loader);

        new core\standard\StandardShortcode();
        new core\race\RaceShortcode();
        new core\league\LeagueShortcode();
        new core\runner\RunnerShortcode();
        $resultsShortcode = new core\results\ResultsShortcode();
        $resultsShortcode->registerHooks($this->loader);
    }
    /**
     * Define the locale for this plugin for internationalization.
     * Uses the Internationalization class in order to set the domain and to register the hook with WordPress.
     */
    private function set_locale() {
        $plugin_i18n = new utils\Internationalization();
        $plugin_i18n->set_domain( $this->get_plugin_name() );
        $plugin_i18n->registerHooks($this->loader);
    }

    /**
     * Run the loader to execute all of the hooks with WordPress.
     */
    public function run() {
        $this->registerObjects();
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
     * Retrieve the version number of the plugin.
     */
    public function get_version() {
        return $this->version;
    }
}
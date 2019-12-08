<?php
/**
 * @package           bhaa-wordpress-plugin
 *
 * @wordpress-plugin
 * Plugin Name:       BHAA Wordpress Plugin
 * Plugin URI:        https://github.com/emeraldjava/bhaa-wordpress-plugin
 * Description:       Plugin for the Business House Athletic Association. Handles user registration, race results and leagues.
 * Version:           2019.12.08
 * Author:            emeraldjava
 * Author URI:        https://github.com/emeraldjava
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       BHAA Wordpress Plugin
 * Domain Path:       /languages
 * GitHub Plugin URI: https://github.com/emeraldjava/bhaa-wordpress-plugin
 * Release Asset:     true
 */

namespace BHAA;

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
    die;
}

require_once plugin_dir_path( __FILE__ ) . 'vendor/autoload.php';

/**
 * Currently plugin version.
 */
define( 'BHAA-WORDPRESS-PLUGIN-VERSION', '2019.12.08' );
/**
 * The code that runs during plugin activation.
 * This action is documented in includes/class-plugin-name-activator.php
 */
function activate_plugin_name() {
    utils\Activator::activate();
}
/**
 * The code that runs during plugin deactivation.
 * This action is documented in includes/class-plugin-name-deactivator.php
 */
function deactivate_plugin_name() {
    utils\Deactivator::deactivate();
}
register_activation_hook( __FILE__, '\BHAA\activate_plugin_name' );
register_deactivation_hook( __FILE__, '\BHAA\deactivate_plugin_name' );

/**
 * Begins execution of the plugin.
 * https://wppb.me/
 * https://wordpress.stackexchange.com/questions/70055/best-way-to-initiate-a-class-in-a-wp-plugin
 */
function runBhaaWordpressPlugin() {
    $plugin = new Main(BHAA-WORDPRESS-PLUGIN-VERSION);
    $plugin->run();
}
runBhaaWordpressPlugin();

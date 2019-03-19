<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 19/03/19
 * Time: 21:59
 */

namespace BHAA\admin;

if(!class_exists('WP_Users_List_Table')) {
    require_once( ABSPATH . 'wp-admin/includes/screen.php' );
    require_once( ABSPATH . 'wp-admin/includes/class-wp-users-list-table.php' );
}

use WP_Users_List_Table;

/**
 * Class RunnerUserListTable
 * @package BHAA\admin
 * https://www.sitepoint.com/using-wp_list_table-to-create-wordpress-admin-tables/
 * https://www.ursart.com/view-list-of-unapproved-wordpressbuddypress-users/
 * http://hookr.io/classes/bp_members_list_table/
 */
class RunnerUserListTable extends WP_Users_List_Table
{

    public function __construct() {
        // Define singular and plural labels, as well as whether we support AJAX.
        parent::__construct( array(
            'ajax' => false,
            'plural' => 'metadata',
            'singular' => 'metadata',
            'screen' => get_current_screen()->id,
        ) );
    }

    function prepare_items()
    {
        $columns = $this->get_columns();
        $hidden = array();
        $sortable = array();
        $this->_column_headers = array($columns, $hidden, $sortable);

        global $wpdb;
        $query = "SELECT * FROM wp_users WHERE ID=7713";
        $totalitems = $wpdb->query($query);
        $this->items = $wpdb->get_results($query,ARRAY_A);
    }

    function table()
    {
        if ( !current_user_can( 'manage_options' ) )  {
            wp_die( __( 'You do not have sufficient permissions to access this page.' ) );
        }
        echo '<div class="wrap"><h2>BHAA Runner MetaData Admin Page</h2>';
        $this->prepare_items();
        $this->display();
        echo '</div>';
    }
}

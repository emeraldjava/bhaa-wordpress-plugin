<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/03/2018
 * Time: 17:30
 */

namespace BHAA\core\cpt;

use BHAA\utils\Actionable;
use BHAA\utils\Filterable;

class LeagueCPT implements Actionable, Filterable {

    const BHAA_LEAGUE_RACES_TO_SCORE = 'races_to_score';
    const BHAA_LEAGUE_TYPE = 'bhaa_league_type';

    public function get_actions() {
        return array(
            'init' => 'bhaa_register_league_cpt',
            'add_meta_boxes' => 'bhaa_league_meta_data',
            'save_post' => 'bhaa_league_save_meta_data',
            'admin_menu' => 'bhaa_league_populate_metabox'
        );
    }

    public function get_filters() {
        return array(
            'post_row_actions' => array('bhaa_league_post_row_actions',0,2),
            'single_template' => 'bhaa_cpt_league_single_template'
        );
    }

    function bhaa_league_populate_metabox() {
        add_meta_box(
            'bhaa_league_populate',
            'League Actions',
            array(&$this, 'bhaa_league_populate_fields'),
            'league',
            'side',
            'high'
        );
    }

    function bhaa_league_populate_fields() {
        global $post;
        echo implode('<br/>', $this->get_admin_url_links($post));
    }

    /**
     * http://wordpress.stackexchange.com/questions/17385/custom-post-type-templates-from-plugin-folder
     */
    function bhaa_cpt_league_single_template($template) {
        global $wp_query, $post;
        /* Checks for single template by post type */
        if ($post->post_type == "league") {
            // check the type and redirect to a template
            $type = get_post_meta($post->ID,'bhaa_league_type',true);
            // check if this is a division sub-query
            if(isset($wp_query->query_vars['division'])) {
                $division = urldecode($wp_query->query_vars['division']);
                return  plugin_dir_path(__FILE__) . '/partials/league/single-league-division.php';
            } else {
                //if($type=='T')
                //    return plugin_dir_path(__FILE__) . '/partials/league/single-league-team.php';
                //else
                    return plugin_dir_path(__FILE__) . '/partials/league/single-league-individual.php';
            }
        }
        return $template;
    }

    public function bhaa_league_meta_data() {
        add_meta_box(
            'bhaa_league_meta',
            __( 'League Details', 'bhaa_league_meta' ),
            array(&$this,'bhaa_league_meta_data_fields'),
            'league',
            'side',
            'high'
        );
    }

    function bhaa_league_meta_data_fields( $post ) {
        //wp_nonce_field( plugin_basename( __FILE__ ), 'bhaa_race_meta_data' );

        $races_to_score = get_post_custom_values(LeagueCpt::BHAA_LEAGUE_RACES_TO_SCORE, $post->ID);
        echo '<p>Races To Score <input type="text" name='.LeagueCpt::BHAA_LEAGUE_RACES_TO_SCORE.' value="'.$races_to_score[0].'" /></p>';

        // http://stackoverflow.com/questions/3507042/if-block-inside-echo-statement
        $type = get_post_custom_values(LeagueCpt::BHAA_LEAGUE_TYPE, $post->ID);
        echo '<p>Type <select name='.LeagueCpt::BHAA_LEAGUE_TYPE.'>';
        echo '<option value="I" '.(($type[0]=='I')?'selected="selected"':"").'>I</option>';
        echo '<option value="T" '.(($type[0]=='T')?'selected="selected"':"").'>T</option>';
        echo '</select></p>';
    }

    public function bhaa_league_save_meta_data($post) {
        if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE )
            return;

        if ( empty( $_POST ) )
            return;

        if ( !empty($_POST[LeagueCpt::BHAA_LEAGUE_RACES_TO_SCORE])) {
            update_post_meta( $post, LeagueCpt::BHAA_LEAGUE_RACES_TO_SCORE, $_POST[LeagueCpt::BHAA_LEAGUE_RACES_TO_SCORE] );
        }
        if ( !empty($_POST[LeagueCpt::BHAA_LEAGUE_TYPE])) {
            error_log("bhaa_league_save_meta_data ".$_POST[LeagueCpt::BHAA_LEAGUE_TYPE]);
            update_post_meta( $post, LeagueCpt::BHAA_LEAGUE_TYPE, $_POST[LeagueCpt::BHAA_LEAGUE_TYPE]);
        }
    }

    /**
     * Add custom url link actions
     * http://wordpress.stackexchange.com/questions/8481/custom-post-row-actions
     * http://wordpress.org/support/topic/trying-to-add-custom-post_row_actions-for-custom-post-status
     * http://wordpress.stackexchange.com/questions/14973/row-actions-for-custom-post-types
     * http://wordpress.org/support/topic/replacement-for-post_row_actions
     * http://www.ilovecolors.com.ar/saving-custom-fields-quick-bulk-edit-wordpress/
     */
    function bhaa_league_post_row_actions($actions, $post) {
        if ($post->post_type =="league") {
            $actions = array_merge(
                $actions, $this->get_admin_url_links($post)
            );
        }
        return $actions;
    }

    private function get_admin_url_links($post) {
        return array(
            'bhaa_league_delete' => $this->generate_league_admin_url_link('bhaa_league_delete',$post->ID,'Delete'),
            'bhaa_league_populate' => $this->generate_league_admin_url_link('bhaa_league_populate',$post->ID,'Populate'),
            'bhaa_league_top_ten' => $this->generate_league_admin_url_link('bhaa_league_top_ten',$post->ID,'Export Top Ten')
        );
    }

    /**
     * Use the admin.php page as the hook point
     * http://shibashake.com/wordpress-theme/obscure-wordpress-errors-why-where-and-how
     */
    private function generate_league_admin_url_link($action,$leagueId,$link_title) {
        $adminURL = add_query_arg(
            array('action'=>$action,
                'post_type'=>'league',
                'post_id'=>$leagueId
            ),admin_url('admin.php'));
        return '<a href='.wp_nonce_url($adminURL, $action).'>'.$link_title.'</a>';
    }

    function bhaa_register_league_cpt() {
        $leagueLabels = array(
            'name' => _x( 'Leagues', 'league' ),
            'singular_name' => _x( 'League', 'league' ),
            'add_new' => _x( 'Add New', 'league' ),
            'add_new_item' => _x( 'Add New League', 'league' ),
            'edit_item' => _x( 'Edit League', 'league' ),
            'new_item' => _x( 'New League', 'league' ),
            'view_item' => _x( 'View League', 'league' ),
            'search_items' => _x( 'Search Leagues', 'league' ),
            'not_found' => _x( 'No league found', 'league' ),
            'not_found_in_trash' => _x( 'No leagues found in Trash', 'league' ),
            'parent_item_colon' => _x( 'Parent League:', 'league' ),
            'menu_name' => _x( 'BHAA Leagues', 'league' ),
        );

        $leagueArgs = array(
            'labels' => $leagueLabels,
            'hierarchical' => false,
            'description' => 'BHAA League Details',
            'supports' => array( 'title','editor','excerpt','thumbnail','comments'),
            'taxonomies' => array('category'),// post_tag
            'public' => true,
            'show_ui' => true,
            'show_in_menu' => true,
            'show_in_nav_menus' => true,
            'publicly_queryable' => true,
            'exclude_from_search' => false,
            'has_archive' => true,
            'query_var' => true,
            'can_export' => true,
            'rewrite' => true,
            'has_archive' => true,
            'capability_type' => 'post'
        );
        register_post_type('league', $leagueArgs );
    }
}
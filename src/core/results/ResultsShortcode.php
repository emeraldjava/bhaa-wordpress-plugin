<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 06/04/2018
 * Time: 16:24
 */

namespace BHAA\core\results;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;

// https://wordpress.stackexchange.com/questions/201650/how-to-add-and-submit-input-fields-using-a-shortcode
// https://stackoverflow.com/questions/28927298/submit-a-form-to-api-and-save-in-db-via-shortcode
// https://wordpress.stackexchange.com/questions/170116/custom-link-text-wp-get-archive-link

class ResultsShortcode implements Loadable {

    function __construct() {
        add_shortcode('bhaa_results_by_year',array($this,'bhaa_results_by_year_shortcode'));
    }

    public function registerHooks(Loader $loader) {
        $loader->add_filter('get_archives_link', $this, 'bhaa_get_archives_link', 10, 6);
    }

    function bhaa_results_by_year_shortcode($atts) {
        //error_log("bhaa_results_by_year_shortcode()");
        if(isset($_GET["y"])) {
            $year = $_GET["y"];
        }else {
            $year = "2018";
        }
        $years = wp_get_archives(array('type'=>'yearly','format'=>'bhaaresults','post_type'=>'race','echo'=>0));
        include_once( 'partials/results.by.year.php' );
    }

    function bhaa_get_archives_link($link_html, $url, $text, $format, $before, $after) {
        if ('bhaaresults' == $format) {
            $link_html = sprintf("<li><a href='%s/results?y=%s'>%s</a></li>",get_site_url(),$text,$text);
        }
        return $link_html;
    }
}
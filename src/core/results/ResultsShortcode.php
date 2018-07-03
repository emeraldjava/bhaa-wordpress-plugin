<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 06/04/2018
 * Time: 16:24
 */

namespace BHAA\core\results;

class ResultsShortcode {

    function __construct() {
        add_shortcode('bhaa_results_by_year',array($this,'bhaa_results_by_year_shortcode'));
    }

    function bhaa_results_by_year_shortcode() {
        include_once( 'partials/results.by.year.php' );
    }
}
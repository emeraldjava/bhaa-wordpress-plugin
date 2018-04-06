<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 06/04/2018
 * Time: 16:24
 */

namespace BHAA\core\race;

class RaceResultShortcode {

    function __construct() {
        add_shortcode('bhaa_race_title'     ,array($this,'bhaa_race_title'));
        add_shortcode('bhaa_race_results'   ,array($this,'bhaa_race_results_shortcode'));
    }

    function bhaa_race_results_shortcode() {
        $raceResult = new RaceResult();
        $races = $raceResult->listAllRaces();
        include_once( 'partials/list.race.results.php' );
    }

    function bhaa_race_title() {
        global $post;
        return 'Race '.$post->post_title.' on date '.$post->post_date;
    }
}
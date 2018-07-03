<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 06/04/2018
 * Time: 16:24
 */

namespace BHAA\core\race;

class RaceShortcode {

    function __construct() {
        add_shortcode('bhaa_races_by_year',array($this,'bhaa_races_by_year_shortcode'));
        add_shortcode('bhaa_race_results',array($this,'bhaa_race_results_shortcode'));
        add_shortcode('bhaa_race_title',array($this,'bhaa_race_title_shortcode'));
    }

    function bhaa_races_by_year_shortcode() {
        $raceResult = new RaceResult();
        $races = $raceResult->listRacesByYear();
        include_once( 'partials/list.races.php' );
    }

    function bhaa_race_results_shortcode() {
        $raceResult = new RaceResult();
        $races = $raceResult->listRacesByYear();
        include_once( 'partials/list.races.php' );
    }

    function bhaa_race_title_shortcode() {
        global $post;
        return 'Race '.$post->post_title.' on date '.$post->post_date;
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 11/04/2018
 * Time: 20:40
 */

namespace BHAA\core\runner;

use BHAA\core\race\RaceResult;
use BHAA\core\Mustache;

class RunnerShortcode {

    function __construct() {
        add_shortcode('bhaa_runner_results',array($this,'bhaa_runner_results_shortcode'));
    }

    function bhaa_runner_results_shortcode($args) {
        $raceResult = new RaceResult();
        $results = $raceResult->getRunnerResults($_GET['id']);
        $mustache = new Mustache();
        return $mustache->renderTemplate('runner.race.results',
            array(
                'runners'=>$results,
                'url'=>get_site_url()
            )
        );
    }
}
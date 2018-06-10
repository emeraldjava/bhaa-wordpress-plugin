<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 10/06/2018
 * Time: 21:36
 */

namespace BHAA\core\standard;

use BHAA\core\standard\StandardCalculator;

class StandardShortcode {

    function __construct() {
        add_shortcode('bhaa_standard_table', array($this,'bhaa_standard_table'));
    }

    function bhaa_standard_table() {
        $distances = array();

        $distance = array();
        $distance['km'] = 1;
        $distance['title'] = '1km';
        $distances[0]= $distance;

        $distance = array();
        $distance['km'] = 1.6;
        $distance['title'] = '1Mile';
        $distances[1]= $distance;

        $distance = array();
        $distance['km'] = 3.2;
        $distance['title'] = '2Mile';
        $distances[2]= $distance;

        $distance = array();
        $distance['km'] = 5;
        $distance['title'] = '5km';
        $distances[3]= $distance;

        $distance = array();
        $distance['km'] = 8;
        $distance['title'] = '5Mile';
        $distances[4]= $distance;

        $distance = array();
        $distance['km'] = 10;
        $distance['title'] = '10km';
        $distances[5]= $distance;

        $distance = array();
        $distance['km'] = 21.1;
        $distance['title'] = 'Half';
        $distances[6]= $distance;

        $distance = array();
        $distance['km'] = 42.2;
        $distance['title'] = 'Marathon';
        $distances[7]= $distance;

        $standardCalculator = new StandardCalculator();
        return $standardCalculator->generateTableForDistances($distances);
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 23/03/2018
 * Time: 12:48
 */

namespace BHAA\core\mustache;

use Mustache_Engine;

class Mustache {

    private $mustache = null;

    public function __construct() {
        $options =  array('extension' => '.html');
        $this->mustache = new Mustache_Engine(
            array(
                'loader' => new Mustache_Loader_FilesystemLoader(dirname(__FILE__) . '/templates',$options),
                'partials_loader' => new Mustache_Loader_FilesystemLoader(dirname(__FILE__) . '/partials',$options)
            )
        );
    }

    /**
    'runners'=>$results,
    'isAdmin'=>$isAdmin,
    'formUrl'=>$link,
    'racename'=>get_the_title($race),
    'dist'=>get_post_meta($race,'bhaa_race_distance',true),
    'unit'=>get_post_meta($race,'bhaa_race_unit',true),
    'type'=>get_post_meta($race,'bhaa_race_type',true),
     */
    public function renderRaceResults($results,$isAdmin,$link,$racename,$dist,$unit,$type) {
        return $this->mustache->loadTemplate('race.results.individual.html')
            ->render(array(
                    'runners'=>$results,
                    'isAdmin'=>$isAdmin,
                    'formUrl'=>$link,
                    'racename'=>$racename,
                    'dist'=>$dist,
                    'unit'=>$unit,
                    'type'=>$type,
                )
            );
    }

}
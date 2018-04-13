<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 05/04/2018
 * Time: 16:17
 */

namespace BHAA\core\league;

use BHAA\core\Mustache;

class LeagueShortcode {

    function __construct() {
        add_shortcode('bhaa_league','bhaa_league_shortcode');
    }

    /**
     * should be moved to the league post
     * @param unknown $atts
     * @return string
     */
    function bhaa_league_shortcode($atts) {

        extract( shortcode_atts(
            array(
                'division' => 'A',
                'top' => '100'
            ), $atts ) );

        $id = get_the_ID();
        $post = get_post( $id );

        $leagueSummary = new LeagueSummary($id);
        $summary = $leagueSummary->getDivisionSummary($atts['division'],$atts['top']);

        $mustache = new Mustache();
        // division summary
        if($atts['top']!=1000) {
            return $mustache->renderTemplate('division-summary',
                array(
                    'division' => $atts['division'],
                    'id'=>$id,
                    'top'=> $atts['top'],
                    'url'=> get_permalink( $id ),
                    'linktype' => $leagueSummary->getLinkType(),
                    'summary' => $summary
                ));
        } else {

            //error_log('bhaa_league_shortcode detailed');
            if(strpos($atts['division'],'L'))
                $events = $leagueSummary->getLeagueRaces('W');
            else
                $events = $leagueSummary->getLeagueRaces('M');

            return $mustache->renderTemplate('division-detailed',
                array(
                    'division' => $atts['division'],
                    'id'=>$id,
                    'top'=> $atts['top'],
                    'url'=> get_permalink( $id ),
                    'summary' => $summary,
                    'linktype' => $leagueSummary->getLinkType(),
                    'events' => $events,
                    'matchEventResult' => function($text, Mustache_LambdaHelper $helper) {
                        $results = explode(',',$helper->render($text));
                        //error_log($helper->render($text).' '.$results);
                        $row = '';
                        foreach($results as $result) {
                            if($result==0)
                                $row .= '<td>-</td>';
                            else
                                $row .= '<td>'.$result.'</td>';
                        }
                        return $row;
                    }
                ));
        }
    }
}
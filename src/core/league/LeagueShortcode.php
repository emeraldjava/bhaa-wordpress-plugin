<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 05/04/2018
 * Time: 16:17
 */

namespace BHAA\core\league;

use BHAA\core\Mustache;
use Mustache_LambdaHelper;

class LeagueShortcode {

    function __construct() {
        add_shortcode('bhaa_league',array($this,'bhaa_league_shortcode'));
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
                'top' => '10'
            ), $atts ) );

        $id = get_the_ID();
        $post = get_post( $id );

        $leagueFactory = new LeagueFactory();
        $league = $leagueFactory->getLeague($id);

        //error_log('league '.$id.'. division '.$atts['division'].'. top '.$atts['top']);
        $division = $league->getDivisionDetails($atts['division']);
        $summary = $league->getDivisionSummary($atts['division'],$atts['top']);

        $mustache = new Mustache();
        // division summary
        if($atts['top']!=1000) {
            return $mustache->renderTemplate('division-summary',
                array(
                    'division' => $division,
                    'id'=>$id,
                    'top'=> $atts['top'],
                    'url'=> get_permalink( $id ),
                    'linktype' => $league->getLinkType(),
                    'summary' => $summary
                ));
        } else {

            //error_log('bhaa_league_shortcode detailed');
            if(strpos($atts['division'],'L'))
                $events = $league->getLeagueRaces('W');
            else
                $events = $league->getLeagueRaces('M');

            return $mustache->renderTemplate('division-detailed',
                array(
                    'division' => $division,
                    'id'=>$id,
                    'top'=> $atts['top'],
                    'url'=> get_permalink( $id ),
                    'summary' => $summary,
                    'linktype' => $league->getLinkType(),
                    'events' => $events,
                    'matchEventResult' => function($text, Mustache_LambdaHelper $helper) {
                        $results = explode(',',$helper->render($text));
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
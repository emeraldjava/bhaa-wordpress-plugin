<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 14/06/2018
 * Time: 21:24
 */

namespace BHAA\core\league;

use BHAA\core\cpt\LeagueCPT;

class LeagueFactory {

    /**
     * Return the specific implementation class for this league id.
     * @param $leagueid
     * @return IndividualLeague|TeamLeague
     */
    public function getLeague($leagueid) {
        if(get_post_meta($leagueid,LeagueCpt::BHAA_LEAGUE_TYPE,true)=='I')
            return new IndividualLeague($leagueid);
        else
            return new TeamLeague($leagueid);
    }
}
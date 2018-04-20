<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 23/03/2018
 * Time: 12:58
 */

namespace BHAA\core\race;

use BHAA\core\runner\RunnerManager;

/**
 * Class RaceResult
 * @package BHAA\core\race
 */
class RaceResult {

    const RAN = 'RAN';
    const RACE_REG = 'RACE_REG';
    const RACE_ORG = 'RACE_ORG';
    const PRE_REG = 'PRE_REG';

    private $wpdb;
    private $tablename = 'wp_bhaa_raceresult';

    public function __construct() {
        global $wpdb;
        $this->wpdb = $wpdb;
    }

	function getTableName() {
		return 'wp_bhaa_raceresult';
	}

    function processRaceResults($raceId,String $resultText) {
        //error_log('bhaa_race_load_results('.strlen($resultText).')');
        $results = explode("\n",$resultText);
        //error_log('Number of rows '.sizeof($results));
        foreach($results as $result) {
            // http://stackoverflow.com/questions/13430120/str-getcsv-alternative-for-older-php-version-gives-me-an-empty-array-at-the-e
            $singleResult = explode(',', $result);
            $this->addRaceResult($raceId, $singleResult);
        }
    }

    public function addRaceResult($race,$details) {
        // check if the runner exists
        $position = $details[0];
        $bib = $details[1];
        $runner_id = trim($details[2]);
        $racetime = $details[3];
        $firstname = $details[5];
        $surname = $details[4];
        $email = '';
        $gender = $details[6];
        $dob = $details[8];
        $memberType = trim($details[12]);

        $runnerManager = new RunnerManager();
        if($runner_id<0){
            if($memberType=='New Member'){
                $runner_id = $runnerManager->getNextBHAARunnerId();
                $isNewMember = true;
                error_log($position.' new BHAA Member runner '.$runner_id);
            } else {
                $runner_id = $runnerManager->getNextDayRunnerId();
                $isNewMember = false;
                error_log($position.' new DAY runner '.$runner_id);
            }
            $dateofbirth = date("Y-m-d", strtotime(str_replace('/','-',$dob)));
            $runnerManager->createNewUser($firstname,$surname,'',$gender,$dateofbirth,$runner_id,$isNewMember);
        } else {
            error_log('existing runner '.$runner_id. ' '.$runnerManager->runnerExists($runner_id));
        }

        // convert Senior to S
        $category = $this->getAgeCategory($details[9]);

        if($details[0]!=0) {
            $res = $this->wpdb->insert(
                $this->tablename,
                array(
                    'race' => $race,
                    'position' => $details[0],
                    'racenumber' => $details[1],
                    'runner' => $runner_id,
                    'racetime' => $racetime,
                    'category' => $category,
                    'standard' => ($details[7] == '') ? null : $details[7],
                    'class' => RaceResult::RAN)
            );
            error_log(sprintf('%d , %d. %s %s %s',$this->wpdb->insert_id,$runner_id,$firstname,$surname,$racetime));
            $res = $this->wpdb->insert_id;
        }
        return $res;
    }

    function getAgeCategory($ageCategory) {
        // convert Senior to S
        $category = 'S';
        switch ($ageCategory) {
            case 'Senior':
                $category = 'S';
                break;
            case 'A':
                $category = '35';
                break;
            case '1':
            case 'B':
                $category = '40';
                break;
            case '2':
            case 'C':
                $category = '45';
                break;
            case '3':
            case 'D':
                $category = '50';
                break;
            case '4':
            case 'E':
                $category = '55';
                break;
            case '5':
            case 'F':
                $category = '60';
                break;
            case '6':
            case 'G':
                $category = '65';
                break;
            case '7':
            case 'H':
                $category = '70';
                break;
            case '8':
            case 'I':
                $category = '75';
                break;
            case '9':
            case 'J':
                $category = '80';
                break;
            default:
                $category = 'S';
        }
        return $category;
    }

    function getRaceResults($race) {
        $query = "SELECT wp_bhaa_raceresult.*,
                first_name.meta_value AS firstname, 
                UPPER(last_name.meta_value) AS surname,
                wp_users.user_nicename,
                gender.meta_value as gender,
                wp_posts.id as cid,
                wp_posts.post_title as cname,
                IF(status.meta_value='M',true,false) as isMember
                FROM wp_bhaa_raceresult
                left join wp_users on wp_users.id=wp_bhaa_raceresult.runner
                left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key='first_name')
                left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key='last_name')
                left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key='bhaa_runner_gender')
                left join wp_usermeta company on (company.user_id=wp_users.id and company.meta_key='bhaa_runner_company')
                left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key='bhaa_runner_status')
                left join wp_posts on (wp_posts.post_type='house' and company.meta_value=wp_posts.id)
                where race=%d and wp_bhaa_raceresult.class='RAN' and position<=500 ORDER BY position";
        $SQL = $this->wpdb->prepare($query,$race);
        //error_log($SQL);
        return $this->wpdb->get_results($SQL,OBJECT);
    }

    function deleteRaceResults($race) {
        $res = $this->wpdb->delete(
            $this->tablename,
            array('race' => $race)
        );
    }

    function getRaceResult($racerresult) {
        return $this->wpdb->get_row("SELECT * FROM wp_bhaa_raceresult WHERE ID=".$racerresult);
    }

    function deleteRaceResult($racerresult) {
        return $this->wpdb->delete($this->tablename, array( 'id' => $racerresult ), array('%d'));
    }

    function updateRaceResult($id,$race,$runner,$time,$standard,$poststandard,$number=0) {
        error_log(sprintf('updateRunnersRaceResultStandard %d,%d,%d,%s,%d,%d',$id,$race,$runner,$time,$standard,$poststandard));
        if(isset($id)&&$id!=0) {

            // lookup the standard if not defined.
            if($standard==0) {
                $runnerObj = new Runner($runner);
                $standard = $runnerObj->getStandard();
            }

            $res = $this->wpdb->update(
                'wp_bhaa_raceresult',
                array('runner' => $runner,
                    'race'=>$race,
                    'standard' => $standard,
                    'poststandard'=>$poststandard,
                    'racenumber'=>$number,
                    'racetime'=>$time),
                array('id' => $id)
            );
        } else {
            $raceObj = new Race($race);
            $ageCategory = $raceObj->getRunnersAgeCategory($runner);
            $res = $this->wpdb->insert(
                'wp_bhaa_raceresult',
                array('runner' => $runner,
                    'race'=>$race,
                    'racetime'=>$time,
                    'standard' => $standard,
                    'poststandard'=>$poststandard,
                    'class'=>"RAN",
                    'position'=>1,
                    'category'=>$ageCategory
                ));
            $this->updatePositions($race);
        }
    }

    function updatePositions($race) {
        $this->wpdb->query($this->wpdb->prepare('call updatePositions(%d)',$race));
    }

    function listEventsAndRaces() {
        $query = "SELECT event.ID,
            event.post_title as eventname,
            (select count(p2p_id) from wp_p2p WHERE p2p_from=event.ID and p2p_type='event_to_race') as racecount,
            MIN(races.p2p_to) as race1,
            MAX(races.p2p_to) as race2,
            league.p2p_from as league
            FROM wp_posts as event
            JOIN wp_p2p races on (races.p2p_from=event.ID and races.p2p_type='event_to_race')
            LEFT JOIN wp_p2p league on (league.p2p_to=event.ID and league.p2p_type='league_to_event')
            WHERE post_type in ('espresso_events','event')
            AND event.ID>=4563
            GROUP BY races.p2p_from
            ORDER BY post_date DESC;";
        //$SQL = $this->wpdb->prepare($query);
        return $this->wpdb->get_results($query,OBJECT);
    }

    function getRunnerResults($runner) {
        $query = $this->wpdb->prepare("SELECT
              rr.racetime,
              rr.position,
              rr.standard,
              rr.poststandard,
              rr.runner,
              rr.id,
              race.id as race_id,
              race.post_name as race_name,
              race.post_date as race_date,
              event.post_title as event_title,
              event.post_name as event_name,
              event.ID as event_id,
              race_distance.meta_value as race_distance,
              race_unit.meta_value as race_unit
            FROM wp_bhaa_raceresult rr
              JOIN wp_posts race on (rr.race=race.ID)
              JOIN wp_postmeta race_distance on (race_distance.post_id=race.id and race_distance.meta_key='bhaa_race_distance')
              JOIN wp_postmeta race_unit on (race_unit.post_id=race.id and race_unit.meta_key='bhaa_race_unit')
              JOIN wp_p2p event_to_race on (event_to_race.p2p_to=race.ID and event_to_race.p2p_type='event_to_race')
              JOIN wp_posts event on (event.ID=event_to_race.p2p_from)
            WHERE rr.runner=%d AND rr.class IN ('RAN','RACE_ORG')
            ORDER BY race.post_date desc",$runner);
        return $this->wpdb->get_results($query, ARRAY_A);
    }

    function updateRacePace($race) {
        // update wp_bhaa_raceresult set actualstandard=getStandard(racetime,getRaceDistanceKm(race)) where race=2504;
        // SEC_TO_TIME(TIME_TO_SEC(_raceTime) / _distance)
        $SQL = sprintf('update %s set pace=SEC_TO_TIME(TIME_TO_SEC(racetime)/%f),actualstandard=getStandard(racetime,getRaceDistanceKm(race)) where race=%d',
            $this->getTableName(),
            $this->getRace($race)->getKmDistance(),
            $race);
        //error_log($SQL);
        $this->wpdb->query($SQL);
    }

    function updateRacePosInCat($race) {
        $this->wpdb->query($this->wpdb->prepare('call updatePositionInAgeCategory(%d,"M")',$race));
        $this->wpdb->query($this->wpdb->prepare('call updatePositionInAgeCategory(%d,"W")',$race));
    }

    function updateRacePosInStd($race) {
        $this->wpdb->query($this->wpdb->prepare('call updatePositionInStandard(%d)',$race));
    }

    function updateLeague($race) {
        $this->wpdb->query($this->wpdb->prepare('call updateRaceScoringSets(%d)',$race));
        $this->wpdb->query($this->wpdb->prepare('call updateRaceLeaguePoints(%d)',$race));
    }

    function updatePostRaceStd($race) {
        $SQL = $this->wpdb->prepare('select position, runner, standard, actualstandard from wp_bhaa_raceresult where race=%d order by position asc',$race);
        //error_log($SQL);
        $runners = $this->wpdb->get_results($SQL);

        $postRaceStandard = 10;
        foreach($runners as $runner) {
            if($runner->standard != 0) {
                if($runner->standard  < $runner->actualstandard) {
                    update_user_meta( $runner->runner,'bhaa_runner_standard',$runner->standard+1,$runner->standard);
                    $postRaceStandard = $runner->standard+1;
                    //error_log($runner->position.' up standard '.$runner->runner.'->'.($runner->standard+1));
                } elseif ($runner->standard > $runner->actualstandard) {
                    update_user_meta( $runner->runner,'bhaa_runner_standard',$runner->standard-1,$runner->standard);
                    $postRaceStandard = $runner->standard-1;
                    //error_log($runner->position.' down standard '.$runner->runner.'->'.($runner->standard-1));
                } elseif($runner->standard == $runner->actualstandard){
                    $postRaceStandard = $runner->actualstandard;
                    //error_log($runner->position.' same standard '.$runner->runner.'->'.$runner->standard);
                }
            } else {
                update_user_meta( $runner->runner,'bhaa_runner_standard',$runner->actualstandard );
                $postRaceStandard = $runner->actualstandard;
                //error_log($runner->position.' new standard '.$runner->runner.'->'.$runner->actualstandard);
            }

            $UPDATE_POSTSTANDARD_SQL = $this->wpdb->prepare('update wp_bhaa_raceresult set poststandard=%d where race=%d and runner=%d',
                $postRaceStandard,$race,$runner->runner);
            //error_log($UPDATE_POSTSTANDARD_SQL);
            $this->wpdb->query($UPDATE_POSTSTANDARD_SQL);
        }
    }
    
    private function getRace($race) {
        return new Race($race);
    }
}
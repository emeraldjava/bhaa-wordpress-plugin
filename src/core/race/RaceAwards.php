<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 18/03/19
 * Time: 21:30
 */

namespace BHAA\core\race;


class RaceAwards {

    private $wpdb;

    public function __construct() {
        global $wpdb;
        $this->wpdb = $wpdb;
    }

    function getTableName() {
        return "wp_bhaa_raceaward";
    }

    function populateAwards($raceId) {
        $message = $this->delete($raceId);
        $this->processAllAgeCategories($raceId);
        //var_dump($this->select($raceId));
        return $message;
    }

    function processAllAgeCategories($raceId) {
        $ageCategories = $this->wpdb->get_results('SELECT * FROM wp_bhaa_agecategory',OBJECT);
        error_log("processAllAgeCategories() ". count($ageCategories));
        foreach($ageCategories as $ageCategory) {
            $this->processCategory($raceId, $ageCategory->category,$ageCategory->gender,$ageCategory->restricted);
        }
    }

    function processCategory($raceId, $category,$gender,$restricted) {
        for($award=1;$award<=3;$award++) {
            $this->processPositionWithinCatogory($raceId,$category,$gender,$award,$restricted);
        }
    }

    function processPositionWithinCatogory($raceId,$category,$gender,$award,$restricted) {
        $SQL = null;
        if(!$restricted) {
            $SQL = $this->wpdb->prepare('INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
            SELECT rr.race,%s,%d,rr.runner FROM wp_bhaa_raceresult rr
            JOIN wp_bhaa_agecategory agecat on rr.agecategory=agecat.category
            WHERE rr.race=%d
            AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=%d)
            AND rr.class="RAN"
            AND agecat.category=%s
            ORDER BY rr.position
            LIMIT 1',$category,$award,$raceId,$raceId,$category);
        } else {
            $SQL = $this->wpdb->prepare('INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
            SELECT rr.race,%s,%d,rr.runner FROM wp_bhaa_raceresult rr
            JOIN wp_bhaa_agecategory agecat on rr.agecategory=agecat.category
            WHERE rr.race=%d
            AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=%d)
            AND rr.class="RAN"
            AND agecat.gender=%s
            ORDER BY rr.position
            LIMIT 1',$category,$award,$raceId,$raceId,$gender);
        }
        error_log($SQL);
        $res = $this->wpdb->query($SQL);
        error_log($res);
    }

    function select($raceId) {
        $selectSQL = $this->wpdb->prepare('SELECT ra.*,wba.agegroup,r.display_name,rr.racetime,rr.position,rr.age 
            FROM wp_bhaa_raceaward ra
            JOIN wp_users r on (r.ID=ra.runner)
            JOIN wp_bhaa_raceresult rr on (rr.race=ra.race AND rr.runner=ra.runner)
            JOIN wp_bhaa_agecategory wba on ra.category = wba.category
            WHERE ra.race=%d 
            ORDER BY wba.agegroup,wba.category,ra.award',
            $raceId);
        //error_log($selectSQL);
        return $this->wpdb->get_results($selectSQL,OBJECT);
    }

    function delete($raceId) {
        $deleted = $this->wpdb->delete(
            $this->getTableName(),
            array('race' => $raceId)
        );
        return sprintf('Deleted %d rows from %s for race %d.',$deleted,$this->getTableName(),$raceId);
    }
}
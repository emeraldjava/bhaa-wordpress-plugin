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
        var_dump($this->select($raceId));
        return $message;
    }

    function processAllAgeCategories($raceId) {
        $ageCategories = $this->wpdb->get_results('SELECT * FROM wp_bhaa_agecategory',OBJECT);
        foreach($ageCategories as $ageCategory) {
            //var_dump($ageCategory,true);
            $this->processCategory($raceId, $ageCategory->category,$ageCategory->gender,$ageCategory->restricted);
        }
    }

    function processCategory($raceId, $category,$gender,$restricted) {
        for($award=1;$award<4;$award++) {
            $this->processPositionWithinCatogory($raceId,$category,$gender,$award,$restricted);
        }
    }

    function processPositionWithinCatogory($raceId,$category,$gender,$award,$restricted) {
        $AGE_CATEGORY_CLAUSE = '';
        if($restricted) {
            $AGE_CATEGORY_CLAUSE = sprintf('AND agecategory=%s',$category);
        }
        $SQL = $this->wpdb->prepare('INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
            SELECT rr.race,%s,%d,rr.runner FROM wp_bhaa_raceresult rr
            JOIN wp_bhaa_agecategory agecat on rr.agecategory=agecat.category
            WHERE rr.race=%d
            AND agecat.gender=%s
            AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=%d)
            AND rr.class="RAN" %s
            ORDER BY rr.position',$category,$award,$raceId,$gender,$raceId,$category,$AGE_CATEGORY_CLAUSE);
        error_log($SQL);
        $res = $this->wpdb->query($SQL);
        error_log($res);
    }

//    function xx($raceId) {
//        $SQL = $this->wpdb->prepare('INSERT INTO wp_bhaa_raceaward (race,category,award,runner)
//            SELECT race,"M",1,runner FROM wp_bhaa_raceresult rr
//            LEFT JOIN wp_bhaa_agecategory agecat on rr.agecategory=agecat.category
//            WHERE rr.race=%d
//            AND agecat.gender="M"
//            AND rr.runner NOT IN (SELECT runner FROM wp_bhaa_raceaward a where a.race=%d)
//            ORDER BY rr.position DESC
//            LIMIT 1',$raceId,$raceId);
//        error_log($SQL);
//        $res = $this->wpdb->query($SQL);
//        return sprintf("xx %d",$res);
//
//    }

    function select($raceId) {
        $selectSQL = $this->wpdb->prepare('SELECT * FROM wp_bhaa_raceaward WHERE race=%d',$raceId);
        error_log($selectSQL);
        return $this->wpdb->get_results($selectSQL,OBJECT);
        //return sprintf('Selected %d rows from %s for race %d.',$selected,$this->getTableName(),$raceId);
    }

    function delete($raceId) {
        $deleted = $this->wpdb->delete(
            $this->getTableName(),
            array('race' => $raceId)
        );
        return sprintf('Deleted %d rows from %s for race %d.',$deleted,$this->getTableName(),$raceId);
    }
}
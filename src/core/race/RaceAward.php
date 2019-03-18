<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 18/03/19
 * Time: 21:30
 */

namespace BHAA\core\race;


class RaceAward {

    private $wpdb;

    public function __construct() {
        global $wpdb;
        $this->wpdb = $wpdb;
    }

    function getTableName() {
        return 'wp_bhaa_raceaward';
    }

    function populateAwards($raceId) {
        $message = $this->delete($raceId);

        return $message;
    }

    function delete($raceId){
        $deleted = $this->wpdb->delete(
            $this->getTableName(),
            array('race' => $raceId)
        );
        return sprintf('deleted %d rows from %s for race %d',$deleted,$this->getTableName(),$raceId);
    }
}
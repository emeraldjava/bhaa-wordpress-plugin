<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 04/04/2018
 * Time: 17:25
 */

namespace BHAA\admin;

use BHAA\utils\Actionable;
use BHAA\utils\Filterable;

class RaceAdminController implements Filterable, Actionable {

    public function get_filters() {
        return array();
    }

    public function get_actions() {
        return array();
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 14/06/2018
 * Time: 21:23
 */

namespace BHAA\core\league;

interface League {
    function getDivisionSummary($division,$limit);

    function getLinkType();
}
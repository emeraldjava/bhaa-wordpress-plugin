<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 18/03/19
 * Time: 21:30
 */

namespace BHAA\core\race;


class RaceAwardsView {

    function generateView($awards) {
        $awardsReport = '';
        $currentAgeGroup = null;
        foreach($awards as $award) {
            $awardsReport .= '<div id="accordion">';
            if($currentAgeGroup!=$award->agegroup) {
                $currentAgeGroup = $award->agegroup;
                $awardsReport .= $this->generateAgeCategoryCard($award->agegroup);
            }
            $awardsReport .= '</div>';
        }
        return $awardsReport;
    }

    function generateAgeCategoryCard($ageCategory) {
        return sprintf('<div class="card">
            <div class="card-header" id="%1$s">
              <h5 class="mb-0">
                <button class="btn btn-link" data-toggle="collapse" data-target="#collapse%1$s" aria-expanded="true" aria-controls="collapseOne">
                  AgeGroup %1$s
                </button>
              </h5>
            </div>
        
            <div id="collapse1%s" class="collapse show" aria-labelledby="headingOne" data-parent="#accordion">
              <div class="card-body">
                The %1$s details
              </div>
            </div>
          </div>',$ageCategory);
    }

}
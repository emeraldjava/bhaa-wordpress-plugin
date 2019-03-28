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
        $awardsReport .= '<div id="container">';

        $totalRows = sizeof($awards);

        foreach($awards as $key=>$award) {

            $gender = $award['category'];
            $award = $award['award'];

            if($currentAgeGroup!=$award['agegroup']) {
                $currentAgeGroup = $award['agegroup'];
//                error_log(print_r($award));
                $awardsReport .= $this->generateAgeCategoryCard($award);
            }
        }
        $awardsReport .= '</div>';
        return $awardsReport;
    }

    function generateAgeCategoryCard($award)
    {
        $ageCategoryHeaderRow = sprintf(
            '<div class="row" id="%1$sBlock">
                <div class="col-md-12 col-lg-12 col-xl-12 card-header" id="%1$sHeader">
                  <div class="card">
                    <div class="card-block">
                      <h4 class="card-title"><span>AgeGroup</span> <span>%1$s</span></h4>
                    </div>
                  </div>  
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 col-lg-6 col-xl-6 card-header" id="%1$s_M">
                    <div class="card">
                        <div class="card-block">
                          <h5 class="card-title">Men</h5>
                        </div>  
                    </div>
                </div>
                <div class="col-md-6 col-lg-6 col-xl-6 card-header" id="%1$s_W">
                    <div class="card">
                        <div class="card-block">
                          <h5 class="card-title">Women</h5>
                        </div>  
                    </div>
                </div>
            </div>', $award['agegroup']);
        return $ageCategoryHeaderRow;
    }

    function generateAgeCategoryxCard($award)
    {
        $ageCategoryDetailsRow = sprintf('
            <div class="row">
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p1m">
                    %2$s
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p2m">
                    %3$s
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p3m">
                    %4$s
                </div>
                
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p1w">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P1 W</h6>
                        </div>  
                    </div>
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p2w">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P2 W</h6>
                        </div>  
                    </div>
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p3w">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P3 W</h6>
                        </div>  
                    </div>
                </div>
            </div>',$award['agegroup'],
                $this->generateAwardCard($award['agegroup'],$award,1),
                $this->generateAwardCard($award['agegroup'],$award,2),
                $this->generateAwardCard($award['agegroup'],$award,3)
        );

        return $ageCategoryHeaderRow.''.$ageCategoryDetailsRow;
    }

    function generateAwardCard($ageCategory,$award,$position)
    {
        return sprintf('
            <div class="card">
                <div class="card-block">
                      <h6 class="card-title">P%2$s<span>%3$s</span></h6>
                      <p class="card-text">%5$s</p>
                      <!--<a href="#" class="btn btn-primary"></a>-->
                </div>
            </div>',$award['agegroup'],$position,$award['pcat'],$award['display_name'],$award['racetime']);
    }
}
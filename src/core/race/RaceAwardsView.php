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

        foreach($awards as $award) {
            if($currentAgeGroup!=$award->agegroup) {
                $currentAgeGroup = $award->agegroup;
                $awardsReport .= $this->generateAgeCategoryCard($award->agegroup);
            }
        }
        $awardsReport .= '</div>';
        return $awardsReport;
    }

    function generateAgeCategoryCard($ageCategory) {
        return sprintf(
            '<div class="row">
                <div class="col-md-12 col-lg-12 col-xl-12 card-header" id="%1$s">
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
            </div>
             
            <div class="row">
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p1m">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P1 Male</h6>
                        </div>  
                    </div>
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p2m">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P2 Male</h6>
                        </div>  
                    </div>
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p3m">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P3 Male</h6>
                        </div>  
                    </div>
                </div>
                
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p1w">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P1 Woman</h6>
                        </div>  
                    </div>
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p2w">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P2 Woman</h6>
                        </div>  
                    </div>
                </div>
                <div class="col-md-2 col-lg-2 col-xl-2 card-header" id="%1$s_p3w">
                    <div class="card">
                        <div class="card-block">
                          <h6 class="card-title">P3 Woman</h6>
                        </div>  
                    </div>
                </div>
            </div>
            
          </div>',$ageCategory);
    }

}
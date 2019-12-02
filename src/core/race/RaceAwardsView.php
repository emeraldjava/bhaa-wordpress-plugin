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

        $this->extractData($awards);
        $currentAgeGroup = null;
        $awardsReport .= '<div id="container">';

        $totalRows = sizeof($awards);

        foreach($awards as $key=>$award) {

            $gender = $award['category'];
            //$award = $award['award'];

            if($currentAgeGroup!=$award['agegroup']) {
                $currentAgeGroup = $award['agegroup'];
//                error_log(print_r($award));
                $awardsReport .= $this->generateAgeCategoryCard($award);
            }
        }
        $awardsReport .= '</div>';
        return $awardsReport;
    }

    function extractData($data)
    {
        $result = array();
        $resultArrayTemplate = array('x', 'x', 'x', 'x', 'x', 'x');
        foreach($data as $item)
        {
            $value = $item[0] . ' ' . $item[4] . $item[1];
            $index = filter_var($item[0], FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
            if(isset($result[$index])) {
                if($result[$index][$item[1]-1] != 'x') {
                    $subindex = $item[1]-1+3;
                } else {
                    $subindex = $item[1]-1;
                }
                $result[$index][$subindex] = $value;
            } else {
                if($result[$index][$item[1]-1] != 'x') {
                    $subindex = $item[1]-1+3;
                } else {
                    $subindex = $item[1]-1;
                }
                $result[$index] = $resultArrayTemplate;
                $result[$index][$subindex] = $value;
            }
        }
        //print_r($result);
        return $result;
    }



    function generateAgeCategoryCard($award)
    {
        // <div class="line-header-text awards-text b-button-award" ng-class="{ 'inverted': overallAwards[0].expanded }">
        //<h3><a href="#" ng-click="expandCollapseAwards($event, overallAwards[0], null)">
        //<span class="grey-text">Overall Award Winners</span></a></h3></div
        $ageCategoryHeaderRow = sprintf(
            '<div class="row" id="%1$sBlock">
                <div class="col-md-12 col-lg-12 col-xl-12 card-header" id="%1$sHeader">
                  <div class="card">
                    <div class="card-block line-header-text awards-text">
                      <h4 class="card-title"><span class="grey-text">AgeGroup</span> <span>%1$s</span></h4>
                    </div>
                  </div>  
                </div>
            </div>
            
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6 column-container" id="%1$s_M">
                    <div class="card">
                        <div class="card-block b-title b-title-award">
                          <h5 class="card-title ng-binding">Men</h5>
                        </div>  
                    </div>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 column-container" id="%1$s_W">
                    <div class="card">
                        <div class="card-block b-title b-title-award">
                          <h5 class="card-title ng-binding">Women</h5>
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
                      <span class="award-place ng-binding">%2$s</span>
                      <h6 class="card-title">P%2$s<span>%3$s</span></h6>
                      <p class="card-text">%5$s</p>
                      <!--<a href="#" class="btn btn-primary"></a>-->
                </div>
            </div>',$award['agegroup'],$position,$award['pcat'],$award['display_name'],$award['racetime']);
    }
}
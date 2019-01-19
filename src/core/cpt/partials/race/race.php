<?php
get_header();
$results = get_query_var('raceResultTable');
$teams = get_query_var('teamResultTable');
echo sprintf('
<div class="container_wrap">
    <div class="container">
        <div class="content">
        <!-- https://www.quackit.com/bootstrap/bootstrap_4/tutorial/bootstrap_navs.cfm -->
        <ul class="nav nav-tabs">
          <li class="nav-item"><a class="nav-link active" role="tab" data-toggle="tab" href="#results">Results</a></li>
          <li class="nav-item"><a class="nav-link" role="tab" data-toggle="tab" href="#teams">Teams</a></li>
          <li class="nav-item"><a class="nav-link" role="tab" data-toggle="tab" href="#awards">Awards</a></li>
          <li class="nav-item"><a class="nav-link" role="tab" data-toggle="tab" href="#standards">Standards</a></li>
        </ul>   
        <div class="tab-content">
          <div id="results" class="tab-pane fade show active" role="tabpanel" aria-labelledby="home-tab">%s</div>
          <div id="teams" cclass="tab-pane fade show" role="tabpanel">%s</div>
          <div id="awards" cclass="tab-pane fade show" role="tabpanel">Awards</div>
          <div id="standards" cclass="tab-pane fade show" role="tabpanel">Standards</div>
        </div>
        </div>
    </div>
</div>',$results,$teams);
get_footer();
?>
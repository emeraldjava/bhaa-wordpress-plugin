<div class="container-fluid">
    <div class="row row-striped">
        <!--<div class="col-lg-1">Place</div>-->
        <div class="col-lg-3">P - Name (Status/ID)</div>
        <div class="col-lg-2" title="DOB/Age">DOB(Age)</div>
        <div class="col-lg-2" title="Gen/Category/(posincat)">Gen/Cat/Pos</div>
        <div class="col-lg-1">Company</div>
        <div class="col-lg-1" title="Standard->[Actual]->Post Standard(posinstd)">Std</div>
        <!--<div class="col-lg-1" title="Points - Position in Scoring Set">League</div>-->
        <div class="col-lg-2">Time(Pace)</div>
    </div>
    {{# runners}}
    <div class="row row-striped" id="id">
        <!--<div class="col-lg-1"></div>-->
        <div class="col-lg-3">
            <a target="_self" class="bhaa-url-link" href="./admin.php?page=bhaa_edit_raceresult&raceresult={{id}}">{{position}}</a> -
            <a class="bhaa-url-link" r="{{runner}}" href="./admin.php?page=bhaa_admin_runner&id={{runner}}">{{firstname}} {{surname}}</a><span>({{isMember}}/{{runner}})</span>
        </div>
        <div class="col-lg-2">{{dob}}({{age}})</div>
        <div class="col-lg-2">{{gender}}->{{agecategory}}/({{posincat}})</div>
        <div class="col-lg-1"><a class="bhaa-url-link" href="/?post_type=house&p={{cid}}">{{cname}}</a></div>
        <div class="col-lg-1">{{standard}}->[{{actualstandard}}]->{{poststandard}}({{posinstd}})</div>
        <div class="col-lg-2">{{racetime}}({{pace}})</div>
    </div>
    {{/ runners}}
</div>
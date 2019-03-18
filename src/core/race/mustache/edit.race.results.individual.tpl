<div class="container-fluid">
    <div class="row row-striped">
        <div class="col-sm-1">Place</div>
        <div class="col-sm-2">Name [ID/IsMember]</div>
        <div class="col-sm-1" title="category/gender(posincat)">Gen/Age/Cat/Pos</div>
        <div class="col-sm-2">Company</div>
        <div class="col-sm-1" title="Standard->[Actual]->Post Standard(posinstd)">Std</div>
        <div class="col-sm-1" title="Points - Position in Scoring Set">League</div>
        <div class="col-sm-1">Time/Pace</div>
    </div>
    {{# runners}}
    <div class="row row-striped" id="{{id}}">
        <div class="col-sm-1">
            <a target="_self" class="bhaa-url-link" href="./admin.php?page=bhaa_edit_raceresult&raceresult={{id}}">{{position}}</a>
        </div>
        <div class="col-sm-2"><a class="bhaa-url-link" r="{{runner}}" href="./admin.php?page=bhaa_admin_runner&id={{runner}}">{{firstname}} {{surname}}</a> {{id}}/{{isMember}}</div>
        <div class="col-sm-1">{{gender}}:{{age}}->{{agecategory}}({{posincat}})</div>
        <div class="col-sm-2"><a class="bhaa-url-link" href="/?post_type=house&p={{cid}}">{{cname}}</a></div>
        <div class="col-sm-1">{{standard}}->[{{actualstandard}}]->{{poststandard}}({{posinstd}})</div>
        <div class="col-sm-1">{{leaguepoints}}-{{posinsss}}/{{standardscoringset}}</div>
        <div class="col-sm-1">{{racetime}}/{{pace}}</div>
    </div>
    {{/ runners}}
</div>
<div class="container-fluid">
    <div class="row row-striped">
        <div class="col-sm-1">Place</div>
        <div class="col-sm-2">Name / Number</div>
        <div class="col-sm-1">Cat</div>
        <div class="col-sm-2">Company</div>
        <div class="col-sm-1">Std</div>
        <div class="col-sm-1">League</div>
        <div class="col-sm-2">Time / Pace</div>
    </div>
    {{# runners}}
    <div class="row row-striped" id="{{id}}">
        <div class="col-sm-1">
            {{#isAdmin}}
            <a target="_self" class="bhaa-url-link" href="./admin.php?page=bhaa_admin_raceresult&raceresult={{id}}">{{position}}</a>{{/isAdmin}}{{^isAdmin}}{{position}}
            {{/isAdmin}}
        </div>
        <div class="col-sm-2"><a class="bhaa-url-link" r="{{runner}}" href="./admin.php?page=bhaa_admin_runner&id={{runner}}">{{firstname}} {{surname}}</a> - {{racenumber}}</div>
        <div class="col-sm-1">{{category}}{{gender}} p{{posincat}}</div>
        <div class="col-sm-2"><a class="bhaa-url-link" href="/?post_type=house&p={{cid}}">{{cname}}</a></div>
        <div class="col-sm-1">{{standard}}->[{{actualstandard}}]->{{poststandard}} {{posinstd}}</div>
        <div class="col-sm-1">{{standardscoringset}} / {{posinsss}} - {{leaguepoints}}</div>
        <div class="col-sm-2">{{racetime}} / {{pace}}</div>
    </div>
    {{/ runners}}
</div>
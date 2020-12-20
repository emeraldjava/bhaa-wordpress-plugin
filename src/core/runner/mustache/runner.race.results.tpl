<div class="container-fluid">
    <h3>Runner: {{fullname}}</h3>
    <div class="row">
        <div class="col-5">Event</div>
        <!--<th>Date</th>-->
        <div class="col-2">Distance</div>
        <div class="col-1">Pos</div>
        <div class="col-2">Time</div>
        <div class="col-1">Std</div>
        <div class="col-1">Points</div>
    </div>
    {{# races}}
    <div class="row" id="{{id}}">
        <div class="col-5"><a class='bhaa-url-link' href='{{url}}/race/{{race_name}}'><b>{{race_name}}</b></a></div>
        <!--<div>{{race_date}}</div>-->
        <div class="col-2">{{race_distance}} {{race_unit}}</div>
        <div class="col-1">{{position}}</div>
        <div class="col-2">{{racetime}}</div>
        <div class="col-1">{{standard}}</div>
        <div class="col-1">{{leaguepoints}}</div>
    </div>
    {{/ races}}
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-6">Event</div>
        <!--<th>Date</th>-->
        <div class="col-sm-2">Distance</div>
        <div class="col-sm-1">Pos</div>
        <div class="col-sm-2">Time</div>
        <div class="col-sm-1">Std</div>
    </div>
    {{# races}}
    <div class="row" id="{{id}}">
        <div class="col-sm-6"><a class='bhaa-url-link' href='{{url}}/race/{{race_name}}'><b>{{event_name}}</b></a></div>
        <!--<div>{{race_date}}</div>-->
        <div class="col-sm-2">{{race_distance}} {{race_unit}}</div>
        <div class="col-sm-1">{{position}}</div>
        <div class="col-sm-2">{{racetime}}</div>
        <div class="col-sm-1">{{standard}}</div>
    </div>
    {{/ races}}
</div>
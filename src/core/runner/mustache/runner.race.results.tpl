<div class="container">
    <table class="table table-sm table-striped table-bordered" width="100%">
        <tr>
            <th>Event</th>
            <!--<th>Date</th>-->
            <th>Distance</th>
            <th>Pos</th>
            <th>Time</th>
            <th>Std</th>
        </tr>
        {{# runners}}
        <tr>
            <td><a class='bhaa-url-link' href='{{url}}/race/{{race_name}}'><b>{{event_name}}</b></a></td>
            <!--<td>{{race_date}}</td>-->
            <td>{{race_distance}} {{race_unit}}</td>
            <td>{{position}}</td>
            <td>{{racetime}}</td>
            <td>{{standard}}</td>
        </tr>
        {{/ runners}}
    </table>
</div>
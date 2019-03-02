<div class="container-fluid">
 {{#runners}}
    <div class="row row-striped" id="{{id}}">
        <div class="col-5"><a href="{{formUrl}}/runner?id={{runner}}">P{{position}} - {{firstname}} {{surname}}</a></div>
        <div class="col-4 company">Company: <a href="{{formUrl}}/house/{{cname}}">{{ctitle}}</a></div>
        <div class="col-3">Time: {{racetime}}</div>
    </div>
    <div class="row row-striped row-minor">
        <div class="col-5 ">Cat: {{gender}}{{category}} ({{posincat}})</div>
        <div class="col-4">Std: {{standard}}</div>
        <div class="col-3"><i>Bib</i>: {{racenumber}}</div>
    </div>
{{/runners}}
</div>

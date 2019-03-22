<div class="container-fluid">
 {{#runners}}
    <div class="row row-striped" id="{{id}}">
        <div class="col-5"><a href="{{formUrl}}/runner?id={{runner}}">P{{position}} - {{firstname}} {{surname}}</a></div>
        <div class="col-4 company">Company: <a href="{{formUrl}}/house/{{cname}}">{{ctitle}}</a></div>
        <div class="col-3">Time: {{racetime}}</div>
    </div>
    <div class="row row-striped row-minor">
        <div class="col-5 "><i>Bib</i>: {{racenumber}} <span><i>Cat: </i>{{gender}}{{category}}</span></div>
        <div class="col-4"><i>Std</i>: {{standard}}</div>
        <div class="col-3"><i>Pace</i>: {{pace}}</div>
    </div>
{{/runners}}
</div>

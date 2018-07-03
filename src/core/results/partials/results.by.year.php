<?php
get_header();
?>
<div class="container_wrap">
    <h2>Results by Year 2018</h2>
    <div class="container">';
        <div class="col-8">Races<?php echo do_shortcode('[bhaa_races_by_year]');?></div>
        <div class="col-4">Leagues<?php echo do_shortcode('[bhaa_leagues_by_year]');?></div>
    </div>
</div>
<?php
get_footer();
?>
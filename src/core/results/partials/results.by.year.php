<?php
get_header();
// https://digwp.com/2010/10/dynamic-archives/
?>
<div class="container-fluid">
    <h3>BHAA Results by Year <?php echo $year ?></h3>
    <div class="row">
        <div class="col-6">Races<?php echo do_shortcode('[bhaa_races_by_year]');?></div>
        <div class="col-4">Leagues<?php echo do_shortcode('[bhaa_leagues_by_year]');?></div>
        <div class="col-2">Years<?php echo $years; ?></div>
    </div>
</div>
<?php
get_footer();
?>
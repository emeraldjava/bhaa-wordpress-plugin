<?php
get_header();
// https://digwp.com/2010/10/dynamic-archives/
?>
<div class="container-fluid">
    <h3>BHAA Results by Year <?php echo $year ?></h3>
    <div class="row">
        <div class="col-8">Races:</div>
        <div class="col-4">Years:</div>
    </div>
    <div class="row">
        <div class="col-8"><?php echo $racesByYearList; ?></div>
        <div class="col-4"><?php echo $years; ?></div>
    </div>
</div>
<?php
get_footer();
?>
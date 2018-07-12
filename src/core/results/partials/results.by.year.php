<?php
get_header();
// https://digwp.com/2010/10/dynamic-archives/
?>
<div class="container-fluid">
    <h3>BHAA Results by Year <?php echo $year ?></h3>
    <div class="row">
        <div class="col-6">Races:</div>
        <div class="col-4">Leagues:</div>
        <div class="col-2">Years:</div>
    </div>
    <div class="row">
        <div class="col-6"><?php echo $racesByYearList; ?></div>
        <div class="col-4"><?php echo $leaguesByYearList;?></div>
        <div class="col-2"><?php echo $years; ?></div>
    </div>
</div>
<?php
get_footer();
?>
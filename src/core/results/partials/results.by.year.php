<?php
get_header();
// https://digwp.com/2010/10/dynamic-archives/
?>
<div class="container-fluid">
    <div class="content">
        <h3>BHAA Races in Year <?php echo $year ?></h3>
        <div class="row row-striped">
            <div class="col-9">Races</div>
            <div class="col-3">Years</div>
        </div>
        <div class="row">
            <div class="col-9"><?php echo $racesByYearList; ?></div>
            <div class="col-3"><?php echo $years; ?></div>
        </div>
    </div>
</div>
<?php
get_footer();
?>
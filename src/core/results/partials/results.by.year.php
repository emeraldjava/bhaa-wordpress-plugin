<?php
get_header();
// https://digwp.com/2010/10/dynamic-archives/
?>
<div class="container_wrap">
    <h3>BHAA Results by Year <?php echo $year ?>.</h3>

    <?php wp_get_archives(array('type'=>'yearly','format'=>'html','before'=>'/results','post_type'=>'race'));?>

    <hr/>


    <div class="container">
        <form id="year_form" method="POST" action="">
            <select name="year" id="year">
                <?php wp_get_archives(array('type'=>'yearly','format'=>'option','post_type'=>'race'));?>
            </select>
            <input type="submit" name="Search"/>
        </form>
        <hr/>
        <div class="col-8">Races<?php echo do_shortcode('[bhaa_races_by_year]');?></div>
        <div class="col-4">Leagues<?php echo do_shortcode('[bhaa_leagues_by_year]');?></div>
    </div>
</div>
<?php
get_footer();
?>
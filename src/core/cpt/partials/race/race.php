<?php
get_header();
echo '<div class="container_wrap">
    <div class="container">
    <div class="content">';
//echo do_shortcode('[bhaa_race_title]');
include_once('menu.php');
?>
<!--    <nav class="nav">-->
<!--        <a class="nav-link active" href="#">HTML</a>-->
<!--        <a class="nav-link" href="#">CSS</a>-->
<!--        <a class="nav-link" href="#">JavaScript</a>-->
<!--        <a class="nav-link" href="#">Preview</a>-->
<!--    </nav>-->



<?php
echo '<h2>Individual Results</h2>';
echo get_query_var('raceResultTable');

echo '<h2>Team Results</h2>';
echo get_query_var('teamResultTable');

echo '</div></div></div>';
get_footer();
?>
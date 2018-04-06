<?php
get_header();
echo '<div class="container_wrap">
    <div class="container">
    <div class="content">';
//echo do_shortcode('[bhaa_race_title]');
echo get_query_var('raceResultTable');
echo '</div></div></div>';
get_footer();
?>
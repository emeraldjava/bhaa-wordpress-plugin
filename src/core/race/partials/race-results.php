<?php
get_header();
echo '<div class="container-fluid">
    <div class="container">
        <div class="content">';
            include_once('menu.php');
            echo '<h2>Individual Results</h2>';
            echo get_query_var('raceResultTable');
echo '</div></div></div>';
get_footer();
?>
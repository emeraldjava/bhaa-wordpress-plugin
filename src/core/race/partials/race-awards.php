<?php



get_header();


echo '<div class="container_wrap">
    <div class="container">
    <div class="content">';
include_once('menu.php');
echo '<h1>Awards</h1>';

$awards = get_query_var('awards');
//var_dump(get_query_var('awards'));
echo $awards;

//echo '<h2>Individual Results</h2>';
//echo get_query_var('raceResultTable');

//echo '<h2>Team Results</h2>';
//echo get_query_var('teamResultTable');

echo '</div></div></div>';
get_footer();
?>
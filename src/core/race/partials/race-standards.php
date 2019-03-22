<?php
get_header();
echo '<div class="container_wrap">
    <div class="container">
    <div class="content">';
include_once('menu.php');
echo '<h1>Standards</h1>';
echo do_shortcode('[bhaa_standard_table]');
echo '</div></div></div>';
get_footer();
?>
<?php
get_header();
echo '<div class="container">';
echo the_title('<h2 class="main-title entry-title">','</h2>');
echo '<div class="container">';
echo '<div class="content">';
echo '<div id="division'.$wp_query->query_vars['division'].'">Back to <a href="'.get_permalink().'">'.get_the_title().'</a> Division '.$wp_query->query_vars['division'].'</div>';
echo do_shortcode('[bhaa_league division='.$wp_query->query_vars['division'].' top=1000]');
echo '</div></div></div>';
get_footer();
?>
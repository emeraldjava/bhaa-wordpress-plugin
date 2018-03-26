<?php
get_header();
echo '<div class="wrap">
	<div id="primary" class="content-area">
		<main id="main" class="site-main" role="main">';
echo get_query_var('raceResultTable');
echo '</div></div></div>';
get_footer();
?>
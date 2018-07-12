<?php
get_header();
echo '<div class="stretch_full container_wrap alternate_color light_bg_color title_container">
<div class="container">';
echo the_title('<h2 class="main-title entry-title">','</h2>');
//echo '<div class="breadcrumb breadcrumbs avia-breadcrumbs">
//<div xmlns:v="http://rdf.data-vocabulary.org/#" class="breadcrumb-trail">
//<span class="trail-before"><span class="breadcrumb-title">
//You are here:</span></span> <span typeof="v:Breadcrumb">
//<a class="trail-begin" title="Business Houses Athletic Association Dublin" href="http://bhaa.ie" property="v:title" rel="v:url">Home</a></span> <span class="sep">/</span> <span typeof="v:Breadcrumb"><span class="trail-end">Leagues</span></span></div></div></div></div>';
//echo '<div class="container_wrap container_wrap_first main_color fullsize">';
echo '<div class="content">';
echo '<div class="row">';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=M top=10]').'</div>';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=W top=10]').'</div>';
echo '</div>';
echo '</div>';
echo '</div>';
//if($data['blog_comments']):
//	wp_reset_query();
//	comments_template();
//endif;
get_footer();
?>
<?php
get_header();

echo '<div class="container">';

echo '<div class="row">';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=A top=10]').'</div>';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=B top=10]').'</div>';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=L1 top=10]').'</div>';
echo '</div>';

echo '<div class="row">';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=C top=10]').'</div>';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=D top=10]').'</div>';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=L2 top=10]').'</div>';
echo '</div>';

echo '<div class="row">';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=E top=10]').'</div>';
echo '<div class="col-sm">'.do_shortcode('[bhaa_league division=F top=10]').'</div>';
echo '</div>';

echo '</div>';

get_footer();
?>
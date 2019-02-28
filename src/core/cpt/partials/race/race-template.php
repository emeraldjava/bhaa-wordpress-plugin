<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo( 'charset' ); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="profile" href="http://gmpg.org/xfn/11">

    <?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>

<div  id="page-top" class="header-top">
    <?php mesmerize_print_header_top_bar(); ?>
    <?php mesmerize_get_navigation(); ?>
</div>

<div id="page" class="site">
    <div class="header-wrapper">
        <div <?php echo mesmerize_header_background_atts(); ?>>
            <?php //do_action( 'mesmerize_before_header_background' ); ?>
            <?php //mesmerize_print_video_container(); ?>


            <div class="inner-header-description gridContainer">
                <div class="row header-description-row">
                    <div class="col-xs col-xs-12">
                        <h1 class="hero-title"><?php echo esc_html("H".get_the_title());?></h1>
                        <p class="header-subtitle"><?php echo esc_html("P".get_the_title()); ?></p>
                    </div>
                </div>
            </div>

            <?php //mesmerize_print_inner_pages_header_content(); ?>
            <?php //mesmerize_print_header_separator(); ?>
        </div>
    </div>

<?php
//get_header();

$results = get_query_var('raceResultTable');
$teams = get_query_var('teamResultTable');
echo sprintf('
<div class="container_wrap">
    <div class="container">
        <div class="content">
        <!-- https://www.quackit.com/bootstrap/bootstrap_4/tutorial/bootstrap_navs.cfm -->
        <ul class="nav nav-tabs">
          <li class="nav-item"><a class="nav-link active" role="tab" data-toggle="tab" href="#results">Results</a></li>
          <li class="nav-item"><a class="nav-link" role="tab" data-toggle="tab" href="#teams">Teams</a></li>
          <li class="nav-item"><a class="nav-link" role="tab" data-toggle="tab" href="#awards">Awards</a></li>
          <li class="nav-item"><a class="nav-link" role="tab" data-toggle="tab" href="#standards">Standards</a></li>
        </ul>   
        <div class="tab-content">
          <div id="results" class="tab-pane fade show active" role="tabpanel" aria-labelledby="home-tab">%s</div>
          <div id="teams" class="tab-pane fade show" role="tabpanel">%s</div>
          <div id="awards" class="tab-pane fade show" role="tabpanel">Awards</div>
          <div id="standards" class="tab-pane fade show" role="tabpanel">Standards</div>
        </div>
        </div>
    </div>
</div>',$results,$teams);
get_footer();
?>
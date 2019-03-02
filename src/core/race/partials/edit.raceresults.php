<?php
$link = admin_url('admin.php');
$race = get_the_title($_GET['id']);
$edit = get_edit_post_link($_GET['id']);
// Wurdpress UI layoyt & admin meta boxes
// https://code.tutsplus.com/articles/integrating-with-wordpress-ui-meta-boxes-on-custom-pages--wp-26843
// https://wordpress.stackexchange.com/questions/99107/add-screen-options-to-custom-admin-pages?rq=1
echo '<div class="wrap">';
echo '<div id="icon-my-id" class="icon32"><br/></div>';
//echo printf(
//    '<h2> %s <a href="%s" > %s </a></h2>',
//    esc_html__('Page Title','plugin_domain'),
//    esc_url(admin_url('admin.php?page=my-link-to-add-new')),
//    esc_html__('Add New','plugin_domain')
//);
// TODO - have admin menu in the area
echo '<hr/>';
echo $race.' <div><a href="'.$edit.'">Back to Wordpress Post</a> / <a target="_new" href="'.get_permalink($_GET['id']).'">View</a> / <a href="something">These are tabs</a></div>';
echo '<hr/>';
echo '<div>Have a row of actions to the update the BHAA columns below</div>';
echo '<hr/>'
//
?>
    <div id="poststuff">

        <div id="post-body" class="metabox-holder columns-2">
             <div id="post-body-content">
                <?php echo get_query_var('raceResultTable'); ?>
            </div>

            <div id="postbox-container-1" class="postbox-container">
                <?php echo get_query_var('bhaa_race_admin_url_links'); ?>
            </div>
<!---->
<!--            <div id="postbox-container-2" class="postbox-container">-->
<!--                <php do_meta_boxes('','normal',null); ?>-->
<!--                <php do_meta_boxes('','advanced',null); ?>-->
<!--            </div>-->
        </div>
    </div>

</div>

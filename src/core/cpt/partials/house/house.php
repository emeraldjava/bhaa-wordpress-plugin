<?php

use BHAA\core\Connections;
use BHAA\core\house\House;

get_header();
echo '<div class="container_wrap">
    <div class="container">
    <div class="content">';

$house = get_query_var('house');

$teamtype = wp_get_post_terms($post->ID,'teamtype');
$connected_type = Connections::HOUSE_TO_RUNNER;
if(isset($teamtype[0]) && $teamtype[0]->name=='sector') {
    $connected_type = Connections::SECTORTEAM_TO_RUNNER;
}
$users = get_users( array(
    'connected_type' => $connected_type,
    'connected_items' => $post->ID,
    'fields' => 'all_with_meta',
    'orderby' => 'display_name',
    'order' => 'ASC'
));

$usersByCompanyArgs = new WP_User_Query(
    array(
        //'exclude' => array($user->ID),
        'fields' => 'all_with_meta',
        'orderby' => 'bhaa_runner_dateofrenewal',
        'meta_query' => array(
            //'relation' => 'AND',
            array(
                'key' => 'bhaa_runner_company',
                'value' => $post->ID,
                'compare' => '=')
        )
    )
);
//var_dump($usersByCompanyArgs);
//$userQuery = new WP_User_Query( $usersByCompanyArgs );
//var_dump($userQuery);

//$users = $usersByCompanyArgs->get_results();
//$house = new HouseCpt($post->ID);
//$house = $post;
//$users = $house->getRunners();

echo '<p>'.get_the_term_list(get_the_ID(), 'sector', 'Sector : ', ', ', '').'</p>';
echo '<p>Team Name: '.$post->post_title.'</p>';
    //'<p>Team Type: '.$teamtype[0]->name.'</p>'.
//echo '<p>Website:<a target="new" href="'.get_post_meta(get_the_ID(),'bhaa_company_website',true).'">'.get_the_title().'</a></p>';
echo get_the_post_thumbnail(get_the_ID(), 'thumbnail');

if(current_user_can('edit_users')) {
    //echo sprintf('<h4><a href="%s">Edit Runners Linked to %s</a></h4>',get_edit_post_link(get_the_ID()),get_the_title());
}
else {
    echo '<h4>Runners Linked to the Team</h4>';
}
?>
<table class="table-1">
    <tr>
        <th>Name</th>
        <th>Gender</th>
        <th>Standard</th>
        <th>Membership Status</th>
    </tr>
    <?php foreach ( $users AS $user ) : ?>
        <tr>
            <?php
            $page = get_page_by_title('runner');
            $permalink = get_permalink( $page );
            echo sprintf('<td><b><a href="%s">%s</a></b></td><td>%s</td><td>%s</td><td>%s</td>',
                add_query_arg(array('id'=>$user->ID), $permalink ),
                $user->display_name,
                $user->get('bhaa_runner_gender'),
                $user->get('bhaa_runner_standard'),
                //$user->get('bhaa_runner_dateofrenewal').' '.
                $user->get('bhaa_runner_status')
            );
            ?>
        </tr>
    <?php endforeach; ?>
</table>

<?php
//echo BHAA::get_instance()->getTeamResultsForHouse(get_the_ID());
//echo $post->post_name;
//echo '[house_title][house_sector][house_website_url][house_image][house_runner_table]';

echo '</div></div></div>';
get_footer();
?>

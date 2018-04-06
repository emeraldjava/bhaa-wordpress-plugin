<?php
get_header();
echo '<div class="container_wrap">
    <div class="container">
    <div class="content">';

//object(stdClass)#2366 (4) { ["ID"]=> string(4) "5575" ["post_title"]=> string(11)
//// "AIB 2M 2018" ["racedate"]=> string(19) "2018-02-20 17:29:48" //
/// ["event"]=> string(15) "AIB/NUI CC 2018" }
foreach($races as $race) :
    echo sprintf('<div>%s</div>',$race->event);
    echo sprintf('<div>%d %s</div>',$race->ID,$race->post_title);
endforeach;

//echo var_dump($races[1]);
echo '</div></div></div>';
get_footer();
?>
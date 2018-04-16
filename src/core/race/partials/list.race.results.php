<?php
get_header();
echo '<div class="container_wrap">
    <div class="container">';

foreach($events as $event) :
    echo '<div class="row row-striped" id="'.$event->ID.'">';
        echo sprintf('<div>Event %s</div>',$event->eventname);
    if($event->racecount==1){
        echo '<div>Race <a href="'.get_permalink($event->race1).'">'.get_the_title($event->race1).'</a></div>';
    }   else {
        echo '<div>Races <a href="'.get_permalink($event->race1).'">'.get_the_title($event->race1).' - </a>';
        echo '<a href="'.get_permalink($event->race2).'">'.get_the_title($event->race2).'</a></div>';
    }
    echo '<div>League <a href="'.get_permalink($event->league).'">'.get_the_title($event->league).'</a></div>';
    echo '</div>';
endforeach;

echo '</div></div>';
get_footer();
?>
<div class="container">
<?php
foreach($leagues as $league) :
    echo '<div class="row" id="'.$league->ID.'">';
    echo '<a href="'.get_permalink($league->ID).'">'.get_the_title($league->ID).'</a>';
    echo '</div>';
endforeach;
?>
</div>
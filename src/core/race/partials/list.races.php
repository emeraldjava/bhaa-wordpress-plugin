<div class="container">
<?php
foreach($races as $race) :
    echo '<div class="row" id="'.$race->ID.'">';
    echo '<a href="'.get_permalink($race->ID).'">'.get_the_title($race->ID).'</a>';
    echo '</div>';
endforeach;
?>
</div>
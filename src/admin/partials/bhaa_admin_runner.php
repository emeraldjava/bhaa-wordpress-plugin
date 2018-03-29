<?php

?>
<div class="wrap">
    <h1>BHAA Runner Admin</h1>

    <?php //var_dump($runner);
    echo sprintf('<div>ID : %s</div>',$runner->getID());
    echo sprintf('<div>NAME : %s %s</div>',$runner->getFirstName(),$runner->getLastName());
    echo sprintf('<div>DOB : %s</div>',$runner->getDateOfBirth());

    echo var_dump($runner->getMetaData());
    ?>
</div>
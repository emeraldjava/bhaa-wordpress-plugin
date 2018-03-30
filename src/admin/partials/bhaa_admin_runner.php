<?php

?>
<div class="wrap">
    <h1>BHAA Runner Admin</h1>

    <?php //var_dump($runner);
    echo sprintf('<div>ID : %s</div>',$runner->getID());
    echo sprintf('<div>NAME : %s %s</div>',$runner->getFirstName(),$runner->getLastName());
    echo sprintf('<div>DOB : %s</div>',$runner->getDateOfBirth());
    echo sprintf('<div>Gender : %s</div>',$runner->getGender());
    echo sprintf('<div>Status : %s</div>',$runner->getStatus());
    echo sprintf('<div>DateOfRenewal : %s</div>',$runner->getDateOfRenewal());

    echo '<hr/>';

    echo sprintf('<div><form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_dob_action').'
			    <input type="hidden" name="action" value="bhaa_runner_dob_action"/>
				<input type="text" name="dob" value="'.$runner->getDateOfBirth().'"/>
				<input type="hidden" name="id" value="'.$runner->getID().'"/>
				<input type="submit" value="DateOfBirth"/>
				</form></div>');

    echo sprintf('<div><form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_gender_action').'
			    <input type="hidden" name="action" value="bhaa_runner_gender_action" />
				<input type="text" size=2 name="gender" id="gender" value="'.$runner->getGender().'"/>
				<input type="hidden" name="id" value="'.$runner->getID().'"/>
				<input type="submit" value="Gender"/>
				</form></div>');

    echo sprintf('<div><form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_renew_action').'
			    <input type="hidden" name="action" value="bhaa_runner_renew_action" />
				<input type="hidden" name="id" value="%d"/>
				<input type="submit" value="Renew Runner"/>
				</form></div>',
                $runner->getID());

    //echo var_dump($runner->getMetaData());
    ?>
</div>
<?php

?>
<div class="wrap">
    <h1>BHAA Runner Admin</h1>

    <?php //var_dump($runner);
    echo sprintf('<div>ID : %s</div>',$runner->getID());
    echo sprintf('<div>NAME : %s %s</div>',$runner->getFirstName(),$runner->getLastName());
    echo sprintf('<div>Email : %s</div>',$runner->getEmail());
    echo sprintf('<div>DOB : %s</div>',$runner->getDateOfBirth());
    echo sprintf('<div>Gender : %s</div>',$runner->getGender());
    echo sprintf('<div>Standard : %s</div>',$runner->getStandard());
    echo sprintf('<div>Status : %s</div>',$runner->getStatus());
    echo sprintf('<div>DateOfRenewal : %s</div>',$runner->getDateOfRenewal());

    echo '<hr/>';

    echo sprintf('<div>Name <form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_rename_action').'
                <input type="hidden" name="action" value="bhaa_runner_rename_action" />
				<input type="text" name="first_name" value="%s"/>
				<input type="text" name="last_name" value="%s"/>
				<input type="hidden" name="id" value="%d"/>
				<input type="submit" value="Rename"/>
				</form></div>',$runner->getFirstName(),$runner->getLastName(),$runner->getID());

    echo sprintf('<div>Email <form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_email_action').'
			    <input type="hidden" name="action" value="bhaa_runner_email_action"/>
				<input type="text" name="email" value="%s"/>
				<input type="hidden" name="id" value="%d"/>
				<input type="submit" value="Email"/>
				</form></div>',$runner->getEmail(),$runner->getID());
    
    echo sprintf('<div>Date of Birth <form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_dob_action').'
			    <input type="hidden" name="action" value="bhaa_runner_dob_action"/>
				<input type="text" name="dob" value="'.$runner->getDateOfBirth().'"/>
				<input type="hidden" name="id" value="'.$runner->getID().'"/>
				<input type="submit" value="DateOfBirth"/>
				</form></div>');

    echo sprintf('<div>Gender <form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_gender_action').'
			    <input type="hidden" name="action" value="bhaa_runner_gender_action" />
				<input type="text" size=1 name="gender" id="gender" value="'.$runner->getGender().'"/>
				<input type="hidden" name="id" value="'.$runner->getID().'"/>
				<input type="submit" value="Gender"/>
				</form></div>');

    echo sprintf('<div>Standard <form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_standard_action').'
			    <input type="hidden" name="action" value="bhaa_runner_standard_action" />
				<input type="text" size=1 name="standard" id="standard" value="'.$runner->getStandard().'"/>
				<input type="hidden" name="id" value="%d"/>
				<input type="submit" value="Standard"/>
				</form></div>',$runner->getID());

    // company
    if($runner->getCompany()!=null && $runner->getCompany()->ID != null) {
        echo sprintf('<div>Company <a href="%s">%s</a></div>',
            get_permalink($runner->getCompany()->ID),$runner->getCompany()->post_title);
    } else {
        echo "No Company";
    }

    // matching runners
//    if(true) {
//        $table = '<div>';
//        foreach ($matchedRunners as $matcheduser) {
//            $table .= sprintf('<div>%d <a href="%s">%s</a> DOB:%s, Status:%s, Email:%s <form action="'
//                . admin_url('admin.php') . '" method="POST">' .
//                wp_nonce_field('bhaa_runner_merge_action') . '
//                            <input type="hidden" name="action" value="bhaa_runner_merge_action"/>
//                            <input type="hidden" name="delete" value="%d"/>
//                            <input type="hidden" name="id" value="%d"/>
//                            <input type="submit" value="Delete %d and merge to %d"/>
//                            </form></div>',
//                $matcheduser->ID,
//                add_query_arg(array('id' => $matcheduser->ID), '/runner'), $matcheduser->display_name,
//                $matcheduser->bhaa_runner_dateofbirth, $matcheduser->bhaa_runner_status, $matcheduser->user_email,
//                $matcheduser->ID, $runner->getID(),
//                $matcheduser->ID, $runner->getID()
//            );
//        }
//        $table .= '</div>';
//        echo $table;
//    }
//    echo '<hr/>';

    echo sprintf('<div><form action="'.admin_url( 'admin.php' ).'" method="POST">'.
                wp_nonce_field('bhaa_runner_renew_action').'
                <input type="hidden" name="action" value="bhaa_runner_renew_action" />
                <input type="hidden" name="id" value="%d"/>
                <input type="submit" value="Renew Runner"/>
                </form></div>',$runner->getID());
    echo var_dump($runner->getMetaData());
    ?>
</div>
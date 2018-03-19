<?php

/**
 * Provide a admin area view for the plugin
 *
 * This file is used to markup the admin-facing aspects of the plugin.
 *
 * @link       http://example.com
 * @since      1.0.0
 */
?>
<!-- This file should primarily consist of HTML with a little bit of PHP. -->
<div class="wrap">
    <h1>BHAA Runners Admin</h1>

    <h2>Assign BHAA Members ID's to Role</h2>
    <div>
        <form action="<?php echo admin_url('admin.php')?>" method="POST">
            <?php wp_nonce_field('bhaa_runner_assign_to_role')?>
            <input type="hidden" name="action" value="bhaa_runner_assign_to_role"/>
            <input type="text" name="members" value=""/>
            <input type="submit" value="Assign Role"/>
        </form>
        <div><p><?php echo $this->runnerAdminMessage?></p></div>
    </div>
</div>
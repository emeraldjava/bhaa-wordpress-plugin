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
    <h1>BHAA Admin Page</h1>

    <h2>BHAA Membership</h2>
    <form method="POST" action="<?php echo admin_url( 'admin.php' ); ?>">
        <?php wp_nonce_field( 'bhaa_export_members' ); ?>
        <input type="hidden" name="action" value="bhaa_export_members" />
        <input type="submit" value="Export Member Details" />
    </form>
</div>
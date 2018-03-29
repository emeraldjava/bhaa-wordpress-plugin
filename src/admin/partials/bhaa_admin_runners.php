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

    <table border="1">
        <tbody>
        <tr>
            <th>BHAA ID</th>
            <th>Athlete</th>
        </tr>
        <?php
        if ( ! empty( $user_query->results ) ) {
            foreach ( $user_query->results as $user ) {
                echo sprintf('<tr><td>%d</td><td>%s</td></tr>',
                    $user->ID,
                    $user->display_name);
            }
        }
        ?>
        </tbody>
    </table>
</div>
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
    <ul>
        <li><?php echo $exportBHAAMembersLink;?></li>
        <li><?php echo $exportBHAAInactiveMembersLink;?></li>
        <li><?php echo $exportBHAADayMembersLink;?></li>
        <li><?php echo $exportEventMembersLink;?></li>
    </ul>
    <hr/>
    <?php echo $exportNewBHAAMembersLink;?>
</div>
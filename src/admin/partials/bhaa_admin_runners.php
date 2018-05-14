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
    <h1>BHAA EE Registered Admin</h1>
    <table border="1">
        <tbody>
        <tr>
            <th>ID</th>
            <th>Event</th>
            <th>REG</th>
            <th>PAID</th>
            <th>Status</th>
            <th>EE_S</th>
            <th>Gen</th>
            <th>ee_Gen</th>
            <th>Com</th>
            <th>ee_com</th>
            <th>Dob</th>
            <th>ee_dob</th>
        </tr>
        <?php
        foreach ( $rows as $row ) {
            $ee_company=$row->ee_company;
            if($row->ee_company_id!=0)
                $ee_company = sprintf('<a href="%s">%s %d</a>',get_edit_post_link($row->ee_company_id),$row->ee_company,$row->ee_company_id);

            echo sprintf('<tr><td><a href="./admin.php?page=bhaa_admin_runner&id=%d">%d %s</a></td><td>%d</td>
                <td>%d</td><td>%d</td>
                <td>%s</td><td>%s</td>
                <td>%s</td><td>%s</td>
                <td>%s</td><td>%s</td>
                <td>%s</td><td>%s</td>
                </tr>',
                $row->id,$row->id,$row->label,$row->EVT_ID,
                $row->reg_id,$row->paid,
                $row->m_status,$row->capability,
                $row->m_gender,$row->ee_gender,
                $row->m_company,$ee_company,
                $row->m_dob,$row->ee_dob);
        }
        ?>
        </tbody>
    </table>
</div>
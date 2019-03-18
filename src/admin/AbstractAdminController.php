<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 15/05/2018
 * Time: 14:38
 */

namespace BHAA\admin;


class AbstractAdminController {

    protected $wpFlashMessages;

    function __construct() {
        $this->wpFlashMessages = new WPFlashMessages();
    }

    function flashMessage($message, $class = null) {
        $this->wpFlashMessages->queue_flash_message($message,$class);
    }
}

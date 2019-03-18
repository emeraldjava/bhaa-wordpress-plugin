<?php

namespace BHAA\admin;

class WPFlashMessages {

    // Flash Messages
    public function queue_flash_message($message, $class = null) {
        $class = ($class === null) ? 'updated' : $class;
        $flash_messages = maybe_unserialize(get_option('wp_flash_messages', ''));
        if(!is_array($flash_messages)) $flash_messages = array();
        //if(!is_array($flash_messages[$class])) $flash_messages[$class] = array();
        $flash_messages[$class][] = $message;
        update_option('wp_flash_messages', serialize($flash_messages));
    }

    public function show_flash_messages() {
        $flash_messages = unserialize(get_option('wp_flash_messages', serialize('')));
        if(is_array($flash_messages)) {
            foreach($flash_messages as $class => $messages) {
                foreach($messages as $message) {
                    ?><div class="<?php echo $class; ?>"><p><?php echo $message; ?></p></div><?php
                    }
                }
            }
            //empty out flash messages
            update_option('wp_flash_messages', serialize(''));
        }
    }
?>
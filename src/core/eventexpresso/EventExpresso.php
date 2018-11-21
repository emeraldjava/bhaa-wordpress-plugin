<?php

namespace BHAA\core\eventexpresso;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;

class EventExpresso implements Loadable {

    public function registerHooks(Loader $loader) {
        //$loader->add_action('init',$this,'bhaa_register_race_cpt');

        $loader->add_filter('admin_footer_text', array($this, 'bhaa_ee_remove_footer_text'), 11);
        $loader->add_filter(
            'FHEE__EED_WP_Users_Ticket_Selector__maybe_restrict_ticket_option_by_cap__no_access_msg',
            array($this, 'bhaa_ee_member_no_access_message'), 10, 4
        );

        // add_action( 'AHEE__SPCO__reg_form_footer', array($this,'bhaa_jf_change_ee_reg_form_datepicker_format'), 10 );

        //add_filter('FHEE__EEM_Question__construct__allowed_question_types',
        //    array($this,'bhaa_ee_add_question_type_as_options'), 10, 1 );
        //add_filter('FHEE__EE_SPCO_Reg_Step_Attendee_Information___generate_question_input__default',
        //    array($this,'bhaa_ee_generate_question'), 10, 4 );

        $loader->add_filter('FHEE__EE_SPCO_Reg_Step_Attendee_Information___generate_question_input__input_constructor_args',
            array($this, 'bhaa_ee_question_input'), 10, 4
        );

        //return apply_filters('FHEE__EEM_Answer__get_attendee_question_answer_value__answer_value', $value, $registration, $question_id, $question_system_id);

        //add_action('pre_get_posts',
        //    array($this,'bhaa_ee_add_espresso_events_to_posts'), 10, 1 );
        //add_action('AHEE__EED_WP_Users_SPCO__process_wpuser_for_attendee__user_user_created',
        //    array($this,'bhaa_ee_user_created'), 10, 4);
        //add_action('AHEE__EED_WP_Users_SPCO__process_wpuser_for_attendee__user_user_updated',
        //    array($this,'bhaa_ee_user_updated'), 10, 3);
    }

    function bhaa_ee_add_question_type_as_options($question_types) {
        $question_types['bhaa_house'] = __('BHAA_House', 'house');
        return $question_types;
    }

    function bhaa_ee_generate_question($input, $question_type, $question_obj, $options) {
        error_log('bhaa_ee_generate_question');
        if (!$input && $question_type === 'bhaa_house') {
            require 'CompanyPostTypeInput.php';
            $options['post_type'] = array('house');
            $input = new CompanyPostTypeInput($options);
        }
        return $input;
    }

    function bhaa_ee_question_input($input_args, EE_Registration $registration = null, EE_Question $question = null, EE_Answer $answer = null) {
        return $input_args;
    }

    function bhaa_ee_user_created($user, $attendee, $registration, $password) {
        //        if( $registration instanceof EE_Registration ) {
        //            $debug_info['Registration_ID'] = $registration->ID();
        //        }
        //        if( $user instanceof WP_User ) {
        //            $debug_info['WP_User'] = array(
        //                'User_id' => $user->ID,
        //                'roles' => $user->roles
        //            );
        //        }
        //        error_log(print_r($debug_info, true));
        error_log($user);
    }

    function bhaa_ee_user_updated($user, $attendee, $registration) {
        error_log($user);
    }

    function bhaa_jf_change_ee_reg_form_datepicker_format() {
        echo "<script>
            jQuery(document).ready(function($) {
            $('.datepicker').datepicker({
                changeYear: true,
                yearRange: '1920:2000',
                dateFormat: 'yy-mm-dd'
            });
        });
        </script>";
    }

    /**
     * Display a login message to BHAA members for restricted tickets.
     * https://eventespresso.com/wiki/wp-user-integration/#ee4customizations
     */
    function bhaa_ee_member_no_access_message($content, $tkt, $ticket_price, $tkt_status) {
        $url = wp_login_url(get_permalink());
        $content = $tkt->name() . ' becomes available if you log in to your account. ';
        $content .= 'BHAA Members can <a href="' . $url . '" title="Log in">log in here</a>.';
        return $content;
    }

    // https://eventespresso.com/wiki/useful-php-code-snippets/
    function bhaa_ee_remove_footer_text() {
        remove_filter('admin_footer_text', array('EE_Admin', 'espresso_admin_footer'), 10);
    }

    // Add events to the post feed. via https://eventespresso.com/wiki/useful-php-code-snippets/
    function bhaa_ee_add_espresso_events_to_posts($WP_Query)
    {
        if ($WP_Query instanceof WP_Query && ($WP_Query->is_feed || $WP_Query->is_posts_page
                || ($WP_Query->is_home && !$WP_Query->is_page) || (isset($WP_Query->query_vars['post_type'])
                    && ($WP_Query->query_vars['post_type'] == 'post' || is_array($WP_Query->query_vars['post_type'])
                        && in_array('post', $WP_Query->query_vars['post_type']))))) {
            //if post_types ARE present and 'post' is not in that array, then get out!
            if (isset($WP_Query->query_vars['post_type']) && $post_types = (array)$WP_Query->query_vars['post_type']) {
                if (!in_array('post', $post_types)) {
                    return;
                }
            } else {
                $post_types = array('post');
            }
            if (!in_array('espresso_events', $post_types)) {
                $post_types[] = 'espresso_events';
                $WP_Query->set('post_type', $post_types);
            }
            return;
        }
    }
}

<?php

namespace BHAA\core\eventexpresso;

use BHAA\core\runner\RunnerExpresso;
use BHAA\core\runner\RunnerManager;
use BHAA\utils\Loadable;
use BHAA\utils\Loader;

use EE_SPCO_Reg_Step_Attendee_Information;

/**
 * Handles the event expresso hook and filter functions for the BHAA wordpress plugin.
 * Class EventExpresso
 * @package BHAA\core\eventexpresso
 */
class EventExpresso implements Loadable {

    public function registerHooks(Loader $loader) {

        $loader->add_filter('admin_footer_text', $this, 'bhaa_ee_remove_footer_text', 11, 4);
        $loader->add_filter(
            'FHEE__EED_WP_Users_Ticket_Selector__maybe_restrict_ticket_option_by_cap__no_access_msg',
            $this, 'bhaa_ee_member_no_access_message', 10, 4
        );

        $loader->add_action( 'AHEE__SPCO__reg_form_footer', $this,'bhaa_jf_change_ee_reg_form_datepicker_format', 10 );

        //add_filter('FHEE__EEM_Question__construct__allowed_question_types',
        //    $this,'bhaa_ee_add_question_type_as_options'), 10, 1 );
        //add_filter('FHEE__EE_SPCO_Reg_Step_Attendee_Information___generate_question_input__default',
        //    $this,'bhaa_ee_generate_question'), 10, 4 );

//        $loader->add_filter('FHEE__EE_SPCO_Reg_Step_Attendee_Information___generate_question_input__input_constructor_args',
//            $this, 'bhaa_my_question_input', 11, 5
//        );

        $loader->add_filter('FHEE__EE_Single_Page_Checkout__process_attendee_information__valid_data_line_item',
            $this,'bhaa_filter_request_params',11);

//        add_filter(
//            'FHEE__EE_Single_Page_Checkout__process_attendee_information__valid_data_line_item',
//            array('EED_Add_New_State', 'unset_new_state_request_params'),
//            10,
//            1
//        );

//        $loader->add_action(
//            'AHEE__EE_Single_Page_Checkout__process_attendee_information__end',
//            $this, 'bhaa_process_wpuser_for_attendee', 11, 5
//        );
        //error_log('BHAA\core\eventexpresso');

        //return apply_filters('FHEE__EEM_Answer__get_attendee_question_answer_value__answer_value', $value, $registration, $question_id, $question_system_id);

        $loader->add_action('pre_get_posts',
            $this,'bhaa_ee_add_espresso_events_to_posts', 10 );
        //add_action('AHEE__EED_WP_Users_SPCO__process_wpuser_for_attendee__user_user_created',
        //    $this,'bhaa_ee_user_created'), 10, 4);
        //add_action('AHEE__EED_WP_Users_SPCO__process_wpuser_for_attendee__user_user_updated',
        //    $this,'bhaa_ee_user_updated'), 10, 3);
    }

    function bhaa_filter_request_params($request_params) {
        error_log('--> bhaa_filter_request_params');
        error_log(print_r($request_params,true));

        $primary_reg = $request_params['primary_registrant'];
        error_log($primary_reg);

        $runnerExpresso = new RunnerExpresso();
        $bhaaId = $runnerExpresso->getBhaaIdForRegistration($primary_reg);
        if(!isset($bhaaId)) {
            $bhaaId = get_current_user_id();
            error_log("get bhaa ID from "+get_current_user_id());
        }

        // answers from request params
        $answers = $request_params['personal-information-1519640046'];
        if(isset($answers['11']))
            error_log('DOB   :'.$answers['11']);
        if(isset($answers['12']))
            error_log('Comp  :'.$answers['12']);
        if(isset($answers['13']['0']))
            error_log('Gender:'.$answers['13']['0']);

        // call the runner manager
        if(isset($bhaaId)) {
            $runnerManager = new RunnerManager();
            // use the values from the array and get the BHAA meta-data
            $runnerManager->setCustomBhaaMetaDataAndRenew($bhaaId,$answers['11'],$answers['12'],$answers['13']['0']);
        }
        else {
            error_log("can't determine BHAA ID.");
        }
        error_log('<-- bhaa_filter_request_params');
        return $request_params;
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

    // https://stackoverflow.com/questions/15491367/jquery-datepicker-set-default-date-to-current-month-current-day-current-year
    function bhaa_jf_change_ee_reg_form_datepicker_format() {
        echo "<script>
            jQuery(document).ready(function($) {
                var d = new Date();
                var year18 = d.getFullYear() - 18;
                var year30 = d.getFullYear() - 30;
                d.setFullYear(year30);
                $('.datepicker').datepicker({
                changeYear: true,
                yearRange: '1920:' + year18 + '',
                dateFormat: 'yy-mm-dd',
                defaultDate: d
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
    function bhaa_ee_add_espresso_events_to_posts($WP_Query) {
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

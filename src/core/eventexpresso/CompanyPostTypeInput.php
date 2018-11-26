<?php

namespace BHAA\core\eventexpresso;

use EE_Select_Input;
use WP_Query;

class CompanyPostTypeInput extends EE_Select_Input {
    /**
     * @param array $input_settings
     */
    public function __construct($input_settings = array()) {
        $companyQuery = new WP_Query(
            array(
                'post_type' => 'house',
                'order'		=> 'ASC',
                'post_status' => 'publish',
                'orderby' 	=> 'title',
                'nopaging' => true,
                'tax_query'	=> array(
                    array(
                        'taxonomy'  => 'teamtype',
                        'field'     => 'slug',
                        'terms'     => 'sector', // exclude house posts in the sectorteam custom teamtype taxonomy
                        'operator'  => 'NOT IN')
                ))
        );
        $res = $companyQuery->get_posts();
        $answer_options         = array();
        foreach ($res as $custom_post_type) {
            $answer_options[ $custom_post_type->ID ] = $custom_post_type->post_title;
        }
        parent::__construct($answer_options, $input_settings);
    }
}
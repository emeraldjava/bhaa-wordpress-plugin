<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 21:04
 */

namespace BHAA\core\runner;

use BHAA\core\Connections;
use p2p_get_connections;

class Runner {

    const BHAA_RUNNER_DATEOFBIRTH = 'bhaa_runner_dateofbirth';
    const BHAA_RUNNER_COMPANY = 'bhaa_runner_company';
    const BHAA_RUNNER_MOBILEPHONE = 'bhaa_runner_mobilephone';
    const BHAA_RUNNER_INSERTDATE = 'bhaa_runner_insertdate';
    const BHAA_RUNNER_DATEOFRENEWAL = 'bhaa_runner_dateofrenewal';
    const BHAA_RUNNER_TERMS_AND_CONDITIONS = 'bhaa_runner_terms_and_conditions';

    const BHAA_RUNNER_STATUS = 'bhaa_runner_status';
    const MEMBER = 'M';
    const INACTIVE = 'I';
    const DAY = 'D';

    const BHAA_RUNNER_GENDER = 'bhaa_runner_gender';
    const MAN = 'M';
    const WOMAN = 'W';

    const BHAA_RUNNER_STANDARD = 'bhaa_runner_standard';

    var $user;
    var $user_data;
    var $meta;

    function __construct($user_id) {
        //var_dump('user:'.$user_id);

        //$this->user = get_userdata($user_id);
        $this->user = (array) @get_user_by( 'id', $user_id )->data;
        //var_dump('user:'.print_r($this->user,true));

        //$user_meta = get_user_meta($user_id);//,"",false);
        //$this->meta = get_user_meta($user_id);
        $this->meta = @array_map( function( $a ){ return $a[0]; }, get_user_meta( $user_id ) );
        //var_dump('meta:'.print_r($this->meta,true));

        // @
        $this->user_data = @array_merge($this->user, $this->meta);
        //var_dump($this->user_data);

        // https://github.com/scribu/wp-posts-to-posts/wiki/Checking-specific-connections
        $sectorteam = p2p_get_connections(Connections::SECTORTEAM_TO_RUNNER,array(
            'direction' => 'all',
            'to' => $user_id,
            'fields' => 'p2p_from'
        ));
        //error_log('sector '.print_r($sectorteam,true));
        $this->user_data = @array_merge($this->user_data, array('sectorteam'=>$sectorteam[0]) );

        $company = p2p_get_connections(Connections::HOUSE_TO_RUNNER,array(
            'direction' => 'all',
            'to' => $user_id,
            'fields' => 'p2p_from'
        ));
//        //error_log('company '.print_r($company,true));
        $this->user_data = @array_merge($this->user_data, array('company'=>$company[0]));

        //var_dump('user_data:'.print_r($this->user_data,true));
    }

    function __get($var) {
        if (!@array_key_exists($var, $this->user_data)){
            return null;//$this->default;
        }
        return $this->user_data[$var];
    }

    function getID() {
        return $this->__get('ID');
    }

    function getEmail() {
        return $this->__get('user_email');
    }

    function getFirstName() {
        return $this->first_name;
    }

    function getLastName() {
        return $this->last_name;
    }

    function getFullName() {
        return $this->getFirstName().' '.$this->getLastName();
    }

    function getDateOfBirth() {
        return $this->__get(Runner::BHAA_RUNNER_DATEOFBIRTH);
    }

    function getMobile() {
        return $this->__get(Runner::BHAA_RUNNER_MOBILEPHONE);
    }

    function getStandard() {
        return $this->__get(Runner::BHAA_RUNNER_STANDARD);
    }

    function getGender() {
        return $this->__get(Runner::BHAA_RUNNER_GENDER);
    }

    function getStatus() {
        return $this->__get(Runner::BHAA_RUNNER_STATUS);
    }

    function getDateOfRenewal() {
        return $this->__get(Runner::BHAA_RUNNER_DATEOFRENEWAL);
    }

    function getInsertDate() {
        return $this->__get(Runner::BHAA_RUNNER_INSERTDATE);
    }

    function getCompanyId() {
        return $this->__get('company');
    }

    /**
     * See https://github.com/scribu/wp-posts-to-posts/issues/261
     */
    function getCompany() {
        $args = array(
            'connected_type' => 'house_to_runner',
            'connected_items' => $this->user,
            'suppress_filters' => false,
            'nopaging' => true
        );
        $connected = get_posts( $args );
        if(count($connected))
            return $connected[0];
        else
            return null;
    }

    function getSectorTeamId() {
        return $this->__get('sectorteam');
    }

    function getMetaData() {
        return $this->meta;
    }

    /**
     * Return a url link the runners company.
     * @return string
     */
    function getCompanyName($admin_url) {
        $cid = $this->getCompanyId();
        if(isset($cid)) {
            if($admin_url=="false"){
                return sprintf('<a href="%s">%s</a>',get_permalink($cid),get_the_title($cid));
            } else {
                return sprintf('<a href="%s">Edit %s</a>',get_edit_post_link($cid),get_the_title($cid));
            }
        } else {
            // no company
            return '';
        }
    }

    /**
     * Return a url link to the sector team
     * @param unknown $admin_url
     * @return string
     */
    function getSectorTeam($admin_url) {
        $id = $this->getSectorTeamId();
        if(isset($id)) {
            if($admin_url=="false"){
                return sprintf('<a href="%s">%s</a>',get_permalink($id),get_the_title($id));
            } else {
                return sprintf('<a href="%s">Edit %s</a>',get_edit_post_link($id),get_the_title($id));
            }
        } else {
            // no sector team
            return '';
        }
    }

    function renew() {
        update_user_meta($this->getID(), Runner::BHAA_RUNNER_STATUS, 'M');
        update_user_meta($this->getID(), Runner::BHAA_RUNNER_DATEOFRENEWAL,date('Y-m-d'));
        wp_update_user( array( 'ID' => $this->getID(), 'role' => 'bhaamember' ) );
        error_log('renewed() '.$this->getID().' '.$this->getEmail());
    }
}
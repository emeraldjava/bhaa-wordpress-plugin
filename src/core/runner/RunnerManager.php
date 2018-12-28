<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 22:41
 */

namespace BHAA\core\runner;

use WP_User_Query;

class RunnerManager {

    const BHAA_MEMBERSHIP_ROLE = 'bhaamember2019';

    function runnerExists($runnerId) {
        global $wpdb;
        return $wpdb->get_var($wpdb->prepare('select count(id) as isrunner from wp_users where id=%d',$runnerId));
    }

    function getNextDayRunnerId() {
        global $wpdb;
        return $wpdb->get_var('select users.id + 1 from wp_users as users left outer join wp_users as r on users.id + 1 = r.id 
          where r.id is null and users.id>10001 and users.id<50000 limit 1');
    }

    function getNextBHAARunnerId() {
        global $wpdb;
        return $wpdb->get_var('select users.id + 1 from wp_users as users left outer join wp_users as r on users.id + 1 = r.id
			where r.id is null and users.id>1000 and users.id<9999 limit 1');
    }

    function createNewUser($firstname,$surname,$email,$gender,$dateofbirth,$id,$isNewMember) {
        //require_once( ABSPATH . 'wp-includes/user.php' );

        //$firstname = $this->formatDisplayName($firstname);
        //$surname = $this->formatDisplayName($surname);

        // format the username
        $username = $firstname.'.'.$surname;
        $username = str_replace(' ', '', $username);
        $username = str_replace("'", '', $username);
        $username = strtolower($username);

        // check for a unique username
        if(username_exists($username)) {
            $username = $username.'.'.$id;
        }

        if($email=='')
            $email = 'x'.$username.'@bhaa.ie';

        if($gender!='M')
            $gender='W';

        $password =  wp_hash_password($id);

        // insert the user via SQL
        //if(!$isNewMember) {
            $this->insertUser($id,$username,$password,$email);
        //}
        // update the wp_user
        $res = wp_update_user(array(
            'ID'            => $id,
            'user_login'    => $username,
            'user_email'    => $email,
            'nickname' => $username,
            'display_name'=> $firstname.' '.$surname,
            'first_name' => $firstname,
            'last_name'=> $surname
        ));
        if(is_wp_error($res))
            //error_log('update user error '.$res->get_error_message());

        add_user_meta( $id, Runner::BHAA_RUNNER_GENDER, $gender, true);
        add_user_meta( $id, Runner::BHAA_RUNNER_DATEOFBIRTH, $dateofbirth, true);
        add_user_meta( $id, Runner::BHAA_RUNNER_INSERTDATE, date('Y-m-d'), true);

        if($isNewMember){
            renew($id);
//            add_user_meta( $id,Runner::BHAA_RUNNER_STATUS,'M', true);
//            add_user_meta( $id,Runner::BHAA_RUNNER_DATEOFRENEWAL,date('Y-m-d'), true);
//            wp_update_user( array( 'ID' => $id, 'role' => RunnerManager::BHAA_MEMBERSHIP_ROLE ));
        } else {
            update_user_meta( $id, Runner::BHAA_RUNNER_STATUS,'D');
        }
        return $id;
    }

//    function isBhaaMember() {
//        return in_array(RunnerManager::BHAA_MEMBERSHIP_ROLE,$this->user->role);
//    }

    function renew($id) {
        update_user_meta($id, Runner::BHAA_RUNNER_STATUS, 'M');
        update_user_meta($id, Runner::BHAA_RUNNER_DATEOFRENEWAL,date('Y-m-d'));
        // https://stackoverflow.com/questions/33537603/how-to-assign-multiple-roles-to-a-single-user-in-wordpress
        $wp_user = new \WP_User($id);
        $wp_user->add_role(self::BHAA_MEMBERSHIP_ROLE);
        $wp_user->add_role('subscriber');
        //wp_update_user( array( 'ID' => $id, 'role' => self::BHAA_MEMBERSHIP_ROLE ) );
        //error_log('renewed() '.$this->getID().' '.$this->getEmail());
    }

    // annual membership 2019 = EVT_ID:6876
    function setEventExpressoRunnerAnswers($id,$dob,$gender,$company) {
        error_log(sprintf('%s,%s,%s,%s',$id,$dob,$gender,$company));
        $runner = new Runner($id);
        // date of birth
        if($runner->getDateOfBirth()!=null) {
            update_user_meta($id,Runner::BHAA_RUNNER_DATEOFBIRTH, $dob);
        } else {
            add_user_meta($id,Runner::BHAA_RUNNER_DATEOFBIRTH, $dob,true);
        }
        // gender
        $gender = "M";
        if(!strpos($gender,"M")) {
            $gender="W";
        }
        if($runner->getGender()!=null) {
            update_user_meta($id,Runner::BHAA_RUNNER_GENDER, $gender);
        } else {
            add_user_meta($id,Runner::BHAA_RUNNER_GENDER, $gender,true);
        }
//        global $wpdb;
//        $SQL = $wpdb->prepare('SELECT * FROM wp_esp_registration WHERE REG_url_link="%s"',$primary_reg);
//        error_log($SQL);
//        $vv = $wpdb->get_results($SQL,'ARRAY_A');
//        error_log(print_r($vv));
    }

    private function insertUser($id,$name,$password,$email) {
        global $wpdb;
        $sql = $wpdb->prepare(
            'INSERT INTO wp_users(
                ID,
                user_login,
                user_pass,
                user_nicename,
                user_email,
                user_status,
                display_name,
                user_registered)
                VALUES (%d,%s,%s,%s,%s,%d,%s,NOW())',
            $id,$name,$password,$name,$email,0,$name);
        $wpdb->query($sql);
    }

    /**
     * https://code.tutsplus.com/tutorials/mastering-wp_user_query--cms-23204
     * https://wordpress.stackexchange.com/questions/219686/how-can-i-get-a-list-of-users-by-their-role
     * https://generatewp.com/wp_user_query/
     *
     */
    public function getBHAAMembers($status="M") {
        global $wpdb;
        $SQL = $wpdb->prepare('SELECT wp_users.id AS id,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) AS label,
            TRIM(first_name.meta_value) AS firstname,
            TRIM(last_name.meta_value) AS lastname,
            wp_users.user_email AS email,
            status.meta_value AS status,
            renewaldate.meta_value AS renewaldate,
            gender.meta_value AS gender,
            TRIM(house.post_title) AS companyname,
            r2c.p2p_from AS companyid,
            CASE WHEN r2s.p2p_from IS NOT NULL THEN TRIM(sectorteam.post_title) ELSE TRIM(house.post_title) END AS teamname,
            CASE WHEN r2s.p2p_from IS NOT NULL THEN r2s.p2p_from ELSE r2c.p2p_from END AS teamid,
            IFNULL(standard.meta_value,0) AS standard,
            dob.meta_value AS dob
            FROM wp_users
            JOIN wp_usermeta capabilities on (capabilities.user_id=wp_users.id and capabilities.meta_key="wp_capabilities")
            LEFT JOIN wp_usermeta first_name ON (first_name.user_id=wp_users.id AND first_name.meta_key="first_name")
            LEFT JOIN wp_usermeta last_name ON (last_name.user_id=wp_users.id AND last_name.meta_key="last_name")
            LEFT JOIN wp_usermeta dob ON (dob.user_id=wp_users.id AND dob.meta_key="bhaa_runner_dateofbirth")
            LEFT JOIN wp_usermeta status ON (status.user_id=wp_users.id AND status.meta_key="bhaa_runner_status")
            LEFT JOIN wp_usermeta gender ON (gender.user_id=wp_users.id AND gender.meta_key="bhaa_runner_gender")
            LEFT JOIN wp_usermeta standard ON (standard.user_id=wp_users.id AND standard.meta_key="bhaa_runner_standard")
            LEFT JOIN wp_usermeta renewaldate ON (renewaldate.user_id=wp_users.id AND renewaldate.meta_key="bhaa_runner_dateofrenewal")
            LEFT JOIN wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = "house_to_runner")
            LEFT JOIN wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = "sectorteam_to_runner")
            LEFT JOIN wp_posts house on (house.id=r2c.p2p_from and house.post_type="house")
            LEFT JOIN wp_posts sectorteam ON (sectorteam.id=r2s.p2p_from AND sectorteam.post_type="house")
            WHERE status.meta_value="%s" AND TRIM(IFNULL(wp_users.display_name,"")) <> ""
            ORDER BY lastname,firstname',$status);
        //error_log($SQL);
        return $wpdb->get_results($SQL,ARRAY_A);
    }

    public function getEventOnlineMembers($nextEventId) {
        global $wpdb;
        $SQL = $wpdb->prepare('SELECT wp_users.id as id,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
            TRIM(first_name.meta_value) as firstname,
            TRIM(last_name.meta_value) as lastname,
            wp_users.user_email as email,
            CASE WHEN reg.REG_paid = "10.000" THEN "M" ELSE "D" END as status,
            "2018-03-30" AS renewaldate,
            COALESCE(gender.meta_value,"M") as gender,
            COALESCE(TRIM(house.post_title),"Day Runner") as companyname,
            COALESCE(r2c.p2p_from,1) as companyid,
            CASE WHEN r2s.p2p_from IS NOT NULL THEN TRIM(sectorteam.post_title) ELSE COALESCE(TRIM(house.post_title),"Day Runner") END AS teamname,
            CASE WHEN r2s.p2p_from IS NOT NULL THEN r2s.p2p_from ELSE COALESCE(r2c.p2p_from,1) END AS teamid,
            COALESCE(standard.meta_value,10) as standard,
            COALESCE(dob.meta_value,"1980-01-01") as dob,
            reg.REG_paid as paid
            FROM wp_esp_registration as reg
            JOIN wp_usermeta eeAttendee on (eeAttendee.meta_value=reg.ATT_ID and eeAttendee.meta_key="wp_EE_Attendee_ID")
            JOIN wp_users on (eeAttendee.user_id=wp_users.id)
            left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
            left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
            left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
            left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
            left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
            left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
            LEFT JOIN wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = "house_to_runner")
            LEFT JOIN wp_p2p r2s ON (r2s.p2p_to=wp_users.id AND r2s.p2p_type = "sectorteam_to_runner")
            LEFT JOIN wp_posts house on (house.id=r2c.p2p_from and house.post_type="house")
            LEFT JOIN wp_posts sectorteam ON (sectorteam.id=r2s.p2p_from AND sectorteam.post_type="house")
            WHERE reg.EVT_ID=%d
            AND reg.REG_paid!=0
            ORDER BY lastname ASC, firstname ASC',$nextEventId);
        return $wpdb->get_results($SQL,ARRAY_A);
    }

    public function getNextEventId() {
        global $wpdb;
        return $wpdb->get_col('SELECT EVT_ID as nextEventId FROM wp_esp_datetime d
                WHERE d.DTT_EVT_start >= CURRENT_DATE
                ORDER BY d.DTT_EVT_start ASC
                LIMIT 1');
    }
    
    public function getNewOnlineBHAAMembers() {
        global $wpdb;
        $SQL = 'SELECT wp_users.id as id,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
            TRIM(first_name.meta_value) as firstname,
            TRIM(last_name.meta_value) as lastname,
            wp_users.user_email as email,
            CASE WHEN reg.REG_paid = "15.000" THEN "M" ELSE "D" END as status,
            "2018-03-30" AS renewaldate,
            COALESCE(gender.meta_value,"M") as gender,
            COALESCE(TRIM(house.post_title),"Day Runner") as companyname,
            COALESCE(r2c.p2p_from,1) as companyid,
            COALESCE(TRIM(house.post_title),"Day Runner") as teamname,
            COALESCE(r2c.p2p_from,1) as teamid,
            COALESCE(standard.meta_value,10) as standard,
            COALESCE(dob.meta_value,"1980-01-01") as dob
            FROM wp_esp_registration as reg
            JOIN wp_usermeta eeAttendee on (eeAttendee.meta_value=reg.ATT_ID and eeAttendee.meta_key="wp_EE_Attendee_ID")
            JOIN wp_users on (eeAttendee.user_id=wp_users.id)
            left join wp_usermeta first_name on (first_name.user_id=wp_users.id and first_name.meta_key="first_name")
            left join wp_usermeta last_name on (last_name.user_id=wp_users.id and last_name.meta_key="last_name")
            left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
            left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
            left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
            LEFT JOIN wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = "house_to_runner")
            left join wp_posts house on (house.id=r2c.p2p_from and house.post_type="house")
            left join wp_usermeta standard on (standard.user_id=wp_users.id and standard.meta_key="bhaa_runner_standard")
            WHERE reg.EVT_ID=6907
            AND reg.REG_paid!=0
            ORDER BY lastname ASC, firstname ASC';
        return $wpdb->get_results($SQL,ARRAY_A);
    }
    
    public function listEERegisteredRunners() {
        global $wpdb;
        $SQL = 'SELECT wp_users.id as id,
            reg.EVT_ID,
            TRIM(LOWER(REPLACE(wp_users.display_name," ","."))) as label,
            reg.ATT_ID as ATT_ID,
            reg.REG_ID as REG_ID,
            reg.REG_url_link as REG_URL_LINK,
            reg.TXN_ID as TXN_ID,
            reg.REG_paid as REG_PAID,
            eeAttendee.user_id as EE_BHAA_ID,
            COALESCE(status.meta_value,"x") as m_status,
            capability.meta_value as capability,
            COALESCE(gender.meta_value,"x") as m_gender,
            COALESCE(ee_gender.ANS_value,"x") as ee_gender,
            COALESCE(house.post_title,1) as m_company,
            COALESCE(house.id,1) as m_company_id,
            COALESCE(TRIM(ee_company.ANS_value),"x") as ee_company,
            COALESCE(TRIM(eehouse.ID),0) as ee_company_id,
            COALESCE(dob.meta_value,"x") as m_dob,
            COALESCE(ee_dob.ANS_value,"x") as ee_dob
            FROM wp_esp_registration as reg
            JOIN wp_usermeta eeAttendee on (eeAttendee.meta_value=reg.ATT_ID and eeAttendee.meta_key="wp_EE_Attendee_ID")
            left JOIN wp_users on (eeAttendee.user_id=wp_users.id)
            left join wp_usermeta dob on (dob.user_id=wp_users.id and dob.meta_key="bhaa_runner_dateofbirth")
            left join wp_esp_answer ee_dob on (ee_dob.REG_ID=reg.REG_ID and ee_dob.QST_ID=11)
            left join wp_usermeta status on (status.user_id=wp_users.id and status.meta_key="bhaa_runner_status")
            left join wp_usermeta capability on (capability.user_id=wp_users.id and capability.meta_key="wp_capabilities")
            left join wp_usermeta gender on (gender.user_id=wp_users.id and gender.meta_key="bhaa_runner_gender")
            left join wp_esp_answer ee_gender on (ee_gender.REG_ID=reg.REG_ID and ee_gender.QST_ID=13)
            left join wp_esp_answer ee_company on (ee_company.REG_ID=reg.REG_ID and ee_company.QST_ID=12)
            LEFT JOIN wp_p2p r2c ON (r2c.p2p_to=wp_users.id AND r2c.p2p_type = "house_to_runner")
            left join wp_posts house on (house.id=r2c.p2p_from and house.post_type="house")
            left join wp_posts eehouse on (eehouse.post_title=ee_company.ANS_value and eehouse.post_type="house")
            WHERE reg.EVT_ID IN (6907,6913)
            AND reg.REG_paid!=0
            ORDER BY reg.EVT_ID,wp_users.display_name,reg.EVT_ID';
        return $wpdb->get_results($SQL,OBJECT);// 2018:: 5651,6742
    }

    public function processEventExpressoRunners() {
        error_log('processEventExpressoRunners');
        $registeredRunners = $this->listEERegisteredRunners();
        //global $wpdb;
        foreach($registeredRunners as $runner) {

            // if DOB
            if($runner->m_dob==""){
                update_user_meta($runner->id, Runner::BHAA_RUNNER_DATEOFBIRTH, $runner->ee_dob);
                error_log("fix dob ".$runner->id);
            }

            // if gender
            if($runner->m_gender=="") {
                $gender = "M";
                if( strpos($runner->ee_gender,'F') !== false )
                    $gender = "W";

                update_user_meta($runner->id, Runner::BHAA_RUNNER_GENDER, $gender);
                error_log("fix gender ".$runner->id);
            }

            // if annual membership
            if($runner->EVT_ID == 5651) {

                $runnerObj = new Runner($runner->id);

                if( current_user_can('edit_posts') ) {
                    // true if user can edit posts
                }

                if(strpos($runner->capability,self::BHAA_MEMBERSHIP_ROLE) !== false ) {
                    update_user_meta($runner->id, Runner::BHAA_RUNNER_STATUS, 'M');
                    //update_user_meta($this->getID(), Runner::BHAA_RUNNER_DATEOFRENEWAL,date('Y-m-d'));
                    wp_update_user( array( 'ID' => $runner->id, 'role' => self::BHAA_MEMBERSHIP_ROLE ) );
                    //$runnerObj->renew();
                    error_log("set role and status ".$runner->id);
                }

            } else {
                // set the day membership
                if($runner->m_status=='' && $runner->paid=='15.00') {
                    update_user_meta($runner->id, Runner::BHAA_RUNNER_STATUS, 'D');
                    error_log("set day status ".$runner->id);
                }
            }
        }
    }

    /**
     * https://tommcfarlin.com/wordpress-user-role/
     * @param $user_id
     */
    private function set_user_role( $user_id ) {
        // Define a user role based on its index in the array.
        $roles = array(
            self::BHAA_MEMBERSHIP_ROLE,
            'subscriber'
        );
        $role = $roles[1];
        // Set the user's role (and implicitly remove the previous role).
        $user = new WP_User( $user_id );
        $user->set_role( $role );
    }

    private function getMembersNotInRole() {
        $args = array(
            'number' => 25,
            'fields' => 'all',
            'meta_query' => array(
                array('key' => 'Runner::BHAA_RUNNER_STATUS','compare' => '=', 'value' => 'M')
                )
        );
        //error_log(print_r($args,true));
        // https://stackoverflow.com/questions/24163215/use-wp-user-query
        $user_query = new WP_User_Query( $args );
        $runners = $user_query->get_results();
    }

    /**
     * @param $runner
     */
    function findMatchingRunners($runner) {
        $user_info = get_userdata($runner);
        $bhaa_runner_dateofbirth = get_user_meta($runner,'bhaa_runner_dateofbirth',true);

        $queryMatchAll = new WP_User_Query(
            array(
                'exclude' => array($runner),
                'fields' => 'all_with_meta',
                'meta_query' => array(
                    array(
                        'key' => 'last_name',
                        'value' => $user_info->user_lastname,
                        'compare' => '='),
                    array(
                        'key' => 'first_name',
                        'value' => $user_info->user_firstname,
                        'compare' => '='),
                    array(
                        'key' => 'bhaa_runner_dateofbirth',
                        'value' => $bhaa_runner_dateofbirth,
                        'compare' => '='
                    ))));

        $queryMatchName = new WP_User_Query(
            array(
                'exclude' => array($runner),
                'fields' => 'all_with_meta',
                'meta_query' => array(
                    array(
                        'key' => 'last_name',
                        'value' => $user_info->user_lastname,
                        'compare' => '='),
                    array(
                        'key' => 'first_name',
                        'value' => $user_info->user_firstname,
                        'compare' => '='
                    ))));

        $queryMatchLastDob = new WP_User_Query(
            array(
                'exclude' => array($runner),
                'fields' => 'all_with_meta',
                'meta_query' => array(
                    array(
                        'key' => 'last_name',
                        'value' => $user_info->user_lastname,
                        'compare' => '='),
                    array(
                        'key' => 'bhaa_runner_dateofbirth',
                        'value' => $bhaa_runner_dateofbirth,
                        'compare' => '='
                    ))));
        // merge the three results
        $users = array_merge( $queryMatchAll->get_results(), $queryMatchName->get_results(), $queryMatchLastDob->get_results());
        return $users;
    }

    function mergeRunner($runner,$deleteRunner,$update_wp_users=false) {
        error_log('deleting runner '.$deleteRunner.' and merging to '.$runner);
        global $wpdb;

        // only used when changing a BHAA ID
        if($update_wp_users) {
            $wpdb->update(
                'wp_usermeta',
                array('user_id' => $runner),
                array('user_id' => $deleteRunner)
            );
            $wpdb->update(
                'wp_users',
                array('ID' => $runner),
                array('ID' => $deleteRunner)
            );
            $wpdb->update(
                'wp_p2p',
                array('p2p_to' => $runner),
                array('p2p_to' => $deleteRunner)
            );
            error_log('merging user meta data');
        }

        // update existing race results
        $wpdb->update(
            'wp_bhaa_raceresult',
            array('runner' => $runner),
            array('runner' => $deleteRunner)
        );
        // update team results
        $wpdb->update(
            'wp_bhaa_teamresult',
            array('runner' => $runner),
            array('runner' => $deleteRunner)
        );
        // wp_bhaa_leaguerunnerdata
        $wpdb->update(
            'wp_bhaa_leaguerunnerdata',
            array('runner' => $runner),
            array('runner' => $deleteRunner)
        );
        // wp_bhaa_leaguesummary
        $wpdb->update(
            'wp_bhaa_leaguesummary',
            array('leagueparticipant' => $runner),
            array('leagueparticipant' => $deleteRunner,'leaguetype'=>'I')
        );
        // update any bookings
//        $wpdb->update(
//            'wp_em_bookings',
//            array('person_id' => $runner),
//            array('person_id' => $deleteRunner)
//        );

        // delete the user and metadata
        $wpdb->delete(
            'wp_usermeta',
            array('user_id' => $deleteRunner)
        );
        $wpdb->delete(
            'wp_users',
            array('ID' => $deleteRunner)
        );
        error_log('merged runner '.$deleteRunner.' to '.$runner);
    }
}
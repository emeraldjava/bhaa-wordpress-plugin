
SELECT * FROM `wp_esp_attendee_meta` WHERE `ATT_ID` IN (6927,6928,6929,6930,6931,6932,5938,5966);

SELECT * FROM `wp_esp_attendee_meta` WHERE `ATT_ID` IN (6927,6928,6929,6930,6931,6932,5938,5966);

SELECT * FROM wp_esp_answer WHERE REG_ID=2314;

SELECT * FROM wp_usermeta
WHERE meta_key="wp_EE_Attendee_ID"
AND meta_value IN (6927,6928,6929,6930,6931,6932,5938,5966);

SELECT * FROM wp_esp_registration WHERE EVT_ID=6907;
-- ATT_ID

-- SELECT user_id FROM wp_usermeta WHERE meta_value = ATT_ID AND meta_key = 'wp_EE_Attendee_ID'
SELECT user_id FROM wp_usermeta WHERE meta_value=6927 AND meta_key="wp_EE_Attendee_ID";

-- get BHAA ID and reg details
SELECT bhaa_id.user_id,reg.* FROM wp_esp_registration reg
JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key="wp_EE_Attendee_ID")
WHERE EVT_ID=6907;

SELECT bhaa_id.user_id,reg.* FROM wp_esp_registration reg
JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key="wp_EE_Attendee_ID")
WHERE REG_url_link="1-6d18e121d598122b72011a3af00cc5d0"

SELECT bhaa_id.user_id,
ans_gender.ANS_value as ans_gender,
ans_dob.ANS_value as ans_doc,
ans_company.ANS_value as ans_company,
reg.REG_ID,reg.ATT_ID,reg.REG_url_link
FROM wp_esp_registration reg
LEFT JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key="wp_EE_Attendee_ID")
LEFT JOIN wp_esp_answer ans_gender ON (ans_gender.REG_ID=reg.REG_ID AND ans_gender.QST_ID=13)
LEFT JOIN wp_esp_answer ans_dob ON (ans_dob.REG_ID=reg.REG_ID AND ans_dob.QST_ID=11)
LEFT JOIN wp_esp_answer ans_company ON (ans_company.REG_ID=reg.REG_ID AND ans_company.QST_ID=12)
WHERE EVT_ID=6907 AND STS_ID="RAP";

-- REG_ID
SELECT * FROM wp_esp_answer
WHERE REG_ID=2000

20119	wp_EE_Attendee_ID	6927
20117	wp_EE_Attendee_ID	6931
8594	wp_EE_Attendee_ID	6932
4643	wp_EE_Attendee_ID	5938
2793	wp_EE_Attendee_ID	5966
18157	wp_EE_Attendee_ID	6928
2738	wp_EE_Attendee_ID	6929
4771	wp_EE_Attendee_ID	6930


Transaction ID	Attendee ID	Registration ID
2424	6927	2343
2426	6928	2345
2429	6929	2348
2432	6930	2351
2434	6931	2353
2435	6932	2354
2437	5938	2356
2439	5966	2358


20119	nmorrise			niamhmacnamara2012@gmail.com	M	2018-03-30	M	Day Runner	1	Day Runner	1	10	1980-01-01
20117	williamkavanagh@gmail.com			williamkavanagh@gmail.com	M	2018-03-30	M	Day Runner	1	Day Runner	1	10	1980-01-01
8594	michael.carolan			michaeljcarolan@hotmail.com	M	2018-03-30	M	Teacher	72	Teacher	72	13	1954-11-16
18157	danwallace05			danwallace05@gmail.com	M	2018-03-30	M	Day Runner	1	Day Runner	1	10	1977-04-12
2738	dok951			dok951@gmail.com	M	2018-03-30	M	EMO Oil	655	EMO Oil	655	29	1952-04-13
4771	patrickj.otoole			patrickotoole1@gmail.com	M	2018-03-30	M	Day Runner	1	Day Runner	1	10	1967-07-14
2793	brendan.glynn	Brendan	Glynn	brendan.glynn@hotmail.com	M	2018-03-30	M	Day Runner	1	Day Runner	1	12	1985-05-24
4643	hugh.reddy	Hugh	Reddy	hughreddy@icloud.com	M	2018-03-30	M	Gardai	94	Gardai	94	26	1957-09-13

-- localhost

-- use BHAA\core\runner\RunnerExpresso;

    [personal-information-1519640046] => Array
        (
            [fname] => Web
            [lname] => Master
            [email] => webmaster@bhaa.ie
            [phone] => 12343
            [13] => Array
                (
                    [0] => F
                )

            [11] => 1988-12-01
            [12] => ABC
        )

    [additional_attendee_reg_info] => 1
    [primary_registrant] =>

SELECT reg.* FROM wp_esp_registration reg
WHERE REG_url_link="1-5f2f55632407b9224e8bbad21095e199"
-- ATT_ID=0 !

SELECT * FROM wp_esp_answer WHERE REG_ID=2358;

SELECT bhaa_id.user_id,reg.* FROM wp_esp_registration reg
JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key="wp_EE_Attendee_ID")
WHERE REG_url_link="1-5f2f55632407b9224e8bbad21095e199"

SELECT bhaa_id.user_id FROM wp_esp_registration reg
JOIN wp_usermeta bhaa_id ON (bhaa_id.meta_value=reg.ATT_ID AND bhaa_id.meta_key="wp_EE_Attendee_ID")
WHERE REG_url_link='1-6f4247ddcfd03e823fdc94223854ecd6'
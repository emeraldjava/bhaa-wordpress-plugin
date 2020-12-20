update wp_options set option_value="http://localhost" where option_name="siteurl";
update wp_options set option_value="http://localhost" where option_name="home";

OPTIMIZE TABLE wp_bhaa_raceresult;
ANALYZE TABLE wp_bhaa_raceresult;

OPTIMIZE TABLE wp_users;
ANALYZE TABLE wp_users;

OPTIMIZE TABLE wp_usermeta;
ANALYZE TABLE wp_usermeta;

OPTIMIZE TABLE wp_p2p;
ANALYZE TABLE wp_p2p;

OPTIMIZE TABLE wp_posts;
ANALYZE TABLE wp_posts;

OPTIMIZE TABLE wp_postmeta;
ANALYZE TABLE wp_postmeta;

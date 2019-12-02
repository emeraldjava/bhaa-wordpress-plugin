<?php
$root_dir = dirname( dirname( __FILE__ ) );
// Composer autoloader
require_once $root_dir . '/vendor/autoload.php';
// Add mock method

// Now call the bootstrap method of WP Mock
//WP_Mock::setUsePatchwork( true );
WP_Mock::bootstrap();

//function add_shortcode(){}

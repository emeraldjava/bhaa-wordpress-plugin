<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 25/12/18
 * Time: 06:26
 */

namespace BHAA\core\runner;


class RunnerTest extends \WP_Mock\Tools\TestCase {

    public function setUp() : void {
        \WP_Mock::setUp();
    }

    public function tearDown() : void {
        \WP_Mock::tearDown();
    }

    public function test_my_permalink_function() {
//        \WP_Mock::userFunction( 'get_permalink', array(
//            'args' => 42,
//            'times' => 1,
//            'return' => 'http://example.com/foo'
//        ) );
//
//        \WP_Mock::passthruFunction( 'absint', array( 'times' => 1 ) );
//
//        \WP_Mock::onFilter( 'special_filter' )
//            ->with( 'http://example.com/foo' )
//            ->reply( 'https://example.com/bar' );
//
//        \WP_Mock::expectAction( 'special_action', 'https://example.com/bar' );

        //$result = my_permalink_function( 42 );

        //$this->assertEquals( 'https://example.com/bar', $result );
    }
}
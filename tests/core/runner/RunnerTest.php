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
}
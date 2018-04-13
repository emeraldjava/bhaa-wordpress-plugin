<?php

use PHPUnit\Framework\TestCase;
use Brain\Monkey;

final class MainTest extends TestCase {

    protected $obj = NULL;

    protected function setUp() {
        parent::setUp();
        Monkey\setUp();
        $this->obj = new BHAA\Main;
    }

    protected function tearDown() {
        Monkey\tearDown();
        parent::tearDown();
    }

    public function testVerifyPluginName() {
        $this->assertEquals($this->obj->get_plugin_name(),'bhaa_wordpress_plugin');
    }
}
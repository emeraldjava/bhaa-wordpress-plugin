<?php

use PHPUnit\Framework\TestCase;

final class MainTest extends TestCase {

    protected $obj = NULL;

    protected function setUp() {
        parent::setUp();
        $this->obj = new BHAA\Main("phpunit-version");
    }

    protected function tearDown() {
        parent::tearDown();
    }

    public function testVerifyPluginName() {
        $this->assertEquals($this->obj->get_plugin_name(),'bhaa_wordpress_plugin');
    }

    public function testVerifyVersion() {
        $this->assertEquals($this->obj->get_version(),'phpunit-version');
    }
}

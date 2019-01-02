<?php
/**
 * Created by IntelliJ IDEA.
 * User: bhaa
 * Date: 25/12/18
 * Time: 06:26
 */

namespace BHAA\core\runner;

use PHPUnit\Framework\TestCase;

class RunnerManagerTest extends TestCase {

    protected $obj = NULL;

    protected function setUp() {
        parent::setUp();
        $this->obj = new RunnerManager();
    }

    protected function tearDown() {
        parent::tearDown();
    }

    public function testVerifyRunnerManager() {
        $this->assertNotNull($this->obj);
    }

    public function testGender_stringF_expectW() {
        $this->assertEquals("W",$this->obj->getGender("F"));
    }

    public function testGender_stringW_expectW() {
        $this->assertEquals("W",$this->obj->getGender("W"));
    }

    public function testGender_stringM_expectM() {
        $this->assertEquals("M",$this->obj->getGender("M"));
    }

    public function testGender_answerF_expectW() {
        $this->assertEquals("W",$this->obj->getGender("a:1:{i:0;s:1:\"F\";}"));
    }

    public function testGender_answerM_expectW() {
        $this->assertEquals("M",$this->obj->getGender("a:1:{i:0;s:1:\"M\";}"));
    }
}
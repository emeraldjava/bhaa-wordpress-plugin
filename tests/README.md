# Tests

## WP Mock

- https://github.com/10up/wp_mock
- https://www.php-developer.org/wp_mock-phpunit-testing-framework-wordpress-plugin-complete-guide/
- https://sea-region.github.com/10up/wp_mock/issues/117

## Brain Moneky

- https://brain-wp.github.io/BrainMonkey/docs/wordpress-tools.html
- https://swas.io/blog/wordpress-plugin-unit-test-with-brainmonkey/

Testing started at 14:44 ...
/usr/bin/php /home/bhaa/projects/bhaa_wordpress_plugin/vendor/phpunit/phpunit/phpunit --no-configuration /home/bhaa/projects/bhaa_wordpress_plugin/tests --teamcity
PHP Fatal error:  Declaration of WP_Mock\Tools\TestCase::expectOutputString($expectedString) must be compatible with PHPUnit\Framework\TestCase::expectOutputString(string $expectedString): void in /home/bhaa/projects/bhaa_wordpress_plugin/vendor/10up/wp_mock/php/WP_Mock/Tools/TestCase.php on line 318

Process finished with exit code 255

## Codecept

    https://codeception.com/quickstart
    
    https://codeception.com/docs/05-UnitTestsrm -r
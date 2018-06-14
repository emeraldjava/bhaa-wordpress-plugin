<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 23/03/2018
 * Time: 12:48
 */

namespace BHAA\core;

use Mustache_Engine;
use Mustache_Loader_CascadingLoader;
use Mustache_Loader_FilesystemLoader;

class Mustache {

    private $mustache = null;

    /**
     * See the Cascading loader : https://stackoverflow.com/questions/20499019/how-to-override-partials-with-mustache?rq=1
     * https://stackoverflow.com/questions/31093118/trying-to-call-partials-in-mustache-php
     */
    public function __construct() {
        $options =  array('extension' => '.tpl');

        // Cascading template loader
        $mustache_loader = new Mustache_Loader_CascadingLoader(array(
            new Mustache_Loader_FilesystemLoader(dirname(__FILE__) . '/race/mustache', $options),
            new Mustache_Loader_FilesystemLoader(dirname(__FILE__) . '/league/mustache', $options),
            new Mustache_Loader_FilesystemLoader(dirname(__FILE__) . '/runner/mustache', $options),
        ));

        $mustache_partial_loader = new Mustache_Loader_CascadingLoader(array(
            new Mustache_Loader_FilesystemLoader(dirname(__FILE__) . '/league/mustache/partials', $options)
        ));

        $this->mustache = new Mustache_Engine(
            array(
                'loader' => $mustache_loader,
                'partials_loader' => $mustache_partial_loader
            )
        );
    }

    public function renderTemplate(string $template,array $parameters) {
        //error_log('renderTemplate '.$template);
        return $this->mustache->loadTemplate($template)->render($parameters);
    }
}
<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 12/04/2018
 * Time: 13:35
 */

namespace BHAA\utils;

interface Loadable {

    public function registerHooks(Loader $loader);
}
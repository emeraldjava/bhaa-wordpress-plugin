<?php
namespace BHAA\utils;
/**
 * Register all actions and filters for the plugin.
 *
 * Maintain a list of all hooks that are registered throughout
 * the plugin, and register them with the WordPress API. Call the
 * run function to execute the list of actions and filters.
 *
 * @see https://carlalexander.ca/polymorphism-wordpress-interfaces/
 */
class Loader {
    /**
     * The array of actions registered with WordPress.
     *
     * @since    1.0.0
     * @access   protected
     * @var      array    $actions    The actions registered with WordPress to fire when the plugin loads.
     */
    protected $actions;
    /**
     * The array of filters registered with WordPress.
     *
     * @since    1.0.0
     * @access   protected
     * @var      array    $filters    The filters registered with WordPress to fire when the plugin loads.
     */
    protected $filters;
    /**
     * Initialize the collections used to maintain the actions and filters.
     *
     * @since    1.0.0
     */
    public function __construct() {
        $this->actions = array();
        $this->filters = array();
    }

    public function register($object) {
        if ($object instanceof Actionable) {
            array_push($this->actions, $object);
        }
        if ($object instanceof Filterable) {
            array_push($this->filters, $object);
        }
    }

    /**
     * Register the filters and actions with WordPress.
     *
     * @since    1.0.0
     */
    public function loadActionsAndFilters() {
        foreach ( $this->filters as $filter ) {
            $this->register_filters($filter);
        }
        foreach ( $this->actions as $action ) {
            $this->register_actions($action);
        }
    }

    /**
     * Register an object with a specific action hook.
     *
     * @param Actionable $object
     * @param string $name
     * @param mixed $parameters
     */
    private function register_action(Actionable $object, $name, $parameters) {
        if (is_string($parameters)) {
            add_action($name, array($object, $parameters));
        } elseif (is_array($parameters) && isset($parameters[0])) {
            add_action($name, array($object, $parameters[0]), isset($parameters[1]) ? $parameters[1] : 10, isset($parameters[2]) ? $parameters[2] : 1);
        }
    }

    /**
     * Regiters an object with all its action hooks.
     *
     * @param Actionable $object
     */
    private function register_actions(Actionable $object) {
        foreach ($object->get_actions() as $name => $parameters) {
            $this->register_action($object, $name, $parameters);
        }
    }

    /**
     * Register an object with a specific filter hook.
     *
     * @param Filerable $object
     * @param string $name
     * @param mixed $parameters
     */
    private function register_filter(Filterable $object, $name, $parameters) {
        if (is_string($parameters)) {
            add_filter($name, array($object, $parameters));
        } elseif (is_array($parameters) && isset($parameters[0])) {
            add_filter($name, array($object, $parameters[0]), isset($parameters[1]) ? $parameters[1] : 10, isset($parameters[2]) ? $parameters[2] : 1);
        }
    }

    /**
     * Regiters an object with all its filter hooks.
     *
     * @param Filerable $object
     */
    private function register_filters(Filterable $object) {
        foreach ($object->get_filters() as $name => $parameters) {
            $this->register_filter($object, $name, $parameters);
        }
    }
}
?>
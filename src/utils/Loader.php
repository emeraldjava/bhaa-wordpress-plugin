<?php
namespace BHAA\utils;
/**
 * Register all actions and filters for the plugin.
 *
 * Maintain a list of all hooks that are registered throughout
 * the plugin, and register them with the WordPress API. Call the
 * run function to execute the list of actions and filters.
 * https://github.com/DevinVinson/dadmin/blob/master/includes/class-dadmin-loader.php
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

    /**
     * Add a new action to the collection to be registered with WordPress.
     */
    public function add_action( $hook, $component, $callback, $priority = 10, $accepted_args = 1 ) {
        $this->actions = $this->add( $this->actions, $hook, $component, $callback, $priority, $accepted_args );
    }

    /**
     * Add a new filter to the collection to be registered with WordPress.
     */
    public function add_filter( $hook, $component, $callback, $priority = 10, $accepted_args = 1 ) {
        $this->filters = $this->add( $this->filters, $hook, $component, $callback, $priority, $accepted_args );
    }

//    public function register($object) {
//        if ($object instanceof Actionable) {
//            array_push($this->actions, $object);
//        }
//        if ($object instanceof Filterable) {
//            array_push($this->filters, $object);
//        }
//    }

    /**
     * Register the filters and actions with WordPress.
     *
     * @since    1.0.0
     */
//    public function loadActionsAndFilters() {
//        foreach ( $this->filters as $filter ) {
//            $this->register_filters($filter);
//        }
//        foreach ( $this->actions as $action ) {
//            $this->register_actions($action);
//        }
//    }

    /**
     * Register an object with a specific action hook.
     *
     * @param Actionable $object
     * @param string $name
     * @param mixed $parameters
     */
//    private function register_action(Actionable $object, $name, $parameters) {
//        if (is_string($parameters)) {
//            //error_log('action1: '.get_class($object).'.'.$name.' -> '.$parameters);
//            add_action($name, array($object, $parameters));
//        } elseif (is_array($parameters) && isset($parameters[0])) {
//            //error_log('action2: '.get_class($object).'.'.$name.' -> '.implode(",", $parameters[0]));
//            add_action($name, array($object, $parameters[0]), isset($parameters[1]) ? $parameters[1] : 10, isset($parameters[2]) ? $parameters[2] : 1);
//        }
//    }

    /**
     * Regiters an object with all its action hooks.
     *
     * @param Actionable $object
     */
//    private function register_actions(Actionable $object) {
//        foreach ($object->get_actions() as $name => $parameters) {
//            $this->register_action($object, $name, $parameters);
//        }
//    }

    /**
     * Register an object with a specific filter hook.
     *
     * @param Filerable $object
     * @param string $name
     * @param mixed $parameters
     */
//    private function register_filter(Filterable $object, $name, $parameters) {
//        if (is_string($parameters)) {
//            //error_log('filter1 '.$name.' -> '.get_class($object).'.'.$parameters);
//            add_filter($name, array($object, $parameters),10,1);
//        } elseif (is_array($parameters) && isset($parameters[0])) {
//            //error_log('filter2 '.$name.' -> '.get_class($object).'.'.implode(",", $parameters));
//            add_filter($name, array($object, $parameters[0]), isset($parameters[1]) ? $parameters[1] : 10, isset($parameters[2]) ? $parameters[2] : 1);
//        }
//    }

    /**
     * Regiters an object with all its filter hooks.
     *
     * @param Filerable $object
     */
//    private function register_filters(Filterable $object) {
//        foreach ($object->get_filters() as $name => $parameters) {
//            $this->register_filter($object, $name, $parameters);
//        }
//    }

    /**
     * A utility function that is used to register the actions and hooks into a single
     * collection.
     *
     * @since    1.0.0
     * @access   private
     * @param      array                $hooks            The collection of hooks that is being registered (that is, actions or filters).
     * @param      string               $hook             The name of the WordPress filter that is being registered.
     * @param      object               $component        A reference to the instance of the object on which the filter is defined.
     * @param      string               $callback         The name of the function definition on the $component.
     * @param      int      Optional    $priority         The priority at which the function should be fired.
     * @param      int      Optional    $accepted_args    The number of arguments that should be passed to the $callback.
     * @return   type                                   The collection of actions and filters registered with WordPress.
     */
    private function add( $hooks, $hook, $component, $callback, $priority, $accepted_args ) {
        $hooks[] = array(
            'hook'          => $hook,
            'component'     => $component,
            'callback'      => $callback,
            'priority'      => $priority,
            'accepted_args' => $accepted_args
        );
        return $hooks;
    }


    /**
     * Register the filters and actions with WordPress.
     */
    public function run() {
        foreach ( $this->filters as $hook ) {
            error_log('filter: '.$hook['hook'].':'.get_class($hook['component']).'.'.$hook['callback'].'-'.$hook['priority'].'-'.$hook['accepted_args']);
            add_filter( $hook['hook'], array( $hook['component'], $hook['callback'] ), $hook['priority'], $hook['accepted_args'] );
        }
        foreach ( $this->actions as $hook ) {
            error_log('action: '.$hook['hook'].':'.get_class($hook['component']).'.'.$hook['callback'].'-'.$hook['priority'].'-'.$hook['accepted_args']);
            add_action( $hook['hook'], array( $hook['component'], $hook['callback'] ), $hook['priority'], $hook['accepted_args'] );
        }
    }

}
?>
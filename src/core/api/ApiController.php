<?php
namespace BHAA\core\api;

use BHAA\utils\Loadable;
use BHAA\utils\Loader;
use BHAA\core\race\Race;
use BHAA\core\race\RaceResult;

use \WP_Query;
use \WP_REST_Server;
use \WP_REST_Controller;

/**
 * ApiController to support the results.bhaa.ie UI app.
 * - race (by year)
 * - raceresult
 * - runnerresult
 * 
 * - https://developer.wordpress.org/rest-api/extending-the-rest-api/schema/
 * - https://make.wordpress.org/core/2020/07/16/rest-api-parameter-json-schema-changes-in-wordpress-5-5/
 * - https://www.wpeka.com/make-custom-endpoints-wordpress-rest-api.html
 * - https://stackoverflow.com/questions/53126137/wordpress-rest-api-custom-endpoint-with-url-parameter
 * - https://stackoverflow.com/questions/55653664/how-to-filter-custom-fields-for-custom-post-type-in-wordpress-rest-api/55673234#55673234
 */
class ApiController extends WP_REST_Controller implements Loadable {
 
    //The namespace and version for the REST SERVER
    var $my_namespace = 'bhaa/v';
    var $my_version   = '2';

    public function registerHooks(Loader $loader) {
        $loader->add_action('rest_api_init',$this,'bhaa_rest_api_init');
    }

    public function bhaa_rest_api_init() {
        $namespace = $this->my_namespace . $this->my_version;
        // return a list of races (by year)
        register_rest_route( $namespace, '/race', array(
            array(
                'methods'         => WP_REST_Server::READABLE,
                'callback'        => array( $this, 'bhaa_api_races' ),
                'permission_callback'   => array( $this, 'bhaa_api_perm_true' )
            )
        ));
        // race result (by raceId )
        register_rest_route( $namespace, '/raceresult/(?P<id>\d+)', array(
            array(
                'methods'         => WP_REST_Server::READABLE,
                'callback'        => array( $this, 'bhaa_api_raceresults' ),
                'permission_callback'   => array( $this, 'bhaa_api_perm_true' )
            )
        ));
        // runner result (by runner )
    }  

    /**
     * 
     * https://fancysquares.blog/add-a-custom-endpoint-to-wordpress-rest-api
     * https://wordpress.stackexchange.com/questions/271877/how-to-do-a-meta-query-using-rest-api-in-wordpress-4-7
     *
     * @param \WP_REST_Request $request
     * @return void
     */
    function bhaa_api_races( \WP_REST_Request $request ) {   
        //var_dump($request);
        $year = 2019;
        $racesByYearQuery = new WP_Query(
            array(
                'post_type' => 'race',
                'order'		=> 'DESC',
                'post_status' => 'publish',
                'orderby' 	=> 'date',
                'date_query' => array(
                        array('year'=>$year)
                    ),
                'nopaging' => true
            )
        );

        // if no posts found return 
        if( empty($racesByYearQuery->posts) ){
            return new WP_Error( 'no_posts', __('No post found'), array( 'status' => 404 ) );
        }

        foreach ( $racesByYearQuery->posts as $post ) {
            $response = $this->prepare_race_for_response( $post, $request );
            $data[] = $this->prepare_response_for_collection( $response );  
        }
        return new \WP_REST_Response($data,200);
    }

    private function prepare_race_for_response( $post, $request ) {
        $data = array(
            'name'    => $post->post_title,
            'race'    => $post->ID,
            'distance' => get_metadata('post',$post->ID,'bhaa_race_distance',true),
            'unit' => get_metadata('post',$post->ID,'bhaa_race_unit',true),
            'type' => get_metadata('post',$post->ID,'bhaa_race_type',true),    
            'date' => $post->post_date //date( "F j, Y", strtotime($post->post_date)),
        );
        return $data;
    }

    /**
     * https://developer.wordpress.org/rest-api/extending-the-rest-api/adding-custom-endpoints/
     *
     * @param WP_REST_Request $request
     * @return void
     */
    function bhaa_api_raceresults( \WP_REST_Request $request ) {   
        //$race = new Race($request['id']);
        //error_log($request['id']);
        $raceResult = new RaceResult();
        $res = $raceResult->getRaceResults($request['id']);
        return $res;    
    }

    function bhaa_api_perm_true() {
        return true;
    }

    /**
     * https://developer.wordpress.org/reference/classes/wp_rest_controller/get_public_item_schema/
     * @return void
     */
    public function bhaa_get_public_item_schema() {

        if ( $this->schema ) {
            // Since WordPress 5.3, the schema can be cached in the $schema property.
            return $this->schema;
        }
 
        $this->schema = array(
            // This tells the spec of JSON Schema we are using which is draft 4.
            '$schema'              => 'http://json-schema.org/draft-04/schema#',
            // The title property marks the identity of the resource.
            'title'                => 'results',
            'type'                 => 'object',
            // In JSON Schema you can specify object properties in the properties attribute.
            'properties'           => array(
                'id' => array(
                    'description'  => esc_html__( 'Unique identifier for the object.', 'my-textdomain' ),
                    'type'         => 'integer',
                    'context'      => array( 'view', 'edit', 'embed' ),
                    'readonly'     => true,
                ),
                'content' => array(
                    'description'  => esc_html__( 'The content for the object.', 'my-textdomain' ),
                    'type'         => 'string',
                ),
            ),
        );
 
        return $this->schema;
    }
}
?>
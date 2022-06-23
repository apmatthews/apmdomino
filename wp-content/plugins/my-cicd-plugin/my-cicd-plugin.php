<?php
/**
 * Plugin Name: My CI/CD Plugin
 * Plugin URI: https://wpengine.com/
 * Description: Test plugin for CI/CD things.
 * Author: Andrew Matthews
 * Author URI: https://github.com/apmatthews
 * Text Domain: my-cicd-plugin
 * Domain Path: /languages
 * Version: 0.0.21
 *
 * @package My_CICD_Plugin
 */
 
 add_action('init', 'register_my_cpt');

 function register_my_cpt() {
    register_post_type('cicd', array(
        'public' => true
    ));
 }
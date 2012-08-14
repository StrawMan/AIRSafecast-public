<?php

////////////////////////////
//Header/content. JSON data.
////////////////////////////
header ('Content-type:application/json');
////////////////////////////
//Output/internal encoding.
////////////////////////////
mb_internal_encoding ('utf-8');
mb_http_output ('utf-8');
mb_http_input ('utf-8');
////////////////////////////
//Custom Classes/Functions.
////////////////////////////
require_once('class/initdb.class.php');
require_once('class/dbconnect.class.php');
require_once('class/jsonhandler.class.php');
////////////////////////////
//Error Reporting/handling.
////////////////////////////
//Custom error handling class.
require_once('class/utility.class.php');
require_once('class/errors.class.php');
//Reporting.
error_reporting (E_ALL ^ E_NOTICE);
ini_set ('display_errors', 0);
//Custom fatal error handler.
register_shutdown_function ('errors::func_shutdown');
////////////////////////////
//Variables.
////////////////////////////
$reading_id;
$reading_date;
$unit_id;
$alt_reading_value;
$alt_unit_id;
$rolling_count;
$total_count;
$latitude;
$longitude;
$gps_quality_indicator;
$satellite_num;
$gps_precision;
$gps_altitude;
$gps_device_name;
$measurement_type;
$zoom_7_grid;

$drive_id = (isset ($_REQUEST['driveid'])) ? $_REQUEST['driveid'] : null;
//////////////////////////////
//Connection data.
//Host, user, password and database. 
//Set in initdb.class.php.
//////////////////////////////
$connection = array ('host' => DB_HOST, 'user' => DB_USER, 'password' => DB_PASS, 'database' => DB_DB);
////////////////////////////
//Build queries.
////////////////////////////
//Safecast drive ID data only on initial load.
$query_driveid_data = array (0);
$query_driveid = "SELECT DISTINCT drive_id, latitude, longitude, LEFT(reading_date, 10) AS r_date 
    FROM scdata 
    WHERE drive_id > ? 
    GROUP BY drive_id
    ORDER BY drive_id";
//Safecast data on demand.
$query_data = array ($drive_id, 0.02);
$query = "SELECT latitude, longitude, reading_value, alt_reading_value, reading_date, drive_id 
    FROM scdata 
    WHERE drive_id = ? 
    AND reading_value > ? LIMIT 0, 20";
////////////////////////////
//Login & return JSON data.
////////////////////////////
//Safecast data on demand.
if ($drive_id != null) {
    $jsondat = new jsonhandler ($connection['host'], $connection['user'], $connection['password'], $connection['database'], $query_data, $query);
    $json = $jsondat -> func_json_builder ();
    echo $json;
} else {
    //Safecast drive ID data only on initial load.
    $jsondat_drive = new jsonhandler ($connection['host'], $connection['user'], $connection['password'], $connection['database'], $query_driveid_data, $query_driveid);
    $json_drive_id = $jsondat_drive -> func_json_builder ();
    echo $json_drive_id;
}
?>
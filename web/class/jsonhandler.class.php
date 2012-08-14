<?php

////////////////////////////
//Output/internal encoding.
////////////////////////////
mb_internal_encoding ('UTF-8');
mb_http_output ('UTF-8');

////////////////////////////
////////////////////////////
//JSON data handler.
////////////////////////////
//Class name.
class jsonhandler extends dbconnect {

    //Variables.
    private $query_data;
    private $connection;
    private $db_host;
    private $db_user;
    private $db_password;
    private $db_database;
    private $query;
    private $raw_data;

    ////////////////////////////
    //Constructor.
    ////////////////////////////
    public function __construct ($db_host, $db_user, $db_password, $db_database, $query_data, $query) {
        //Create DB connection.
        parent::__construct ($db_host, $db_user, $db_password, $db_database);
        //Initialize variables.
        $this -> query_data = $query_data;
        $this -> query = $query;
        $this -> db_host = $db_host;
        $this -> db_user = $db_user;
        $this -> db_password = $db_password;
        $this -> db_database = $db_database;
        //Execute query.
        $this -> func_execute ();
        //Fetch.
        $this -> func_fetch_results ();
    }

    ////////////////////////////
    //Public class methods.
    ////////////////////////////
    //JSON builder.
    public function func_json_builder () {
        return json_encode ($this -> raw_data);
    }

    ////////////////////////////
    //Private class methods.
    ////////////////////////////
    //Execute query.
    private function func_execute () {
        $this -> connection = parent::func_query ($this -> query, $this -> query_data);
    }

    //Fetch raw results.
    private function func_fetch_results () {
        foreach ($this -> connection -> fetchAll (PDO::FETCH_ASSOC) as $row) {
            $this -> raw_data[] = $row;
        }
    }

    ////////////////////////////
    //Protected class methods.
    ////////////////////////////
    ////////////////////////////
    //Destructor.
    ////////////////////////////
    public function __destruct () {
        
    }

}

////////////////////////////////////
?>
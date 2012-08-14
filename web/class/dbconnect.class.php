<?php

////////////////////////////
//Output/internal encoding.
////////////////////////////
mb_internal_encoding ('UTF-8');
mb_http_output ('UTF-8');

////////////////////////////
////////////////////////////////////
//Simple DB Connection class.
////////////////////////////////////
//DB Connection class.
class dbconnect extends initdb {

    //Variables.
    protected $host;
    protected $user;
    protected $password;
    protected $database;
    protected $link;
    public $result;

    ////////////////////////////
    //Constructor.
    ////////////////////////////
    public function __construct ($host, $user, $password, $database) {
        $this -> host = $host;
        $this -> user = $user;
        $this -> password = $password;
        $this -> database = $database;
    }

    ////////////////////////////
    //Public class methods.
    ////////////////////////////
    //Query
    protected function func_query ($qstring, $querydata) {
        $this -> func_connect ();
        $this -> result = $this -> link -> prepare ($qstring);
        $this -> result -> execute (array_values($querydata));
        return $this -> result;
        unset ($this -> link);
    }

    ////////////////////////////
    //Private class methods.
    ////////////////////////////
    //Connect.
    private function func_connect () {
        try {
            $dsn = 'mysql:host=' . $this -> host . ';dbname=' . $this -> database . '';
            $options = array (
                PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8',
                PDO::ATTR_ERRMODE,
                PDO::ERRMODE_EXCEPTION
            );
            $this -> link = new PDO ($dsn, $this -> user, $this -> password, $options);
        } catch (PDOException $e) {
            echo 'PDOError: Message -> ' . $e -> getMessage () . ' Code -> ' . (int) $e -> getCode ();
        }
    }

    ////////////////////////////
    //Protected class methods.
    ////////////////////////////
    ////////////////////////////
    //Destructor.
    ////////////////////////////
    public function __destruct () {
        unset ($this -> user, $this -> password);
    }

}

////////////////////////////////////	
?>
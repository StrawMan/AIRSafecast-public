<?php

////////////////////////////////////
//Output/internal encoding.
////////////////////////////////////
mb_internal_encoding ('UTF-8');
mb_http_output ('UTF-8');

////////////////////////////////////
////////////////////////////////////
//Miscellaneous utility functions.
////////////////////////////////////
class utility {

    //Variables.
    ////////////////////////////
    //Constructor.
    ////////////////////////////
    public function __construct () {
        
    }

    ////////////////////////////
    //Public class methods.
    ////////////////////////////
    ///////////////////////////
    //Private class methods.
    ////////////////////////////
    ////////////////////////////
    //Protected class methods.
    ////////////////////////////
    //Simple notification, by mail.
    protected function func_CCme ($recpt, $sub, $msg, $from) {
        $to = $recpt;
        $subject = $sub;
        $message = $msg;
        $headers = 'From: ' . $from . '' . "\r\n" . 'X-Mailer: PHP/' . phpversion ();
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-type: text/plain; charset=utf-8\r\n";
        $headers .= "Content-Transfer-Encoding: quoted-printable\r\n";
        mail ($to, $subject, $message, $headers);
    }

    ////////////////////////////
    //Destructor.
    ////////////////////////////
    public function __destruct () {
        
    }

}

////////////////////////////////////
?>
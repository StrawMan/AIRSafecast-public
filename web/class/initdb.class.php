<?php

////////////////////////////////////
//Output/internal encoding.
////////////////////////////////////
mb_internal_encoding ('UTF-8');
mb_http_output ('UTF-8');
////////////////////////////////////
////////////////////////////////////
//Database related constants.
////////////////////////////////////
//Password salt.
define ('SALT_LENGTH', 9);
//DB connection information.
define ('DB_HOST', 'localhost');
define ('DB_USER', 'user');
define ('DB_PASS', 'user_pass');
define ('DB_DB', 'db');
////////////////////////////////////
////////////////////////////////////
//Database parent class.
////////////////////////////////////
//Class name.
class initdb {

    ////////////////////////////////////
    //Common, public/protected methods.
    ////////////////////////////////////
    //Salt passwords.
    public function func_salt ($plainText, $salt = null) {
        if ($salt === null) {
            $salt = substr (md5 (uniqid (rand (), true)), 0, SALT_LENGTH);
        } else {
            $salt = substr ($salt, 0, SALT_LENGTH);
        }

        return $salt . sha1 ($salt . $plainText);
    }

}

////////////////////////////////////
?>
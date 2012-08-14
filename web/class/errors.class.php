<?php

////////////////////////////
//Output/internal encoding.
////////////////////////////
mb_internal_encoding ('UTF-8');
mb_http_output ('UTF-8');

////////////////////////////
////////////////////////////////////
//Custom error/exception handling.
////////////////////////////////////
//Class name.
class errors extends utility {

    //Variables.
    ////////////////////////////
    //Constructor.
    ////////////////////////////
    public function __construct () {

    }

    ////////////////////////////
    //Public class functions.
    ////////////////////////////
    //Static, shutdown on error method.
    public static function func_shutdown () {
        $isFatalError = false;
        $isMinorError = false;
        $error = error_get_last();
        if ($error) {
            switch ($error['type']) {
                case E_ERROR:
                case E_CORE_ERROR:
                case E_COMPILE_ERROR:
                case E_USER_ERROR:
                    $isFatalError = true;
                    break;
                case E_WARNING:
                case E_USER_WARNING:
                    $isMinorError = true;
            }
        }
        if ($isFatalError) {
            $errorbox = new errors();
            $errorbox -> func_html_fatalerrorbox ($error['message'], $error['file'], $error['line']);
        } else if ($isMinorError) {
            $errorbox = new errors();
            $errorbox -> func_html_minorerrorbox ($error['message'], $error['file'], $error['line']);
        }
    }

    ////////////////////////////
    //Private class functions.
    ////////////////////////////
    //Fatal error box/message builder.
    private function func_html_fatalerrorbox ($msg, $file, $line) {
        $message = "Error: " . strip_tags ($msg) . "\n\n";
        $message .= "File: " . $file . "\n\n";
        $message .= "Line: " . $line . "\n\n";
        $message .= "Time/Date: " . date ("d.m.y h:i:s") . "\n\n";
        //Provide your email address here and below, in order to be notified in the event of an error cropping up.
        parent::func_CCme ('crowkeep@gmail.com', 'AIRSafecast - Fatal PHP Error', $message, 'AIRSafecast');
        echo '
        <div class="errorbox" id="majorerror">
            <p>
                    <strong>Script Execution Halted - Error:</strong> ' . $msg . '<br /><br />
                    <strong>In File:</strong> ' . $file . '<br />
                    <strong>At Line:</strong> ' . $line . '<br /><br />
                    Information forwarded to: crowkeep@gmail.com / AIRSafecast Bugs.
            </p>
        </div>
        ';
    }

    //Minor errors/non-fatal/non-script-halting.
    private function func_html_minorerrorbox ($msg, $file, $line) {
        $message = "Error: " . strip_tags ($msg) . "\n\n";
        $message .= "File: " . $file . "\n\n";
        $message .= "Line: " . $line . "\n\n";
        $message .= "Time/Date: " . date ("d.m.y h:i:s") . "\n\n";
        parent::func_CCme ('crowkeep@gmail.com', 'AIRSafecast - Minor PHP Error', $message, 'AIRSafecast');
        echo '
        <div class="errorbox" id="minorerror">
            <p>
                <strong>Error:</strong> ' . $msg . '<br /><br />
                <strong>In File:</strong> ' . $file . '<br />
                <strong>At Line:</strong> ' . $line . '<br /><br />
                Information forwarded to: crowkeep@gmail.com / AIRSafecast Bugs.
            </p>
        </div>
        ';
    }

    ////////////////////////////
    //Protected class functions.
    ////////////////////////////
    ////////////////////////////
    //Destructor.
    ////////////////////////////
    public function __destruct () {
        
    }

}
////////////////////////////////////
?>
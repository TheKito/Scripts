<?php

register_shutdown_function(
    function () {
        $error = error_get_last();

        if ($error !== NULL)
        {
            header('X-Error-Message: '  .$error['message'], true, 599);
            header('X-Error-Code: '     .$error['type'],    true, 599);
            header('Content-Type: '     .'application/json',true, 599);
            echo json_encode(array(
                'Error' => array(
                    'Message'   => $error['message'],
                    'Code'      => $error['type']
                )
            ));
        }        
    }
);

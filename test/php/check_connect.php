<?php

define('ERROR',"\033[0;31m");
define('OK',"\033[0;32m");
define('HIGILIGHT',"\033[0;96m");
define('HIGILIGHT2',"\033[1;33;4;44m");
define('HIGILIGHT_ERROR',"\033[0;95m");

define('NC',"\033[0m");

if(count($argv) < 2){
    echo HIGILIGHT_ERROR." No IP and port provided".NC.PHP_EOL;
    exit(-1);
}

$host = $argv[1];

$host_parts = explode(":",$host);

$host = $host_parts[0];

if(isset($host_parts[1])){
    $port=$host_parts[1];
} elseif(isset($argv[2])){
    $port = $argv[2];
} else {
    echo HIGILIGHT_ERROR." No port provided".NC.PHP_EOL;
    exit(-1);
}

$port = intval($port);

$timeout = 30;

echo PHP_EOL."##############".PHP_EOL.PHP_EOL."TESTING ".HIGILIGHT2.$host.':'.$port.NC.PHP_EOL;

//check if connection established via is_resource
$sk = @fsockopen($host, $port, $errnum, $errstr, $timeout);
if (!is_resource($sk)) {
    echo ERROR."connection fail: ".HIGILIGHT_ERROR. $errnum . " " . $errstr.NC.PHP_EOL;
    exit(1);
} else {
    echo OK."Connected".NC.PHP_EOL;
    exit(0);
}
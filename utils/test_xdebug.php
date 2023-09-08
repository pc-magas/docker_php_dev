#!/usr/bin/env php

<?php

define('ERROR',"\033[0;31m");
define('OK',"\033[0;32m");
define('HIGILIGHT',"\033[0;96m");
define('HIGILIGHT_ERROR',"\033[0;95m");

define('NC',"\033[0m");

$xdebug_settings = getenv("XDEBUG_CONF_FILE");
$xdebug_settings = trim($xdebug_settings);
echo "SETTINGS FILE: ".HIGILIGHT.$xdebug_settings.NC.PHP_EOL;

$php_settings_dir = getenv("PHP_CONF_DIR");

if(dirname($xdebug_settings)!=trim($php_settings_dir)){
    echo "######".PHP_EOL.ERROR."Xdebug config file not in ".INFO.$php_settings_dir.NC.PHP_EOL;
    exit(1);
}

echo PHP_EOL."##### CONTENTS #####".PHP_EOL.HIGILIGHT.file_get_contents($xdebug_settings).NC.PHP_EOL;
$settings = parse_ini_file($xdebug_settings);

$host=$settings['xdebug.client_host'];
$port=$settings['xdebug.client_port'];
$timeout = 30;

echo PHP_EOL."##############".PHP_EOL."TESTING ".HIGILIGHT."${host}:${port}".NC.PHP_EOL;

//check if connection established via is_resource
$sk = @fsockopen($host, $port, $errnum, $errstr, $timeout);
if (!is_resource($sk)) {
    echo ERROR."connection fail: ".HIGILIGHT_ERROR. $errnum . " " . $errstr.NC.PHP_EOL;
    exit(1);
} else {
    echo OK."Connected".NC.PHP_EOL;
    exit(0);
}
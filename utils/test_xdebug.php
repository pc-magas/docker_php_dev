#!/usr/bin/env php

<?php

$xdebug_settings = getenv("XDEBUG_CONF_FILE");
echo "SETTINGS:".PHP_EOL;
echo file_get_contents($xdebug_settings).PHP_EOL;
$settings = parse_ini_file($xdebug_settings);

$host=$settings['xdebug.client_host'];
$port=$settings['xdebug.client_port'];
$timeout = 30;

echo "TESTING ${host}:${port}\n";

$sk = fsockopen($host, $port, $errnum, $errstr, $timeout);
if (!is_resource($sk)) {
    echo "connection fail: " . $errnum . " " . $errstr.PHP_EOL;
    exit(1);
} else {
    echo "Connected".PHP_EOL;
    exit(0);
}
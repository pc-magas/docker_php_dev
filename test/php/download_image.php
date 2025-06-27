<?php

$url = 'https://httpbin.org/image/png'; // You can replace this with any image URL

// Download image content via file_get_contents
$imageData = @file_get_contents($url);

if ($imageData === false) {
    echo "❌ Failed to download image from: $url<br>";
    $error = error_get_last();
    echo "PHP Error: " . $error['message'];
    exit;
}

// Send appropriate header
header('Content-Type: image/png');

// Output image content
echo $imageData;
#!/usr/bin/env php
<?php
/* This script will run forever checking for the availability of a twitter handle
 * starting at aaaa.
 */

// Allowed characters
$dictionary = str_split('abcdefghijklmnopqrstuvwxyz0123456789_');
$base = count($dictionary);
$i = 52059; // this is aaaa since all 1-3 characters handles are long gone

// Loop forever looking for handles, I run this though tee and then use grep
// to find available handles later
while(true) {
    $word = "";
    foreach(getIndex($i,$base) as $index) {
        $word .= $dictionary[$index];
    }
    echo checkUsernameAvailable($word);
    $i++;
}

function checkUsernameAvailable($username) {
    $json = json_decode(file_get_contents("https://twitter.com/users/username_available?username=$username"));
    if($json->valid) {
        return "\n\n$username is available!\n\n";
    } else {
        return "$username: No\n";
    }
}

// This will return an array with each value an index 0 - $base (37)
function getIndex($i,$base) {
    $ret = array();
    $div = floor($i / $base);
    $ret[0] = $i % $base;
    if($div > 0) {
        return array_merge(getIndex($div-1, $base), $ret);
    } else {
        return $ret;
    }
}

<?php

function debugVar($var, $exit = false) {
    echo '<pre style="font-size:11px;">';

    if (is_array($var) || is_object($var)) {
	echo htmlentities(print_r($var, true));
    } elseif (is_string($var)) {
	echo "string(" . strlen($var) . ") \"" . htmlentities($var) . "\"\n";
    } else {
	var_dump($var);
    }

    echo "\n</pre>";

    if ($exit) {
	exit;
    }
}

echo "<div style='text-align:center;color:red;font-size:15px;font-weight:bold'>";

echo "General Variables" . "</br>";
echo "REMOTE_ADDR:" . " " . $_SERVER['REMOTE_ADDR'] . "</br>";
echo "REMOTE_PORT:" . " " . $_SERVER['REMOTE_PORT'] . "</br>";
echo "SERVER_NAME:" . " " . $_SERVER['SERVER_NAME'] . "</br>";
echo "SERVER_PORT:" . " " . $_SERVER['SERVER_PORT'] . "</br>";
echo "HTTP_HOST:" . " " . $_SERVER['HTTP_HOST'] . "</br>";
echo "</div>";
echo "</br>";

debugVar($_SERVER);


echo "\n\r===============================================================\n\r";

phpinfo();
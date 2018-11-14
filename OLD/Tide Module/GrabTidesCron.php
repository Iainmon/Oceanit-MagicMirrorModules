<?php
$aipKey = "afa5d773-d01c-4c0c-8489-2052d00fe597";
$lat = "21.296832";
$lon = "-157.859319";
$downloadedJSON = file_get_contents("http://www.worldtides.info/api?heights&lat=$lat&lon=$lon&key=$aipKey");
file_put_contents('tides.json', $downloadedJSON);
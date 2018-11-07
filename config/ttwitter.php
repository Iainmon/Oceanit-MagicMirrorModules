<?php

// You can find the keys here : https://apps.twitter.com/

return [
	'debug'               => function_exists('env') ? env('APP_DEBUG', false) : false,

	'API_URL'             => 'api.twitter.com',
	'UPLOAD_URL'          => 'upload.twitter.com',
	'API_VERSION'         => '1.1',
	'AUTHENTICATE_URL'    => 'https://api.twitter.com/oauth/authenticate',
	'AUTHORIZE_URL'       => 'https://api.twitter.com/oauth/authorize',
	'ACCESS_TOKEN_URL'    => 'https://api.twitter.com/oauth/access_token',
	'REQUEST_TOKEN_URL'   => 'https://api.twitter.com/oauth/request_token',
	'USE_SSL'             => true,

	'CONSUMER_KEY'        => 'hLks7LTwSK2WBPK3gng1w4Bqi',
	'CONSUMER_SECRET'     => 's4xwuB2qe1uRY0lmL5AWF9US4h8gvX4KMjUimmaJidhtt9mxL4',
	'ACCESS_TOKEN'        => '826316154-rOnBS01LkAdkJFsJxWp0wez7gxBkRMTVfiQP1glC',
	'ACCESS_TOKEN_SECRET' => '9W4YP5kIH66EL1IYzAMiE4sXC3ZrfVu9rWpgW0lPTzuSW',
];

<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('test', 'TwitterController@test');
Route::get('twitterUserTimeLine', 'TwitterController@twitterUserTimeLine');
Route::post('tweet', ['as'=>'post.tweet','uses'=>'TwitterController@tweet']);
Route::get('save', 'TwitterController@saveTwitterUserTimeLine');

Auth::routes();
Route::get('/home', 'HomeController@index')->name('home');

Route::get('/reset-key', 'KeyController@reset')->name('reset-key');
Route::post('/reset-key', 'KeyController@reset')->name('reset-key-post');

Route::get('/validate-users', 'KeyController@validateUser')->name('validate-user');

Route::get('api/{userKey}/{key}/', 'TwitterController@pull');

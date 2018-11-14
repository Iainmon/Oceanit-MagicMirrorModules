<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Tweet extends Model
{
    //
    protected $table = 'tweets';

    protected $fillable = [
        'screen_name',
        'tweet_id',
        'content',
        'belongs_to'
    ];
}

<?php

namespace App\Http\Controllers;

use App\Tweet;
use App\User;
use Illuminate\Http\Request;
use Twitter;
use File;

class TwitterController extends Controller
{
    /**
     * Create a new controller instance.
     */

    public function __construct() {

    }

    public function retrieveAndIndex(Request $request) {

        $this->middleware('auth');

        $users = User::where('id', '>', 0)->with('preferences')->get();
        foreach ($users as $user) {
            foreach ($user->preferences as $preference) {
                if ($preference->type == '@') {
                    self::saveTwitterUserTimeLine($preference->twitter_identification, $user);
                }
            }
        }

        $request->session()->flash('status', 'Indexed all tweets.');

        return redirect(route('home'));
    }

    public function saveTwitterUserTimeLine($screenName, $user)
    {
        $timeline = Twitter::getUserTimeline(['screen_name' => $screenName, 'count' => 500, 'format' => 'object']);
        $bannedUserCollection = \DB::table('banned_users')->get();
        $bannedUsers = [];
        foreach ($bannedUserCollection as $bannedUser) array_push($bannedUsers, $bannedUser);
        $tweetModels = [];
        $rejectedTweetModels = [];
        foreach ($timeline as $tweet) {

            //if the user is banned, then don't add tweet to the database.
            if (in_array($tweet->user->screen_name, $bannedUsers)) {
                array_push($rejectedTweetModels, Tweet::firstOrCreate(
                    [
                        'tweet_id' => $tweet->id
                    ],
                    [
                        'screen_name' => $tweet->user->screen_name,
                        'tweet_id' => $tweet->id,
                        'content' => $tweet->text
                    ]
                ));
                continue;
            }

            //in the future, process tweets

            array_push($tweetModels, Tweet::firstOrCreate(
                [
                    'tweet_id' => $tweet->id
                ],
                [
                    'screen_name' => $tweet->user->screen_name,
                    'tweet_id' => $tweet->id,
                    'content' => $tweet->text,
                    'belongs_to' => $user->email
                ]
            ));
        }

        //save all
        foreach ($tweetModels as $tweetModel) $tweetModel->save();
        foreach ($rejectedTweetModels as $tweetModel) $tweetModel->save();
    }




















    public function twitterUserTimeLine()
    {
        $data = Twitter::getUserTimeline(['screen_name' => 'iainmoncrief', 'count' => 10, 'format' => 'array']);
        //return response()->json($data);
        return view('twitter',compact('data'));
    }

    public function saveTwitterUserTimeLineTEST() {
        $timeline = Twitter::getUserTimeline(['screen_name' => 'elonmusk', 'count' => 500, 'format' => 'object']);
        $bannedUserCollection = \DB::table('banned_users')->get();
        $bannedUsers = [];
        foreach ($bannedUserCollection as $bannedUser) array_push($bannedUsers, $bannedUser);
        $tweetModels = [];
        $rejectedTweetModels = [];
        foreach ($timeline as $tweet) {

            //if the user is banned, then don't add tweet to the database.
            if (in_array($tweet->user->screen_name, $bannedUsers)) {
                array_push($rejectedTweetModels, Tweet::firstOrCreate(
                    [
                        'tweet_id' => $tweet->id
                    ],
                    [
                        'screen_name' => $tweet->user->screen_name,
                        'tweet_id' => $tweet->id,
                        'content' => $tweet->text
                    ]
                ));
                continue;
            }

            //in the future, process tweets

            array_push($tweetModels, Tweet::firstOrCreate(
                [
                    'tweet_id' => $tweet->id
                ],
                [
                    'screen_name' => $tweet->user->screen_name,
                    'tweet_id' => $tweet->id,
                    'content' => $tweet->text,
                    'belongs_to' => 'iainmoncrief@gmail.com'
                ]
            ));
        }

        //save all
        foreach ($tweetModels as $tweetModel) $tweetModel->save();
        foreach ($rejectedTweetModels as $tweetModel) $tweetModel->save();

        return response('Saved');
    }


    /**
     * Create a new controller instance.
     *
     * @param Request $request
     */
    public function tweet(Request $request)
    {
        $this->validate($request, [
            'tweet' => 'required'
        ]);

        $newTwitte = ['status' => $request->tweet];

        var_dump($newTwitte);

        if(!empty($request->images)){
            foreach ($request->images as $key => $value) {
                $uploaded_media = Twitter::uploadMedia(['media' => File::get($value->getRealPath())]);
                if(!empty($uploaded_media)){
                    $newTwitte['media_ids'][$uploaded_media->media_id_string] = $uploaded_media->media_id_string;
                }
            }
        }

        //$twitter = Twitter::postTweet($newTwitte);


        //return back();
    }


    public function pull($userKey, $key, $count = 10) {

        $user = User::where('user_key', $userKey)->first();

        if (!isset($user) || $user->key != $key) {
            return response('Invalid API key.');
        }

        if (!$user->validated) return response('You have not yet been validated.');

        $tweets = Tweet::where('belongs_to', $user->email)->take($count)->get();
        foreach ($tweets as $tweet) {
            //tweet formatting
            unset($tweet->id);
            unset($tweet->belongs_to);
        }

        return response()->json($tweets);
    }


    public static function test() {
        $followers = Twitter::getFollowersIds(['screen_name' => 'iainmoncrief'])->ids;
        $followerUserNames = [];

        foreach ($followers as $follower) {
            $followerScreenName = Twitter::getUsersLookup(['user_id' => $follower])[0]->screen_name;
            $follower = '@'.$followerScreenName;
            array_push($followerUserNames, $follower);
        }

        $userTweetList = "";
        foreach ($followerUserNames as $name) {
            echo "Sent to: <br>$name<br>";
            $userTweetList .= " $name";
        }
        $tweetContent = "Testing send all function... ".$userTweetList;

        echo $tweetContent;

        //$twitter = Twitter::postTweet(['status' => $tweetContent]);

        //return response()->json(Twitter::getUsersLookup(['screen_name' => 'iainmoncrief'])[0]->screen_name);
    }
}
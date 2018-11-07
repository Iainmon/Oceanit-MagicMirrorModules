<?php


namespace App\Http\Controllers;


use Illuminate\Http\Request;
use Twitter;
use File;


class TwitterController extends Controller
{
    /**
     * Create a new controller instance.
     */
    public function twitterUserTimeLine()
    {
        $data = Twitter::getUserTimeline(['screen_name' => 'iainmoncrief', 'count' => 10, 'format' => 'array']);
        //return response()->json($data);
        return view('twitter',compact('data'));
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
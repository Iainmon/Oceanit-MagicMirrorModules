<?php
/**
 * Created by PhpStorm.
 * User: iainmoncrief
 * Date: 11/14/18
 * Time: 2:18 PM
 */

namespace App\Http\Controllers;
use App\User;
use Illuminate\Http\Request;

class KeyController extends Controller {



    private static function keygen($length = 32) {
        $characters = '000123456789abcdefghijklmnopqrstuvwxyz';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }

    public function reset(Request $request) {

        $user = \Auth::user();
        $firstTime = (!$user->key);

        if (!$request->has('i-understand')) return view('reset-key', [
            'user' => $user
        ]);

        $allExistingUsers = User::where('id', '>', 0)->get();

        $allExistingKeys = [];
        foreach ($allExistingUsers as $user) {
            array_push($allExistingKeys, $user->key);
        }

        do {
            $newKey = self::keygen();
        } while (in_array($newKey, $allExistingKeys));

        $user->key = $newKey;

        if (!$user->user_key) {

            $allExistingUserKeys = [];
            foreach ($allExistingUsers as $user) {
                array_push($allExistingUserKeys, $user->key);
            }

            do {
                $newKey = self::keygen(16);
            } while (in_array($newKey, $allExistingUserKeys));

            $user->user_key = $newKey;
        }

        $user->save();

        if ($firstTime) {
            $request->session()->flash('status', 'Your API key and user ID have been created!');
        } else {
            $request->session()->flash('status', 'Your API key has been reset!');
        }

        return redirect(route('home'));
    }

    public function validateUser(Request $request) {
        $user = \Auth::user();

        if (!$user->isAdmin) {
            $request->session()->flash('status', 'You are not an Administrator!');
            return back();
        }

        if (!$request->has('validate')) {
            $users = User::where('id', '>', 0)->get();
            return view('validate-users', [
                'users' => $users
            ]);
        }

        $validating = $request->get('validate');

        if ($validating == 'true') {
            $userToValidate = User::where('id', $request->get('user-id'))->first();
            $userToValidate->validated = true;
            $userToValidate->save();
            $request->session()->flash('status', 'The user "'.$userToValidate->name.'" has been validated!');
        } else if ($validating == 'false') {
            $userToValidate = User::where('id', $request->get('user-id'))->first();
            $userToValidate->validated = false;
            $userToValidate->save();
            $request->session()->flash('status', 'The user "'.$userToValidate->name.'" has been invalidated.');
        }

        return back();

    }
}
<?php
/**
 * Created by PhpStorm.
 * User: iainmoncrief
 * Date: 11/28/18
 * Time: 11:23 AM
 */

namespace App\Http\Controllers;


use App\UserPreference;
use Illuminate\Http\Request;

class PreferenceController extends Controller {

    public function edit(Request $request) {

        if (!$request->has('action')) return $this->view($request);

        $mode = $request->get('action');
        switch ($mode) {
            case 'create':
                return $this->create($request);
                break;
            case 'delete':
                return $this->delete($request);
                break;
            case 'edit':
                return $this->change($request);
                break;
            default:
                return redirect(route('manage-rule'));
        }
    }

    public function view(Request $request) {
        $user = \Auth::user();
        $rules = UserPreference::where('user_email', $user->email)->get();
        return view('manage-rules', [
            'rules' => $rules
        ]);
    }

    public function change(Request $request) {
        $method = $request->get('method');
        switch ($method) {
            case 'filter':
                $rule = UserPreference::where('id', $request->get('rule-id'))->first();
                $rule->filter = !$rule->filter;
                $rule->save();
                return $this->view($request);
                break;
        }
    }

    public function create(Request $request) {

        $user = \Auth::user();

        $type = $request->get('type');
        $twitterIdentification = $request->get('twitter-identification');
        $filter = $request->get('filter-results');

        $newPreference = new UserPreference();
        $newPreference->user_email = $user->email;
        $newPreference->type = $type;
        $newPreference->twitter_identification = $twitterIdentification;
        $newPreference->filter = !!$filter;
        $newPreference->save();

        $request->session()->flash('status', 'Rule has been added.');
        return back();
    }

    public function delete(Request $request) {

        $user = \Auth::user();

        $newPreference = UserPreference::where('id', $request->get('rule-id'))->first();
        $newPreference->user_email = $user->email.'DELETED';
        $newPreference->save();

        $request->session()->flash('status', 'Rule has been added.');
        return back();
    }
}
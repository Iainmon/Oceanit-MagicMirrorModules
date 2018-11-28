@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <div class="custom-control-inline">Manage Rules</div>
                        <div class="custom-control-inline">
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
                                Open modal
                            </button>
                        </div>

                        <div class="modal" id="myModal">
                            <div class="modal-dialog">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <h4 class="modal-title">Create Rule</h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>

                                    <!-- Modal body -->
                                    <div class="modal-body">
                                        <form action="{{ route('manage-rules-post') }}" method="post">
                                            @csrf
                                            <input type="text" name="action" value="create" style="display: none;">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="exampleRadios" id="username"
                                                       value="@" checked>
                                                <label class="form-check-label" for="username">
                                                    Username
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="type" id="hashtag"
                                                       value="#">
                                                <label class="form-check-label" for="hashtag">
                                                    Hashtag
                                                </label>
                                            </div>

                                            <br>

                                            <div class="form-group">
                                                <label for="identifier">Twitter Username or Hashtag</label>
                                                <input name="twitter-identification" type="text" class="form-control" id="identifier"
                                                       aria-describedby="emailHelp" placeholder="Twitter Username or Hashtag">
                                                <small id="emailHelp" class="form-text text-muted"><b>You must exclude '@' and '#' symbols.</b></small>
                                            </div>
                                            <div class="form-check">
                                                <input name="filter" class="form-check-input" type="checkbox" value="" id="filter"
                                                       checked>
                                                <label class="form-check-label" for="filter">
                                                    Filter for explicit language.
                                                </label>
                                            </div>
                                            <br>
                                            <button type="submit" class="btn btn-success">Create</button>

                                        </form>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="card-body">
                        <div class="text-center">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th scope="col">List</th>
                                    <th scope="col">Type</th>
                                    <th scope="col">Identifier</th>
                                    <th scope="col">Filter Status</th>
                                    <th scope="col">Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                @php
                                    $i = 1;
                                @endphp
                                @foreach($rules as $rule)
                                    <tr>
                                        <th scope="row">{{ $i }}</th>
                                        <td>{{ $rule->type }}</td>
                                        <td>{{ $rule->type }}{{ $rule->twitter_identification }}</td>
                                        <td>
                                            <form action="{{ route('manage-rules-post') }}" method="post">
                                                @csrf
                                                <input type="text" name="rule-id" value="{{ $rule->id }}"
                                                       style="display: none;">
                                                <input type="text" name="action" value="edit" style="display: none;">
                                                <input type="text" name="method" value="filter" style="display: none;">
                                                @if($rule->filter)
                                                    <button type="submit" class="btn btn-success">Filtering On</button>
                                                @else
                                                    <button type="submit" class="btn btn-danger">Filtering Off</button>
                                                @endif
                                            </form>
                                        </td>
                                        <td>
                                            <form action="{{ route('manage-rules-post') }}" method="post">
                                                @csrf
                                                <input type="text" name="rule-id" value="{{ $rule->id }}"
                                                       style="display: none;">
                                                <input type="text" name="action" value="delete" style="display: none;">
                                                <button type="submit" class="btn btn-outline-danger">Delete</button>
                                                {{--@if(!$user->validated)--}}
                                                {{--<input type="text" name="validate" value="true" style="display: none;">--}}
                                                {{--<button type="submit" class="btn btn-success">Validate</button>--}}
                                                {{--@else--}}
                                                {{--<input type="text" name="validate" value="false" style="display: none;">--}}
                                                {{--<button type="submit" class="btn btn-danger">Invalidate</button>--}}
                                                {{--@endif--}}
                                            </form>
                                        </td>
                                    </tr>
                                    @php
                                        $i++;
                                    @endphp
                                @endforeach
                                </tbody>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
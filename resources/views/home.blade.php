@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <div class="custom-control-inline">Dashboard</div>
                    <div class="custom-control-inline">
                        <a class="btn btn-primary" href="{{ route('validate-user') }}" role="button">Manage Rules</a>
                    </div>
                    @if(\Illuminate\Support\Facades\Auth::user()->isAdmin)
                        <div class="custom-control-inline">
                            <a class="btn btn-outline-danger" href="{{ route('validate-user') }}" role="button">Validate Users</a>
                        </div>
                    @endif
                </div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif
                    @if($user->key)
                        <div class="text-center">
                            <p>Your user ID is</p>
                            <h3><code>{{ $user->user_key }}</code></h3>
                            <br>
                            <p>Your API key is</p>
                            <h1><code>{{ $user->key }}</code></h1>
                            <hr>

                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
                                See My API URL
                            </button>

                            <div class="modal" id="myModal">
                                <div class="modal-dialog">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <h5 class="modal-title">Your API URL</h5>
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        </div>

                                        <div class="modal-body">
                                            <code>{{ url('api') }}/{{ $user->user_key }}/{{ $user->key }}</code>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <hr>

                            <p>If you API key was stolen, you may reset it <a href="{{ route('reset-key') }}">here</a>.</p>

                        </div>
                    @else
                        Doesn't look like you have a key yet... Would you like to <a href="{{ route('reset-key') }}">create one</a>?
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
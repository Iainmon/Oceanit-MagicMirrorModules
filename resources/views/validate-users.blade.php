@extends('layouts.app')

@section('content')
    <style>
        .disnone {
            display: none;
        }
    </style>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">Validate Users</div>
                    <div class="card-body">
                        <div class="text-center">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th scope="col">Database ID</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Validated</th>
                                    <th scope="col">Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                @foreach($users as $user)
                                    <tr>
                                        <th scope="row">{{ $user->id }}</th>
                                        <td>{{ $user->name }}</td>
                                        <td>{{ $user->email }}</td>
                                        <td>{{ ($user->validated) ? 'Yes' : 'No' }}</td>
                                        <td>
                                            <form action="{{ route('validate-user') }}" method="get">
                                                <input type="text" name="user-id" value="{{ $user->id }}" style="display: none;">
                                                @if(!$user->validated)
                                                    <input type="text" name="validate" value="true" style="display: none;">
                                                    <button type="submit" class="btn btn-success">Validate</button>
                                                @else
                                                    <input type="text" name="validate" value="false" style="display: none;">
                                                    <button type="submit" class="btn btn-danger">Invalidate</button>
                                                @endif
                                            </form>
                                        </td>
                                    </tr>
                                @endforeach
                                </tbody>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">Reset Key</div>
                    <div class="card-body">
                        <div class="text-center">

                            <form action="{{ route('reset-key-post') }}" method="post">
                                @csrf
                                @if($user->key)
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="exampleCheck1" name="i-understand" required>
                                        <label class="form-check-label" for="exampleCheck1">I understand that my old key will become invalidated.</label>
                                    </div>
                                    <br>
                                    <button type="submit" class="btn btn-primary">Reset Key</button>
                                @else
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="exampleCheck1" name="i-understand" required>
                                        <label class="form-check-label" for="exampleCheck1">I understand that the API key is meant to be kept secret.</label>
                                    </div>
                                    <br>
                                    <p>Creating your first API key will generate a new and unchanging user ID.</p>
                                    <button type="submit" class="btn btn-primary">Create Key</button>
                                @endif
                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
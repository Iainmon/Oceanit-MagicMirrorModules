@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">Set Key</div>

                    <div class="card-body">
                        <div class="text-center">
                            <p>
                                Your new key will be emailed to you, as well as being displayed on your dashboard.
                            </p>
                        </div>
                        <form action="{{ route('setKey') }}" method="post">
                            <div class="form-group">
                                <label for="pwd">Enter your password to generate a new key.</label>
                                <input type="password" class="form-control" id="pwd">
                            </div>
                            <div class="form-group form-check">
                                <label class="form-check-label">
                                    <input class="form-check-input" type="checkbox" required>
                                    I understand that my old key will become invalid.
                                </label>
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
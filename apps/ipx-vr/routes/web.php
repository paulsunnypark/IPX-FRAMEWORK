<?php

use Illuminate\Support\Facades\Route;

// Vue.js SPA 진입점 (모든 경로를 Vue Router가 처리)
Route::get('/{any}', function () {
    return view('app');
})->where('any', '.*');

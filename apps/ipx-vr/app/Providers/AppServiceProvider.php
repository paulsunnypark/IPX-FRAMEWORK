<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Windows 환경에서 chmod() 오류 억제
        // Docker 볼륨 마운트 시 Windows 파일 시스템에서는 chmod()가 작동하지 않음
        // 부팅 단계에서 발생하는 오류를 처리하기 위해 error_handler 사용
        set_error_handler(function ($errno, $errstr, $errfile, $errline) {
            // chmod() 관련 오류만 무시
            if (strpos($errstr, 'chmod(): Operation not permitted') !== false) {
                return true; // 오류 억제
            }
            return false; // 다른 오류는 기본 핸들러로 전달
        }, E_WARNING | E_NOTICE);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}

import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import laravel from 'laravel-vite-plugin';
import { fileURLToPath, URL } from 'node:url';
import path from 'path';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
            buildDirectory: 'public/build',
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    cacheDir: 'node_modules/.vite',
    resolve: {
        alias: {
            '@': fileURLToPath(new URL('./resources/js', import.meta.url))
        }
    },
    server: {
        host: '0.0.0.0',
        port: 5173,  // Vite 개발 서버 포트 (Laravel 8890과 분리)
        strictPort: false,  // 포트가 사용 중이면 다음 포트 시도
        hmr: {
            host: 'localhost',
            port: 5173
        },
        watch: {
            usePolling: true
        },
        // Monorepo 구조에서 node_modules 접근 허용
        fs: {
            allow: [
                '..',  // 상위 디렉토리 (루트의 node_modules 접근)
                '../../node_modules',  // 루트의 node_modules
                path.resolve(__dirname, '../..'),  // 프로젝트 루트 (동적 경로)
            ]
        }
    },
    build: {
        outDir: 'public/build',
        emptyOutDir: true,
        manifest: true,
        rollupOptions: {
            input: 'resources/js/app.js'
        }
    }
});


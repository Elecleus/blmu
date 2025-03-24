import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    // 引入 Vue 插件
    plugins: [vue()],

    // 防止 Vite 清除 Rust 显示的错误
    clearScreen: false,
    server: {
        // Tauri 工作于固定端口，如果端口不可用则报错
        strictPort: true,
        // 如果设置了 host，Tauri 则会使用
        host: false,
        port: 3000,
    },
    // 添加有关当前构建目标的额外前缀，使这些 CLI 设置的 Tauri 环境变量可以在客户端代码中访问
    envPrefix: ['VITE_', 'TAURI_ENV_*'],
});
/// <reference types="vitest/config" />
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// В режиме разработки фронтенд обращается к относительным /api и /media, а Vite
// проксирует их на backend (gunicorn :8000). В продакшене тем же путям отвечает
// Caddy — поэтому код фронтенда одинаков в обоих окружениях.
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': 'http://127.0.0.1:8000',
      '/media': 'http://127.0.0.1:8000',
    },
  },
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/test/setup.js',
  },
})

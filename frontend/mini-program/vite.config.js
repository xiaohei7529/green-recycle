import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'
import { fileURLToPath } from 'node:url'

export default defineConfig({
  plugins: [uni()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('.', import.meta.url))
    }
  }
})

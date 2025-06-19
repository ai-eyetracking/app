import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue()
  ],
  server: {
    hmr: {
      overlay: true,
      clientPort: 3036,
      host: 'localhost'
    },
    watch: {
      usePolling: true
    }
  }
})

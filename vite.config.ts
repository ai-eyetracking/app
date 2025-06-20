import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    RubyPlugin()
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
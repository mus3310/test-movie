import devtoolsJson from 'vite-plugin-devtools-json';
import tailwindcss from '@tailwindcss/vite';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [
		tailwindcss(),
		sveltekit(),
		devtoolsJson()
	],
	server: {
		port: 3000,
		proxy: {
		  '/api': {
			target: 'https://api.idoomovies.com',
			changeOrigin: true,
			rewrite: (path) => path.replace(/^\/api/, '')
		  }
		}
	}
});

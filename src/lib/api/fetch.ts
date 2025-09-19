/**
 * A reusable API fetch helper for SvelteKit 5.
 *
 * @param {string} endpoint - Path to your API endpoint (e.g. "/users")
 * @param {object} [options={}] - Fetch options (method, headers, body, etc.)
 * @param {string} [base='/api'] - Base path or external API base URL
 * @returns {Promise<any>} - JSON response data
 */

import { config } from '$lib/config';

export async function apiFetch(endpoint = '', options = {}) {
	try {
		const token = btoa(`${config.authUser}:${config.authPass}`);
		const _fetch = (options as any)?.fetch ?? fetch;
		const res = await _fetch(`${endpoint}`, {
			...options,
			headers: {
				Referer: 'https://mymovies-hd.com',
				Authorization: `Basic ${token}`,
				'Content-Type': 'application/json',
				...((options as any).headers || {})
			}
		});

		if (!res.ok) {
			const errorText = await res.text();
			throw new Error(errorText);
		}

		// Handle no-content responses
		if (res.status === 204) return {};

		return await res.json();
	} catch (err) {
		console.error('apiFetch error:', err);
		throw err;
	}
}

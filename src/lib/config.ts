export const config = {
	baseUrl: import.meta.env.VITE_PUBLIC_API_BASE_URL || 'https://api.idoomovies.com',
	// baseLocale: import.meta.env.VITE_PUBLIC_BASE_LOCALE,
	// tagVersion: import.meta.env.VITE_PUBLIC_TAG_VERSION,
	authUser: import.meta.env.VITE_BASIC_AUTH_USER,
	authPass: import.meta.env.VITE_BASIC_AUTH_PASS,
	movieStreamUrl: import.meta.env.VITE_MOVIE_STREAM_URL,
	domainUrl: import.meta.env.VITE_MOVIE_DOMAIN_URL,

	// You can also access private server-side variables like:
	// secret: import.meta.env.PRIVATE_SECRET (server-only)
};

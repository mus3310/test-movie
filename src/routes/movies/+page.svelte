<script lang="ts">
	import { page } from '$app/state';
	import { fetchMoviesSeries } from '$lib/store/movies';
	import { listMovies } from '$lib/store/movies';
	import MovieList from '$lib/components/MovieList.svelte';
	import Pagination from '$lib/components/Pagination.svelte';

	const hasCurrentPage = $derived(page.url.searchParams.has('page'));
	
	$effect(() => {
		const fetchData = async () => {
			console.log('hasCurrentPage', hasCurrentPage);
			if (hasCurrentPage) {
				console.log('page', page.url.searchParams.get('page'));
				await fetchMoviesSeries({
					page: parseInt(page.url.searchParams.get('page') ?? '1'),
					page_size: 30,
					sort_by: 'last_updated_date',
				});
			} else {
				console.log('no page');
				await fetchMoviesSeries();
			}
			console.log('listMovies', $listMovies.moviesSeries.data);
		};
		
		fetchData();
	});
</script>

<MovieList movies={$listMovies.moviesSeries.data} />
<Pagination total={$listMovies.moviesSeries.total} page_size={$listMovies.moviesSeries.page_size} />

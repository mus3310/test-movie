<script lang="ts">
	import { fetchSeries } from '$lib/store/movies';
	import { listMovies } from '$lib/store/movies';
	import { page } from '$app/state';
	import Pagination from '$lib/components/Pagination.svelte';
	import MovieList from '$lib/components/MovieList.svelte';
	
	const hasCurrentPage = $derived(page.url.searchParams.has('page'));
	
	$effect(() => {
		const fetchData = async () => {
			if (hasCurrentPage) {
				await fetchSeries({
					page: parseInt(page.url.searchParams.get('page') ?? '1'),
					page_size: 30,
					sort_by: 'last_updated_date',
				});
			} else {
				await fetchSeries();
			}
			console.log('listMovies', $listMovies.series.data);
		};
		
		fetchData();
	});
</script>

<MovieList movies={$listMovies.series.data} />
<Pagination total={$listMovies.series.total} page_size={$listMovies.series.page_size} />
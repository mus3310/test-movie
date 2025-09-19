<script lang="ts">
	import { page } from '$app/state';
	import { fetchPorns } from '$lib/store/movies';
	import { listMovies } from '$lib/store/movies';
	import PronList from '$lib/components/PronList.svelte';
	import Pagination from '$lib/components/Pagination.svelte';

	const hasCurrentPage = $derived(page.url.searchParams.has('page'));
	
	$effect(() => {
		const fetchData = async () => {
			if (hasCurrentPage) {
				await fetchPorns({
					page: parseInt(page.url.searchParams.get('page') ?? '1'),
					page_size: 30,
					sort_by: 'last_updated_date',
				});
			} else {
				await fetchPorns();
			}
			console.log('listMovies', $listMovies.porns.data);
		};
		
		fetchData();
	});
</script>

<PronList porns={$listMovies.porns.data} />
<Pagination total={$listMovies.porns.total} page_size={$listMovies.porns.page_size} />

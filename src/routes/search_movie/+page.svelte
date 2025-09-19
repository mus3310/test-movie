<script lang="ts">
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { searchMovies } from '$lib/store/movies';
	import { listMovies } from '$lib/store/movies';
	import MovieList from '$lib/components/MovieList.svelte';
	import Pagination from '$lib/components/Pagination.svelte';
	// ดึง keyword จาก query string
	let keyword = page.url.searchParams.get('keyword') || '';

	$effect(() => {
		const fetchData = async () => {
			await searchMovies({
				page: parseInt(page.url.searchParams.get('page') ?? '1'),
				search: keyword,
				page_size: 30
			});
			console.log('searchMovies', $listMovies.searchMovies.data);
		};
		fetchData();
	});

	function onSearch(e: Event) {
		e.preventDefault();
		goto(`/search_movie?keyword=${encodeURIComponent(keyword)}`);
	}
</script>

<h1 class="text-2xl font-bold text-white">ผลการค้นหา: "{keyword}"</h1>
{#if $listMovies.searchMovies.data.length > 0}
	<h2 class="text-2xl font-bold text-white">มีทั้งหมด {$listMovies.searchMovies.total} รายการ</h2>
	<MovieList movies={$listMovies.searchMovies.data} />
	<Pagination
		total={$listMovies.searchMovies.total}
		page_size={$listMovies.searchMovies.page_size}
	/>
{:else if keyword}
	<p class="mt-[100px] text-center text-2xl font-bold text-white">ไม่พบผลลัพธ์สำหรับ "{keyword}"</p>
{/if}

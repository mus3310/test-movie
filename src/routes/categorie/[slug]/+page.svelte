<script lang="ts">
	import { page } from '$app/state';
	import { fetchGenres } from '$lib/store/home';
	import { listHome } from '$lib/store/home';
	import { fetchMoviesSeries } from '$lib/store/movies';
	import { listMovies } from '$lib/store/movies';
	import MovieList from '$lib/components/MovieList.svelte';
	import Pagination from '$lib/components/Pagination.svelte';
	import PronList from '$lib/components/PronList.svelte';
	import { fetchPorns } from '$lib/store/movies';

	const currentPath = $derived(page.url.pathname);
	const category = $derived(currentPath.split('/').pop());
	const currentPage = $derived(page.url.searchParams.get('page'));
	// const hasCurrentPage = $derived(page.url.searchParams.has('page'));

	let dataFormShow = {
		action: 'บู๊',
		adventure: 'ผจญภัย',
		animation: 'แอนนิเมชั่น',
		comedy: 'ตลก',
		crime: 'อาชญากรรม',
		documentary: 'สารคดี',
		drama: 'ดราม่า',
		family: 'ครอบครัว',
		fantasy: 'จินตนาการ',
		history: 'ประวัติศาสตร์',
		horror: 'สยองขวัญ',
		music: 'ดนตรี',
		mystery: 'ลึกลับ',
		romance: 'โรแมนติก',
		sci_fi: 'นิยายวิทยาศาสตร์',
		tv: 'ภาพยนตร์โทรทัศน์',
		thriller: 'ระทึกขวัญ',
		war: 'สงคราม',
		western: 'ตะวันตก',
		action_adv: 'บู๊, ผจญภัย',
		kids: 'สำหรับเด็ก',
		news: 'ข่าว',
		reality: 'เรียลลิตี้',
		sci_fi2: 'จินตนาการแนววิทยาศาสตร์',
		drama_tv: 'ละคร',
		dialogue: 'บทสนทนา',
		war_po: 'สงครามและการเมือง'
	};

	let dataFromApi = [
		{
			id: '647efc87b56673f4f462eda4',
			name: 'บู๊'
		},
		{
			id: '647efccab56673f4f462eda6',
			name: 'ผจญภัย'
		},
		{
			id: '647efff6b56673f4f462eda8',
			name: 'แอนนิเมชั่น'
		},
		{
			id: '647f0006b56673f4f462eda9',
			name: 'ตลก'
		},
		{
			id: '647f0017b56673f4f462edaa',
			name: 'อาชญากรรม'
		},
		{
			id: '647f002ab56673f4f462edac',
			name: 'สารคดี'
		},
		{
			id: '647f0034b56673f4f462edad',
			name: 'ดราม่า'
		},
		{
			id: '647f0042b56673f4f462edae',
			name: 'ครอบครัว'
		},
		{
			id: '647f004cb56673f4f462edaf',
			name: 'จินตนาการ'
		},
		{
			id: '647f0058b56673f4f462edb0',
			name: 'ประวัติศาสตร์'
		},
		{
			id: '647f0067b56673f4f462edb1',
			name: 'สยองขวัญ'
		},
		{
			id: '647f0074b56673f4f462edb2',
			name: 'ดนตรี'
		},
		{
			id: '647f007eb56673f4f462edb3',
			name: 'ลึกลับ'
		},
		{
			id: '647f0089b56673f4f462edb4',
			name: 'โรแมนติก'
		},
		{
			id: '647f0097b56673f4f462edb5',
			name: 'นิยายวิทยาศาสตร์'
		},
		{
			id: '647f00a3b56673f4f462edb6',
			name: 'ภาพยนตร์โทรทัศน์'
		},
		{
			id: '647f00aeb56673f4f462edb7',
			name: 'ระทึกขวัญ'
		},
		{
			id: '647f00b8b56673f4f462edb8',
			name: 'สงคราม'
		},
		{
			id: '647f00c2b56673f4f462edb9',
			name: 'ตะวันตก'
		},
		{
			id: '648a98a06b8c75f304a340b8',
			name: 'บู๊, ผจญภัย'
		},
		{
			id: '648a99c26b8c75f304a340b9',
			name: 'สำหรับเด็ก'
		},
		{
			id: '648a9aa16b8c75f304a340ba',
			name: 'ข่าว'
		},
		{
			id: '648a9acd6b8c75f304a340bb',
			name: 'เรียลลิตี้'
		},
		{
			id: '648a9b206b8c75f304a340bc',
			name: 'จินตนาการแนววิทยาศาสตร์'
		},
		{
			id: '648a9c5f6b8c75f304a340bd',
			name: 'ละคร'
		},
		{
			id: '648a9c996b8c75f304a340be',
			name: 'บทสนทนา'
		},
		{
			id: '648a9ccc6b8c75f304a340bf',
			name: 'สงครามและการเมือง'
		}
	];

	// Function to get genre ID from category
	function getGenreIdByCategory(categoryKey: string): string | null {
		// Get Thai name from dataFormShow
		const thaiName = dataFormShow[categoryKey as keyof typeof dataFormShow];
		if (!thaiName) return null;

		// Find matching item in dataFromApi
		const matchedGenre = dataFromApi.find((item) => item.name === thaiName);
		return matchedGenre ? matchedGenre.id : null;
	}

	// Derived value to get current genre ID
	const genreId = $derived(category ? getGenreIdByCategory(category) : null);

	// Use $effect to fetch movies when genreId or currentPage changes
	$effect(() => {
		const fetchData = async () => {
			if (genreId) {
				const page = currentPage ? parseInt(currentPage) : 1;
				await fetchMoviesSeries({
					page: page,
					page_size: 30,
					sort_by: 'last_updated_date',
					genres_id: genreId
				} as any);
			} else if (category === 'prons') {
				const page = currentPage ? parseInt(currentPage) : 1;
				await fetchPorns({
					page: page,
					page_size: 30,
					sort_by: 'last_updated_date',
				});
			}

			console.log('listMovies', $listMovies.moviesSeries.data);
			console.log('category', category);
			console.log('currentPage', currentPage);
			console.log('genreId', genreId);
		};
		
		fetchData();
	});
</script>

<div class="text-white">
	<h1 class="text-2xl font-bold capitalize">หนัง {category} ทั้งหมด</h1>
	{#if category === 'prons'}
		<h1 class="text-2xl font-bold">มีทั้งหมด {$listMovies.porns.total} รายการ</h1>
	{:else}
		<h1 class="text-2xl font-bold">มีทั้งหมด {$listMovies.moviesSeries.total} รายการ</h1>
	{/if}
	<!-- <p>Genre ID: {genreId}</p>
	<p>Value of 'page': {currentPage}</p> -->
	{#if $listMovies.moviesSeries.data.length > 0}
		<MovieList movies={$listMovies.moviesSeries.data} />
		<Pagination total={$listMovies.moviesSeries.total} page_size={$listMovies.moviesSeries.page_size} />
		{:else if category === 'prons'}
		<PronList porns={$listMovies.porns.data} />
		<Pagination total={$listMovies.porns.total} page_size={$listMovies.porns.page_size} />
	{/if}
</div>

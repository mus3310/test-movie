<script lang="ts">
	import { listMovies } from '$lib/store/movies';
	import { invalidateAll } from '$app/navigation';
	interface Props {
		movies: string[];
		movieType?: string;
	}

	let { movies, movieType }: Props = $props();
	import { fetchMoviesSeries } from '$lib/store/movies';
	import { fetchPorns } from '$lib/store/movies';
	import MovieList from './MovieList.svelte';
	import PronList from './PronList.svelte';
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

	function getGenreIdByCategory(categoryKey: string): string | null {
		const matchedGenre = dataFromApi.find((item) => item.name === categoryKey);
		return matchedGenre ? matchedGenre.id : null;
	}

	let genreId = $state(movies[0] ? getGenreIdByCategory(movies[0]) : null);

	$effect(() => {
		const fetchData = async () => {
			if (genreId && movieType === 'movies') {
				await fetchMoviesSeries({
					page: 1,
					page_size: 6,
					sort_by: 'last_updated_date',
					genres_id: genreId
				} as any);
			} else if (movieType === 'porns') {
				let page = Math.floor(Math.random() * 100) + 1;
				console.log('random page', page);
				await fetchPorns({
					page: page,
					page_size: 6,
					sort_by: 'last_updated_date'
				});
			}
			// console.log('listMovies', $listMovies.moviesSeries.data);
			// console.log('list porns', $listMovies.porns.data);
			// console.log('movieType', movieType);
			// console.log('genreId', genreId);
		};

		fetchData();
	});
</script>

<div class="text-white">
	<div>You may also like</div>
	<!-- <pre class="text-white">{JSON.stringify(genreId, null, 2)}</pre> -->
	{#if movieType === 'movies'}
		<MovieList movies={$listMovies.moviesSeries.data} />
	{/if}
	{#if movieType === 'porns'}
		<PronList porns={$listMovies.porns.data} />
	{/if}
</div>

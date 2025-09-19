<script lang="ts">
	import CategoriesBanner from '$lib/components/CategoriesBanner.svelte';
	import PromoBigBanner from '$lib/components/PromoBigBanner.svelte';
	import PromoSmallBanner from '$lib/components/PromoSmallBanner.svelte';
	import PromoSticky from '$lib/components/PromoSticky.svelte';	
	import { listHome } from '$lib/store/home';
	import { fetchMoviesLastest, fetchMoviesComedy, fetchMoviesAnimation, fetchMoviesHorror } from '$lib/store/home';
	import { fetchGenres } from '$lib/store/home';
	import MovieGrid from '$lib/components/MovieGrid.svelte';

	// $effect(() => {
	// 	Promise.all([
	// 		fetchMoviesLastest(),
	// 		fetchMoviesComedy(),
	// 		fetchMoviesAnimation(),
	// 		fetchMoviesHorror(),
	// 		fetchGenres()
	// 	]).catch((error) => {
	// 		console.error('Error fetching data:', error);
	// 	});
	// });

	const { data } = $props();
	const { lastest = {}, comedy = {}, animation = {}, horror = {}, genres = [] } = data ?? {};

</script>

<div>
	<PromoBigBanner />

	<PromoSmallBanner group="B" />

	<!-- <MovieGrid title="หนังอัปเดตล่าสุด" movies={[]} /> -->

	<!-- Movie Grid - หนังอัปเดตล่าสุด -->
	<!-- <MovieGrid title="หนังอัปเดตล่าสุด" movies={$listHome.moviesLatest.data} category="action" /> -->
	<MovieGrid title="หนังอัปเดตล่าสุด" movies={lastest.data} category="action" />

	<!-- Categories Banner -->
	<CategoriesBanner />

	<!-- Small Promo Banner -->
	<PromoSmallBanner group="C" />

	<!-- Movie Grid - หนังตลกล่าสุด -->
	<MovieGrid title="หนังตลกล่าสุด" movies={comedy.data} category="comedy" />

	<!-- Small Promo Banner -->
	<PromoSmallBanner group="D" />

	<!-- Movie Grid - หนังแอนนิเมชั่นล่าสุด -->
	<MovieGrid title="หนังแอนนิเมชั่นล่าสุด" movies={animation.data} category="animation" />

	<!-- Movie Grid - หนังสยองขวัญล่าสุด -->
	<MovieGrid title="หนังสยองขวัญล่าสุด" movies={horror.data} category="horror" />


</div>

<!-- Sticky Promo (bottom) -->
<PromoSticky />

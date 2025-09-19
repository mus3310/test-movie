<script lang="ts">
	import { page } from '$app/state';
	import { browser } from '$app/environment';
	import MovieDetail from '$lib/components/MovieDetail.svelte';
	import PlayerMovie from '$lib/components/PlayerMovie.svelte';
	import small_banner from '$lib/images/small-banner.png';
	import { config } from '$lib/config';
	import { fetchMoviesDetail } from '$lib/store/detail';
	import type { MovieDataDetail } from '$lib/types/moviesDetail';
	import MayLike from '$lib/components/MayLike.svelte';
	import PromoSmallBanner from '$lib/components/PromoSmallBanner.svelte';
	let dataMovieDetail = $state<MovieDataDetail | undefined>();
	let currentPath = $state(page.url.pathname);
	let selectedEpisode = $state('');

	$effect(() => {
		const fetchData = async () => {
			if (!browser) return;

			try {
				const response = await fetchMoviesDetail(currentPath);
				console.log('API Response:', response);

				// Check if response has data property, otherwise use the response directly
				if (response && typeof response === 'object') {
					dataMovieDetail = response.data || response;
					selectedEpisode = dataMovieDetail?.seasons[0].episodes[0].id || '';
				} else {
					console.warn('Invalid API response:', response);
					dataMovieDetail = undefined;
				}

				console.log('dataMovieDetail:', dataMovieDetail);
				console.log('for vd:', dataMovieDetail?.seasons[0].episodes[0].id);
			} catch (error) {
				console.error('Error loading movie details:', error);
				dataMovieDetail = undefined;
			}
		};
		fetchData();
	});
</script>

<PromoSmallBanner group="X" />
<div class="mt-2 flex w-full items-center gap-2">
	<div class="secondary-color-20 h-8 w-[80px] rounded-2xl p-2 text-sm text-white">
		<a href="/" class="p-[6px]">ย้อนกลับ</a>
	</div>
	<div class="">
		<h1 class="p-2 text-left text-2xl font-bold text-white">
			{dataMovieDetail?.name || 'กำลังโหลด...'}
		</h1>
	</div>
</div>
<!-- Video Player Section -->
<div id="video-player-section" class="mb-4">
	<!-- <pre class="text-white">{config.movieStreamUrl}/series/{selectedEpisode}/master.m3u8</pre> -->
	<!-- PlayerMovie Component -->
	<PlayerMovie
		movieDetail={dataMovieDetail}
		videoSources={[
			{
				src: `${config.movieStreamUrl}/series/${selectedEpisode}/master.m3u8`,
				type: 'application/x-mpegURL'
			}
		]}
		posterUrl={dataMovieDetail?.backdrop_path}
	/>
</div>

<PromoSmallBanner group="Y" />
<!-- <pre class="text-white"> selectedEpisode ===>{selectedEpisode}</pre> -->
{#if dataMovieDetail}
	<div>
		<MovieDetail movieDetailX={dataMovieDetail} bind:selectedEpisode />
	</div>
	<MayLike movies={dataMovieDetail.genres} movieType="movies" />
{/if}

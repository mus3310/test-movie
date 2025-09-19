<script lang="ts">
	import { page } from '$app/state';
	import { browser } from '$app/environment';
	import MovieDetail from '$lib/components/MovieDetail.svelte';
	import PlayerMovie from '$lib/components/PlayerMovie.svelte';
	import { config } from '$lib/config';
	import { fetchMoviesDetail } from '$lib/store/detail';
	import PromoSmallBanner from '$lib/components/PromoSmallBanner.svelte';
	import type { MovieDataDetail } from '$lib/types/moviesDetail';
	import MayLike from '$lib/components/MayLike.svelte';

	let dataMovieDetail: MovieDataDetail | null = $state(null);
	const currentPath = $derived(page.url.pathname);

	$effect(() => {
		const fetchData = async () => {
			if (!browser) return;

			try {
				const response = await fetchMoviesDetail(currentPath);
				console.log('API Response:', response);

				// Check if response has data property, otherwise use the response directly
				if (response && typeof response === 'object') {
					dataMovieDetail = response.data || response;
				} else {
					console.warn('Invalid API response:', response);
					dataMovieDetail = null;
				}

				console.log('dataMovieDetail:', dataMovieDetail);
			} catch (error) {
				console.error('Error loading movie details:', error);
				dataMovieDetail = null;
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
<div class="mb-4">
	<!-- PlayerMovie Component -->
	<PlayerMovie
		movieDetail={dataMovieDetail}
		videoSources={[
			{
				// src: `http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8`,
				src: `${config.movieStreamUrl}${currentPath}/master.m3u8`,
				type: 'application/x-mpegURL'
			}
		]}
		posterUrl={dataMovieDetail?.backdrop_path}
		adsEnabled={false}
		adsTagUrl="https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
	/>
</div>

<PromoSmallBanner group="Y" />
{#if dataMovieDetail}
	<div>
		<MovieDetail movieDetailX={dataMovieDetail} />
	</div>
	<MayLike movies={dataMovieDetail.genres} movieType="movies" />
{/if}
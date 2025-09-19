<script lang="ts">
	import Banner1 from '$lib/images/Banner1280x220.png';
	import Banner2 from '$lib/images/Banner1280x220.png';

	let arrayBanner = [
		{
			id: '1',
      position: 'A1',
      url: 'https://www.google.com',
			image: Banner1,
			alt: 'BigBanner1'
		},
		{
			id: '2',
      position: 'A2',
      url: 'https://www.google.com',
			image: Banner2,
			alt: 'BigBanner2'
		}
	];
	let filteredBanners = $derived(arrayBanner.filter((banner) => banner.position.startsWith('A')));
</script>

<div class="frame1-frame1948755225 mt-3">
	<!-- Big Banner -->
	{#each filteredBanners as banner}
		<a href={banner.url} target="_blank">
			<img src={banner.image} alt={banner.alt} class="big-banner" />
		</a>
	{/each}
</div>

<style>
	.big-banner {
		width: 100%;
	}
</style>

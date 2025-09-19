<script lang="ts">
	import SmallBanner1 from '$lib/images/Banner634x107.png';
	interface Props {
		group?: string;
	}

	let { group = 'B' }: Props = $props();
	let urlImage = (group: string, n: number) =>
  `https://placehold.co/634x107/123456/FFF?text=Banner ${group}${n}%0A634x107`;
	// %0A -> \n

	const groupLengths: Record<string, number> = {
		B: 4,
		C: 4,
		D: 4,
		X: 2, // ✅ group X มีแค่ 2
		Y: 2 // ✅ group Y มีแค่ 2
	};

	let arrayBannerSmallLoop = Object.entries(groupLengths).flatMap(([group, len]) =>
		Array.from({ length: len }, (_, i) => ({
			id: `${group}${i + 1}`,
			position: `${group}${i + 1}`,
			url: 'https://www.google.com',
			image: urlImage(group, i + 1),
			alt: `SmallBanner ${group}${i + 1}`
		}))
	);

	// Dynamic data from API
	let arrayBannerSmall = [
		// group B
		{
			id: '1',
			position: 'B1',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '2',
			position: 'B2',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '3',
			position: 'B3',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '4',
			position: 'B4',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		// group C
		{
			id: '1',
			position: 'C1',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '2',
			position: 'C2',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '3',
			position: 'C3',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '4',
			position: 'C4',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		// group D
		{
			id: '1',
			position: 'D1',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '2',
			position: 'D2',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '3',
			position: 'D3',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '4',
			position: 'D4',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		// detail page
		// group X
		{
			id: '1',
			position: 'X1',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '1',
			position: 'X2',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		// group Y
		{
			id: '1',
			position: 'Y1',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		},
		{
			id: '1',
			position: 'Y2',
			url: 'https://www.google.com',
			image: SmallBanner1,
			alt: 'SmallBanner1'
		}
	];

	// Filter banners based on group prop
	let filteredBanners = $derived(
		arrayBannerSmall.filter((banner) => banner.position.startsWith(group))
	);

	// Sort banners by position for proper grid layout
	let sortedBanners = $derived(
		filteredBanners.sort((a, b) => {
			const posA = a.position.slice(1); // Get number part (1, 2, 3, 4)
			const posB = b.position.slice(1);
			return parseInt(posA) - parseInt(posB);
		})
	);
</script>

<div class="frame1-frame1948755225 mt-3">
	<!-- Small Banner Grid 2x2 -->
	<div class="grid grid-cols-2 gap-2">
		<!-- Top row: Position 1 and 2 (B1, B2) -->
		{#if sortedBanners[0]}
			<a href={sortedBanners[0].url} target="_blank">
				<img src={sortedBanners[0].image} alt={sortedBanners[0].position} class="w-full rounded-lg" />
			</a>
		{/if}
		{#if sortedBanners[1]}
			<a href={sortedBanners[1].url} target="_blank">
				<img src={sortedBanners[1].image} alt={sortedBanners[1].position} class="w-full rounded-lg" />
			</a>
		{/if}

		<!-- Bottom row: Position 3 and 4 (B3, B4) -->
		{#if sortedBanners[2]}
			<a href={sortedBanners[2].url} target="_blank">
				<img src={sortedBanners[2].image} alt={sortedBanners[2].position} class="w-full rounded-lg" />
			</a>
		{/if}
		{#if sortedBanners[3]}
			<a href={sortedBanners[3].url} target="_blank">
				<img src={sortedBanners[3].image} alt={sortedBanners[3].position} class="w-full rounded-lg" />
			</a>
		{/if}
	</div>
</div>

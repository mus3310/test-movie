<script lang="ts">
	import rightPromo from '$lib/images/Banner240x460.png'

    // Dynamic data from API
    let arrayBanner = [
        {
            id: '1',
            position: 'R1',
            url: 'https://www.google.com',
            image: rightPromo,
            alt: 'rightPromo1'
        },
        {
            id: '2',
            position: 'R2',
            url: 'https://www.google.com',
            image: rightPromo,
            alt: 'rightPromo2'
        },
        {
            id: '3',
            position: 'R3',
            url: 'https://www.google.com',
            image: rightPromo,
            alt: 'rightPromo3'
        },
        {
            id: '4',
            position: 'R4',
            url: 'https://www.google.com',
            image: rightPromo,
            alt: 'rightPromo4'
        },
        {
            id: '5',
            position: 'R5',
            url: 'https://www.google.com',
            image: rightPromo,
            alt: 'rightPromo5'
        }
    ];
    let filteredBanners = $derived(arrayBanner.filter((banner) => banner.position.startsWith('R')));
</script>
<!-- Right Sidebar Promo Banner -->
<div class="right-sidebar-promo h-full">
    {#each filteredBanners as banner}
        <a href={banner.url} target="_blank">
            <img src={banner.image} alt={banner.alt} class="frame1-image8" />
        </a>
    {/each}
</div>

<style>
.frame1-image8 {
	width: 240px;
	/* height: 460px; */
}
</style>
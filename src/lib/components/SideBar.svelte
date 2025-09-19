<script lang="ts">
	import ads_sidebar from '$lib/images/Banner216x320.png';
	import { goto, invalidateAll } from '$app/navigation';
    import { page } from '$app/state';

	// Dynamic Ads from API
	const ads = [
		{
			id: '1',
			position: 'L1',
			url: 'https://www.google.com',
			image: ads_sidebar,
			alt: 'Ads1'
		}
	];

    // Dynamic categories configuration
    const categories = [
        { slug: 'action', name: 'Action', class: 'frame1-frame1948755285', textClass: 'frame1-text76' },
        { slug: 'animation', name: 'Animation', class: 'frame1-frame1948755289', textClass: 'frame1-text76' },
        { slug: 'comedy', name: 'Comedy', class: 'frame1-frame1948755290', textClass: 'frame1-text76' },
        { slug: 'documentary', name: 'Documentary', class: 'frame1-frame1948755291', textClass: 'frame1-text76' },
        { slug: 'music', name: 'Musical', class: 'frame1-frame1948755292', textClass: 'frame1-text76' },
        { slug: 'drama', name: 'Drama', class: 'frame1-frame1948755286', textClass: 'frame1-text76' },
        { slug: 'kids', name: 'Kids', class: 'frame1-frame1948755287', textClass: 'frame1-text76' },
        { slug: 'horror', name: 'Horror', class: 'frame1-frame1948755288', textClass: 'frame1-text76' },
        { slug: 'prons', name: 'Prons', class: 'frame1-frame1948755288', textClass: 'frame1-text76' },
    ];

    const currentPath = $derived(page.url.pathname);
    
    // Function to check if category is active
    function isActive(categorySlug: string): boolean {
        return currentPath.includes(`/categorie/${categorySlug}`);
    }

	async function navigateTo(url: string) {
        console.log('navigateTo', url);
        await goto(url, { replaceState: false, invalidateAll: true });
		await invalidateAll(); // Force refresh of all data
		
		window.location.reload();
	}
	let filteredBanners = $derived(ads.filter((banner) => banner.position.startsWith('L')));
</script>

<div class="frame1-floating-sidebar">
	<span class="frame1-text75">Categories</span>
	<div class="frame1-frame1948755284">
		{#each categories as category}
			<button 
				class="cursor-pointer {category.slug} {category.class} {isActive(category.slug) ? 'selected' : ''}" 
				onclick={() => navigateTo(`/categorie/${category.slug}`)}
			>
				<span class="{category.textClass} {isActive(category.slug) ? 'selected-text' : ''}">{category.name}</span>
			</button>
		{/each}
		
		<!-- <a class="frame1-frame1948755293">
			<span class="frame1-text76">KSeries</span>
		</a>
		<a class="frame1-frame1948755294">
			<span class="frame1-text76">TSeries</span>
		</a> -->
        
		<!-- <a class="w-1/2 frame1-frame1948755285 frame1-text80" href={`/categorie/action`}>บู๊</a>
		<a class="w-1/2 frame1-frame1948755286 frame1-text77" href={`/categorie/adventure`}>ผจญภัย</a>
		<a class="w-1/2 frame1-frame1948755285 frame1-text80" href={`/categorie/animation`}>แอนนิเมชั่น</a>
		<a class="w-1/2 frame1-frame1948755285 frame1-text80" href={`/categorie/comedy`}>ตลก</a>
		<a class="w-1/2 frame1-frame1948755285 frame1-text80" href={`/categorie/crime`}>อาชญากรรม</a>
		<a class="w-50 frame1-frame1948755285 frame1-text80" href={`/categorie/documentary`}>สารคดี</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/drama`}>ดราม่า</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/family`}>ครอบครัว</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/fantasy`}>จินตนาการ</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/history`}>ประวัติศาสตร์</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/horror`}>สยองขวัญ</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/music`}>ดนตรี</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/mystery`}>ลึกลับ</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/romance`}>โรแมนติก</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/sci_fi`}>นิยายวิทยาศาสตร์</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/tv`}>ภาพยนตร์โทรทัศน์</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/thriller`}>ระทึกขวัญ</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/war`}>สงคราม</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/western`}>ตะวันตก</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/action_adv`}>ผจญภัย</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/kids`}>สำหรับเด็ก</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/news`}>ข่าว</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/reality`}>เรียลลิตี้</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/sci_fi2`}>จินตนาการแนววิทยาศาสตร์</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/drama_tv`}>ละคร</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/dialogue`}>บทสนทนา</a>
		<a class="frame1-frame1948755285 frame1-text80" href={`/categorie/war_po`}>สงครามและการเมือง</a> -->
	</div>
	{#each filteredBanners as ad}
		<a href={ad.url} target="_blank">
			<img src={ad.image} alt={ad.alt} class="frame1-image310" />
		</a>
	{/each}
</div>

<style>
.frame1-frame1948755290 {
	gap: 10px;
	display: flex;
	padding: 8px 12px;
	align-items: center;
	border-radius: 12px;
	justify-content: center;
	background-color: rgba(88, 173, 207, 0.1);
}
:global(.selected) {
    background: linear-gradient(180deg, rgba(133, 88, 207, 1) 0%, rgba(133, 88, 207, 1) 100%);
    border-color: rgba(133, 87, 206, 1);
    border-style: solid;
    border-width: 3px 0 0;
    justify-content: center;
}
:global(.selected-text) {
    color: rgba(238, 238, 238, 1);
    font-weight: 700;
}
.frame1-frame1948755286 {
	gap: 10px;	
	display: flex;
	padding: 8px 12px;
	align-items: center;
	flex-shrink: 0;
	border-radius: 12px;
	justify-content: center;
    background-color: rgba(88, 173, 207, 0.1);
}
.frame1-text77 {
	color: rgba(238, 238, 238, 0.6);
	height: auto;
	font-size: 14px;
	font-style: Bold;
	text-align: left;
	font-family: Inter;
	line-height: normal;
	font-stretch: normal;
	text-decoration: none;
}
</style>


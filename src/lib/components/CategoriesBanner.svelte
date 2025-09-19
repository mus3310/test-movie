<script lang="ts">
	import { goto, invalidateAll } from '$app/navigation';

	async function navigateTo(url: string) {
        console.log('navigateTo', url);
        await goto(url, { replaceState: false, invalidateAll: true });
		await invalidateAll(); // Force refresh of all data
		
		window.location.reload();
	}
</script>

<!-- Categories Banner -->
<div class="frame1-frame1948755223">
    <div class="frame1-frame343">
        <button class="frame1-actionmovie cursor-pointer" onclick={() => navigateTo(`/categorie/action`)}>
            <span class="frame1-text27">Action</span>
        </button>
        <button class="frame1-dramamovie cursor-pointer" onclick={() => navigateTo(`/categorie/drama`)}>
            <span class="frame1-text27">Drama</span>
        </button>
        <button class="frame1-trillermovie cursor-pointer" onclick={() => navigateTo(`/categorie/thriller`)}>
            <span class="frame1-text27">Triller</span>
        </button>
        <button class="frame1-horrormovie cursor-pointer" onclick={() => navigateTo(`/categorie/horror`)}>
            <span class="frame1-text27">Horror</span>
        </button>
        <button class="frame1-animationmovie cursor-pointer" onclick={() => navigateTo(`/categorie/animation`)}>
            <span class="frame1-text27">Animation</span>
        </button>
        <button class="frame1-comedymovie cursor-pointer" onclick={() => navigateTo(`/categorie/comedy`)}>
            <span class="frame1-text27">Comedy</span>
        </button>
        <button class="frame1-documentarymovie cursor-pointer" onclick={() => navigateTo(`/categorie/documentary`)}>
            <span class="frame1-text27">Documentary</span>
        </button>
        <button class="frame1-musicalmovie cursor-pointer" onclick={() => navigateTo(`/categorie/music`)}>
            <span class="frame1-text27">Musical</span>
        </button>
        <!-- <button class="frame1-koreamovie cursor-pointer" onclick={() => navigateTo(`/categorie/kseries`)}>
            <span class="frame1-text27">KSeries</span>
        </button> -->
        <button class="frame1-thaiseriesmovie cursor-pointer" onclick={() => navigateTo(`/series`)}>
            <span class="frame1-text27">Tseries</span>
        </button>
        <button class="frame1-japanidol cursor-pointer" onclick={() => navigateTo(`/categorie/prons`)}>
            <span class="frame1-text27">AV 18+</span>
        </button>
    </div>
</div>

<style>
	.frame1-text27 {
	color: rgba(238, 238, 238, 1);
	height: auto;
	font-size: 14px;
	font-style: Bold;
	text-align: left;
	font-family: Inter;
	font-weight: 700;
	line-height: normal;
	font-stretch: normal;
	text-decoration: none;
}
</style>
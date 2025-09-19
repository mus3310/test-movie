<script lang="ts">
	import '../app.css';
	import Header from '$lib/components/Header.svelte';
	import SideBar from '$lib/components/SideBar.svelte';
	import SideBarPromoBanner from '$lib/components/SideBarPromoBanner.svelte';
	import SearchBar from '$lib/components/SearchBar.svelte';
	import Footer from '$lib/components/Footer.svelte';
	let { children } = $props();
</script>

<svelte:head>
	<title>My Movies-HD | หนังออนไลน์</title>
	<meta name="description" content="ดูหนังออนไลน์ฟรี หนังใหม่ หนังฮิต" />
</svelte:head>

<div>
	<Header />
	<div class="mx-auto flex w-[1390px] gap-2">
		<div class="mt-[100px] w-[200px]">
			<SideBar />
		</div>
		<div class="w-full">
			<SearchBar searchKeyword={''} />
			{@render children?.()}
		</div>
		<div class="mt-[100px] w-[200px]">
			<SideBarPromoBanner />
		</div>
	</div>
	<div class="mx-auto mt-[50px] w-[1390px]">
		<Footer />
	</div>
</div>

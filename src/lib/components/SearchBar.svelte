<script lang="ts">
	import { page } from '$app/state';
	import search_icon from '$lib/images/vectori011-kkuo.svg'
	let { searchKeyword } = $props();
	let keyword = $state(page.url.searchParams.get('keyword') || '');

	const categories = [
        { slug: '', name: 'เลือกหมวดหมู่หนัง'},
        { slug: 'action', name: 'Action'},
        { slug: 'animation', name: 'Animation'},
        { slug: 'comedy', name: 'Comedy'},
        { slug: 'documentary', name: 'Documentary'},
        { slug: 'music', name: 'Musical'},
        { slug: 'drama', name: 'Drama'},
        { slug: 'kids', name: 'Kids'},
        { slug: 'horror', name: 'Horror'},
        { slug: 'prons', name: 'Prons'},
    ];

	function onSearch(e: Event) {
		e.preventDefault();
		window.location.href = `/search_movie?keyword=${encodeURIComponent(keyword.trim())}`;
	}

	function onChangeCategory(e: Event) {
		const category = (e.target as HTMLSelectElement).value;
		window.location.href = `/categorie/${category}`;
	}
</script>
<div class="flex justify-between my-2 gap-2">
	<div class="frame1-frame329">
		<div class="frame1-frame3331 p-4">
			<select class="frame1-text15 w-full" name="" id="" onchange={onChangeCategory}>
				{#each categories as category}
					<option value={category.slug} placeholder='Select category'>{category.name}</option>
				{/each}
			</select>
		</div>
	</div>
	<div class="frame1-frame1948755229">
		<form onsubmit={onSearch} class="frame1-frame3332">
			<input name="keyword" bind:value={keyword} class="frame1-text15 w-full" placeholder="Search movies and series" >
			<button type="submit" class="frame1-mingcute2 cursor-pointer">
				<div class="frame1-group2">
					<img src={search_icon} alt="VectorI011" class="frame1-vector2" />
				</div>
			</button>
		</form>
	</div>
</div>

<style>
	 .frame1-frame329 {
	width: 100%;
	border-color: rgba(133, 88, 207, 0.4000000059604645);
	border-style: solid;
	border-width: 1px;
	border-radius: 28px;

	background-color: rgba(133, 88, 207, 0.10000000149011612);
  }
  .frame1-frame3331 {
	display: flex;
	/* align-self: stretch; */
	align-items: baseline;
	flex-shrink: 0;
  }
    .frame1-frame1948755229 {
	gap: 18px;
	width: 80%;
	/* max-width: 1099px; */
	display: flex;
	padding: 16px;
	flex-grow: 1;
	align-items: center;
	flex-shrink: 0;
	border-color: rgba(133, 88, 207, 0.4000000059604645);
	border-style: solid;
	border-width: 1px;
	border-radius: 28px;
	flex-direction: column;
	background-color: rgba(133, 88, 207, 0.10000000149011612);
  }
</style>
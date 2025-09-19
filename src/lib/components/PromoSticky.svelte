<script lang="ts">
	import image3i023 from '$lib/images/Banner216x320.png';
	import vectori023 from '$lib/images/vectori023-ckva.svg';
	let isShow = $state(true);
	let arrayAds = $state([
		{
			id: '1',
			url: 'https://www.google.com',
			position: 'Z1',
			image: image3i023,
			alt: 'image3I023'
		}
	]);
	function toggleShow() {
		isShow = !isShow;
	}
	let filteredBanners = $derived(arrayAds.filter((banner) => banner.position.startsWith('Z')));
</script>

{#if isShow}
	<div class="frame1-floatingsticky">
		<a class="frame1-image-button" href={filteredBanners[0].url} target="_blank">
			<img
				src={filteredBanners[0].image}
				alt={filteredBanners[0].position}
				class="frame1-image311"
			/>
		</a>
		<button class="frame1-close cursor-pointer" onclick={toggleShow}>
			<div class="frame1-mingcute3">
				<div class="frame1-group3">
					<img src={vectori023} alt="VectorI023" class="frame1-vector3" />
				</div>
			</div>
		</button>
	</div>
{/if}

<style>
	.frame1-floatingsticky {
		width: 200px;
		height: 312px;
		z-index: 4;
		position: fixed;
		top: 50%;
		right: 80px;
		transform: translateY(-50%);
	}
	.frame1-image-button {
		position: relative;
		border: none;
		background: transparent;
		padding: 0;
		cursor: pointer;
		width: 190px;
		height: 300px;
		top: 12px;
	}
	.frame1-image311 {
		width: 100%;
		height: 100%;
		/* object-fit: cover; */
	}
	.frame1-close {
		gap: 10px;
		top: 0px;
		left: 178px;
		width: 24px;
		height: 24px;
		display: flex;
		padding: 4px;
		position: absolute;
		box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);
		align-items: center;
		flex-shrink: 0;
		border-color: rgba(255, 255, 255, 1);
		border-style: solid;
		border-width: 2px;
		border-radius: 12px;
		background-color: rgba(0, 0, 0, 1);
	}
	.frame1-mingcute3 {
		width: 16px;
		height: 16px;
		display: flex;
		overflow: hidden;
		position: relative;
		align-items: flex-start;
		flex-shrink: 0;
	}
	.frame1-group3 {
		top: 2.7450437545776367px;
		left: 2.7450554370880127px;
		width: 10.497932434082031px;
		height: 13.130955696105957px;
		display: flex;
		position: absolute;
		align-items: flex-start;
		flex-shrink: 1;
	}
	.frame1-vector3 {
		top: 0px;
		left: -1px;
		width: 10px;
		height: 11px;
		position: absolute;
	}
</style>

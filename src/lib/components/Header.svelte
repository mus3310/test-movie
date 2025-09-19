<script lang="ts">
	import myLogo from '$lib/images/mymovie-hd.webp';
	import { page } from '$app/state';

	function isActive(path: string) {
    return page.url.pathname === path;
  }
</script>

<header class="mx-auto w-[1000px] p-2">
	<div class="flex justify-between items-center">
		<a href="/">
			<img src={myLogo} alt="myLogo" class="my-logo" />
		</a>
		<div class="frame1-frame4">
			<!-- หน้าแรก -->
			<div class={isActive('/') ? 'frame1-menu1' : 'frame1-menu2'}>
			  <a href="/" class={isActive('/') ? 'frame1-text10' : 'frame1-text11'}>หน้าแรก</a>
			</div>
	  
			<!-- หนังทั้งหมด -->
			<div class={isActive('/movies') ? 'frame1-menu1' : 'frame1-menu2'}>
			  <a href="/movies" class={isActive('/movies') ? 'frame1-text10' : 'frame1-text11'}>หนังล่าสุด</a>
			</div>
	  
			<!-- Series -->
			<div class={isActive('/series') ? 'frame1-menu1' : 'frame1-menu2'}>
			  <a href="/series" class={isActive('/series') ? 'frame1-text10' : 'frame1-text11'}>Series</a>
			</div>
	  
			<!-- Porns -->
			<div class={isActive('/porns') ? 'frame1-menu1' : 'frame1-menu2'}>
			  <a href="/porns" class={isActive('/porns') ? 'frame1-text10' : 'frame1-text11'}>Porns</a>
			</div>
		  </div>
	</div>
</header>

<style>
.frame1-menu1 {
	gap: 10px;
	display: flex;
	padding: 12px;
	align-items: center;
	border-color: rgba(133, 87, 206, 1);
	border-style: solid;
	border-width: 0 0 3px;
	justify-content: center;
}
.frame1-text10 {
	color: rgba(238, 238, 238, 1);
	height: auto;
	font-size: 16px;
	font-style: Regular;
	text-align: left;
	font-family: Inter;
	font-weight: 400;
	line-height: normal;
	font-stretch: normal;
	text-decoration: none;
}
.frame1-menu2 {
	gap: 10px;
	display: flex;
	padding: 12px;
	align-items: center;
	justify-content: center;
}

.frame1-text11 {
	color: rgba(238, 238, 238, 0.6);
	height: auto;
	font-size: 16px;
	font-style: Regular;
	text-align: left;
	font-family: Inter;
	font-weight: 400;
	line-height: normal;
	font-stretch: normal;
	text-decoration: none;
}
</style>
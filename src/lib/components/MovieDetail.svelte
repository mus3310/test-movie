<script lang="ts">
	// @ts-nocheck
	import Icon from '@iconify/svelte';
	import { inlineSvg } from '@svelte-put/inline-svg';
	import continue_movie from '$lib/images/continue-movie.png';
	import user_profile from '$lib/images/user-profile.png';

	import type { MovieDetail } from '$lib/types/moviesDetail';

	// Props
	let { movieDetailX, selectedEpisode= $bindable()}: { movieDetailX?: MovieDetail, selectedEpisode?: string } = $props();

	// let languages = ['Thai', 'Eng'];
	let selectedSeason = $state(1);
	// let selectedEpisode = $state(null);

	function handleSelectEpisode(episode: any) {
		console.log('handleSelectEpisode');
		console.log('episode', episode);
		selectedEpisode = episode.id;
		
		// Scroll to video player section
		const videoPlayerSection = document.getElementById('video-player-section');
		if (videoPlayerSection) {
			videoPlayerSection.scrollIntoView({ 
				behavior: 'smooth', 
				block: 'start' 
			});
		}
	}
</script>

<!-- <pre class="text-white">{ JSON.stringify(movieDetailX?.poster_path) }</pre> -->
<!-- <pre>{movieDetailX?.poster_path}</pre> -->
<div class="flex gap-6 bg-[#0f0f1a] py-2 text-white">
	<div class={movieDetailX?.seasons && movieDetailX?.seasons.length > 0 ? 'w-4/5' : 'w-full'}>
		<div class="flex">
			<div class="mr-2">
				<img src={movieDetailX?.poster_path || movieDetailX?.image_url} alt={movieDetailX?.name} class="frame1-image11" />
			</div>
			<div class="w-full max-w-[450px] gap-4">
				<h1 class="text-3xl font-bold">{movieDetailX?.name}</h1>
				<div class="flex items-center gap-2">
					<span>Release</span>
					{#if movieDetailX?.seasons && movieDetailX?.seasons.length > 0}
						<span
							>{movieDetailX?.first_release_date
								? new Date(movieDetailX?.first_release_date).toLocaleDateString('en-GB', {
										day: 'numeric',
										month: 'short',
										year: 'numeric'
									})
								: 'ไม่ระบุ'}</span
						>
					{:else}
						<span
							>{movieDetailX?.release_date
								? new Date(movieDetailX?.release_date).toLocaleDateString('en-GB', {
										day: 'numeric',
										month: 'short',
										year: 'numeric'
									})
								: 'ไม่ระบุ'}</span
						>
					{/if}
				</div>
				<!-- <p><span class="font-semibold">Release xxxx:</span> 31 Dec 2025</p> -->

				<!-- Genres -->
				<div class="flex items-center gap-2">
					<span>Genres</span>
					<div class="flex flex-wrap gap-2">
						{#each movieDetailX?.genres as g}
							<span class="rounded-full bg-[#1a1a2e] px-3 py-1 text-sm">{g}</span>
						{/each}
					</div>
				</div>

				<!-- Language -->
				<!-- <div class="flex items-center gap-2">
					<span>Language</span>
					<div class="flex flex-wrap gap-2 mt-2">
						{#each languages as l}
							<span class="rounded-full bg-[#1a1a2e] px-3 py-1 text-sm">{l}</span>
						{/each}
					</div>
				</div>				 -->

				<!-- Description -->
				<p class="mt-3 text-gray-300">
					{movieDetailX?.overview || movieDetailX?.detail}
				</p>
			</div>
			<!-- Buttons -->
			<div class="mt-4 flex flex-col gap-3">
				<button class="rounded-lg bg-[#ef155a] px-4 py-2">ลิงก์สำรอง 1</button>
				<button class="rounded-lg bg-[#1a1a2e] px-4 py-2">ลิงก์สำรอง 2</button>
				<button class="rounded-lg bg-[#1a1a2e] px-4 py-2">ลิงก์สำรอง 1 เสียงไทย</button>
				<button class="rounded-lg bg-[#1a1a2e] px-4 py-2">ลิงก์สำรอง 2 เสียงไทย</button>
			</div>
		</div>
		<!-- Comment Section -->
		<div class="mt-2 rounded-xl bg-[#1a1a2e] p-4 text-white">
			<h2 class="flex items-center gap-2 text-lg font-semibold">💬 แสดงความคิดเห็น</h2>
			<div class="mt-3 flex items-start gap-3">
				<img src={user_profile} alt="user" class="h-10 w-10 rounded-full" />
				<textarea
					placeholder="แสดงความคิดเห็นที่นี่"
					class="w-full rounded-lg border border-gray-700 bg-transparent p-2 focus:ring-1 focus:ring-purple-500 focus:outline-none"
				></textarea>
			</div>
			<div class="mt-3 flex items-center justify-between">
				<input
					type="text"
					placeholder="ชื่อผู้โพสต์"
					class="rounded-lg border border-gray-700 bg-transparent px-2 py-1 text-sm"
				/>
				<button class="rounded-lg bg-purple-600 px-4 py-2 hover:bg-purple-700">โพสต์</button>
			</div>
		</div>
		<div class="frame334-frame19487552722">
			<div class="frame334-frame19487552723">
				<span class="frame334-text36">
					<span class="frame334-text37">💬 88</span>
					<span> ความคิดเห็น</span>
				</span>
			</div>
			<!-- วนความคิดเห็น -->
			<div class="frame334-frame19487552753">
				<img src={user_profile} alt="userprofileI047" class="frame334-userprofile2" />
				<div class="frame334-frame19487552754">
					<div class="frame334-frame19487552771">
						<span class="frame334-text39">ชื่อผู้โพสต์</span>
						<span class="frame334-text40"> 30 DEC 2025 | 23:59 </span>
					</div>
					<div class="frame334-frame19487552732">
						<span class="frame334-text41">
							Lorem ipsum dolor sit amet consectetur. Amet praesent elit non id mi suspendisse fames
							leo eget. Lacus at tincidunt in nullam elit mi. Velit nec sit sed lacus eu curabitur.
							Quam venenatis facilisi morbi tortor proin. Lorem amet mauris sollicitudin rhoncus.
							Nec libero quis scelerisque eget nibh enim ac.
						</span>
					</div>
					<div class="frame334-frame19487552801">
						<div class="frame334-frame19487552791">
							<Icon icon="lucide:thumbs-up" />
							<span class="frame334-text42">88</span>
							<span class="frame334-text43">Like</span>
						</div>
						<div class="frame334-frame19487552811">
							<span class="frame334-text44">Reply</span>
						</div>
					</div>
				</div>
			</div>
			<div class="frame334-frame19487552763">
				<img src={user_profile} alt="userprofileI048" class="frame334-userprofile4" />
				<div class="frame334-frame19487552754">
					<div class="frame334-frame19487552772">
						<span class="frame334-text49">ชื่อผู้โพสต์</span>
						<span class="frame334-text50"> 30 DEC 2025 | 23:59 </span>
					</div>
					<div class="frame334-frame19487552734">
						<span class="frame334-text51">
							Lorem ipsum dolor sit amet consectetur. Amet praesent elit non id mi suspendisse fames
							leo eget. Lacus at tincidunt in nullam elit mi. Velit nec sit sed lacus eu curabitur.
							Quam venenatis facilisi morbi tortor proin. Lorem amet mauris sollicitudin rhoncus.
							Nec libero quis scelerisque eget nibh enim ac.
						</span>
					</div>
					<div class="frame334-frame19487552802">
						<div class="frame334-frame19487552792">
							<Icon icon="lucide:thumbs-up" />
							<span class="frame334-text52">89</span>
							<span class="frame334-text53">Liked</span>
						</div>
						<div class="frame334-frame19487552812">
							<span class="frame334-text54">Reply</span>
						</div>
					</div>
				</div>
			</div>
			<div class="frame334-frame19487552773">
				<img src={user_profile} alt="userprofileI048" class="frame334-userprofile5" />
				<div class="frame334-frame19487552754">
					<div class="frame334-frame19487552774">
						<span class="frame334-text55">ชื่อผู้โพสต์</span>
						<span class="frame334-text56"> 30 DEC 2025 | 23:59 </span>
					</div>
					<div class="frame334-frame19487552735">
						<span class="frame334-text57">
							Lorem ipsum dolor sit amet consectetur. Amet praesent elit non id mi suspendisse fames
							leo eget. Lacus at tincidunt in nullam elit mi. Velit nec sit sed lacus eu curabitur.
							Quam venenatis facilisi morbi tortor proin. Lorem amet mauris sollicitudin rhoncus.
							Nec libero quis scelerisque eget nibh enim ac.
						</span>
					</div>
					<div class="frame334-frame19487552803">
						<div class="frame334-frame19487552793">
							<Icon icon="lucide:thumbs-up" />
							<span class="frame334-text58">88</span>
							<span class="frame334-text59">Like</span>
						</div>
						<div class="frame334-frame19487552813">
							<span class="frame334-text60">Reply</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Right Section -->
	{#if movieDetailX?.seasons && movieDetailX?.seasons.length > 0}
		<div class="w-1/5 rounded-xl bg-[#1a1a2e] p-2">
			<div class="mb-3 font-semibold">Others episode</div>
			<select
				bind:value={selectedSeason}
				class="mb-2 w-[180px] rounded-md border border-gray-600 bg-[#1a1a2e] p-2 text-white"
			>
				{#each movieDetailX?.seasons as ss}
					<option value={ss.season_number}>{ss.name}</option>
				{/each}
			</select>

			<!-- <p class="mt-2 text-sm text-gray-300">Selected: {selectedSeason}</p> -->
			<div class="flex flex-col gap-3">
				{#each movieDetailX?.seasons[selectedSeason - 1].episodes as ep}
					<button
						class="flex cursor-pointer items-center gap-2 rounded-lg bg-[#8558cf]/10 p-2"
						onclick={() => {
							handleSelectEpisode(ep);
						}}
					>
						<img src={ep.poster_path} alt={ep.name} class="h-12 w-20 rounded-lg object-cover" />
						<div class="text-left">
							<p class="text-sm font-semibold">{ep.name}</p>
							<p class="text-sm text-gray-300">
								{movieDetailX?.seasons[selectedSeason - 1].release_date
									? new Date(movieDetailX?.seasons[selectedSeason - 1].release_date).toLocaleDateString('en-GB', {
											day: 'numeric',
											month: 'short',
											year: 'numeric'
										})
									: 'ไม่ระบุ'}
							</p>
						</div>
					</button>
				{/each}
			</div>
		</div>
	{/if}
</div>

<!-- <pre class="text-white">{JSON.stringify(movieDetailX?.seasons, null, 2)}</pre> -->

<style>
	.frame334-frame19487552722 {
		gap: 8px;
		display: flex;
		align-self: stretch;
		align-items: flex-end;
		flex-direction: column;
		justify-content: center;
	}

	.frame334-frame19487552722 {
		gap: 8px;
		display: flex;
		align-self: stretch;
		align-items: flex-end;
		flex-direction: column;
		justify-content: center;
	}

	.frame334-frame19487552723 {
		gap: 8px;
		display: flex;
		align-self: stretch;
		align-items: center;
		flex-shrink: 0;
	}

	.frame334-text36 {
		color: rgba(238, 238, 238, 1);
		height: auto;
		font-size: 18px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text37 {
		font-weight: 700;
	}

	.frame334-frame19487552753 {
		gap: 8px;
		display: flex;
		padding: 12px;
		align-self: stretch;
		align-items: flex-start;
		flex-shrink: 0;
		border-color: rgba(238, 238, 238, 0.20000000298023224);
		border-style: solid;
		border-width: 1px;
		border-radius: 12px;
	}

	.frame334-userprofile2 {
		width: 50px;
		height: 50px;
	}

	.frame334-frame19487552754 {
		gap: 12px;
		max-width: 95%;
		display: flex;
		flex-grow: 1;
		align-items: flex-start;
		flex-shrink: 0;
		flex-direction: column;
	}

	.frame334-frame19487552771 {
		gap: 8px;
		display: flex;
		align-items: center;
	}

	.frame334-text39 {
		color: rgba(133, 87, 206, 1);
		height: auto;
		font-size: 10px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text40 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552732 {
		gap: 10px;
		display: flex;
		overflow: hidden;
		align-self: stretch;
		align-items: flex-start;
		flex-shrink: 0;
	}

	.frame334-text41 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		flex-grow: 1;
		font-size: 14px;
		align-self: stretch;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552801 {
		gap: 12px;
		display: flex;
		align-items: center;
	}

	.frame334-frame19487552791 {
		gap: 4px;
		display: flex;
		padding: 6px 10px;
		align-items: center;
		border-color: rgba(238, 238, 238, 0.30000001192092896);
		border-style: solid;
		border-width: 1px;
		border-radius: 8px;
	}

	.frame334-text42 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text43 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552811 {
		gap: 4px;
		height: 36px;
		display: flex;
		padding: 6px 10px;
		align-items: center;
		flex-shrink: 0;
		border-color: rgba(238, 238, 238, 0.30000001192092896);
		border-style: solid;
		border-width: 1px;
		border-radius: 8px;
	}

	.frame334-text44 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552763 {
		gap: 8px;
		display: flex;
		padding: 12px;
		align-self: stretch;
		align-items: flex-start;
		flex-shrink: 0;
		border-color: rgba(238, 238, 238, 0.20000000298023224);
		border-style: solid;
		border-width: 1px;
		border-radius: 12px;
	}

	.frame334-userprofile4 {
		width: 50px;
		height: 50px;
	}

	.frame334-frame19487552772 {
		gap: 8px;
		display: flex;
		align-items: center;
	}

	.frame334-text49 {
		color: rgba(133, 87, 206, 1);
		height: auto;
		font-size: 10px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text50 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552734 {
		gap: 10px;
		display: flex;
		overflow: hidden;
		align-self: stretch;
		align-items: flex-start;
		flex-shrink: 0;
	}

	.frame334-text51 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		flex-grow: 1;
		font-size: 14px;
		align-self: stretch;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552802 {
		gap: 12px;
		display: flex;
		align-items: center;
	}

	.frame334-frame19487552792 {
		gap: 4px;
		display: flex;
		padding: 6px 10px;
		align-items: center;
		border-color: rgba(238, 238, 238, 0.30000001192092896);
		border-style: solid;
		border-width: 1px;
		border-radius: 8px;
	}

	.frame334-text52 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text53 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 9px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552812 {
		gap: 4px;
		height: 36px;
		display: flex;
		padding: 6px 10px;
		align-items: center;
		flex-shrink: 0;
		border-color: rgba(238, 238, 238, 0.30000001192092896);
		border-style: solid;
		border-width: 1px;
		border-radius: 8px;
	}

	.frame334-text54 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 9px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552773 {
		gap: 8px;
		display: flex;
		padding: 12px;
		align-self: stretch;
		align-items: flex-start;
		flex-shrink: 0;
		border-color: rgba(238, 238, 238, 0.20000000298023224);
		border-style: solid;
		border-width: 1px;
		border-radius: 12px;
	}

	.frame334-userprofile5 {
		width: 50px;
		height: 50px;
	}

	.frame334-frame19487552774 {
		gap: 8px;
		display: flex;
		align-items: center;
	}

	.frame334-text55 {
		color: rgba(133, 87, 206, 1);
		height: auto;
		font-size: 10px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text56 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552735 {
		gap: 10px;
		display: flex;
		overflow: hidden;
		align-self: stretch;
		align-items: flex-start;
		flex-shrink: 0;
	}

	.frame334-text57 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		flex-grow: 1;
		font-size: 14px;
		align-self: stretch;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552803 {
		gap: 12px;
		display: flex;
		align-items: center;
	}

	.frame334-frame19487552793 {
		gap: 4px;
		display: flex;
		padding: 6px 10px;
		align-items: center;
		border-color: rgba(238, 238, 238, 0.30000001192092896);
		border-style: solid;
		border-width: 1px;
		border-radius: 8px;
	}

	.frame334-text58 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Bold;
		text-align: left;
		font-family: Inter;
		font-weight: 700;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-text59 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}

	.frame334-frame19487552813 {
		gap: 4px;
		height: 36px;
		display: flex;
		padding: 6px 10px;
		align-items: center;
		flex-shrink: 0;
		border-color: rgba(238, 238, 238, 0.30000001192092896);
		border-style: solid;
		border-width: 1px;
		border-radius: 8px;
	}

	.frame334-text60 {
		color: rgba(238, 238, 238, 0.6000000238418579);
		height: auto;
		font-size: 10px;
		font-style: Regular;
		text-align: left;
		font-family: Inter;
		font-weight: 400;
		line-height: normal;
		font-stretch: normal;
		text-decoration: none;
	}
</style>

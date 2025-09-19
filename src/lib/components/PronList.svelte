<script lang="ts">
	import mdiplaycircleoutlineI012 from '$lib/images/mdiplaycircleoutlinei012-xx3h.svg';
    let { porns } = $props();
</script>
<div class="my-3 grid grid-cols-6 gap-2">
	<!-- <pre>{JSON.stringify(allMovies, null, 2)}</pre> -->
	{#each porns as movie (movie?.id)}
		<a href={`/porns/${movie?.id}`} class="group relative cursor-pointer">
			<div
				class="relative overflow-hidden rounded-lg bg-gray-800 shadow-lg transition-transform duration-300 group-hover:scale-105"
			>
				<img src={movie?.image_url} alt={movie?.title} class="frame1-image11" />
				<div
					class="absolute right-0 bottom-0 left-0 translate-y-full transform bg-gradient-to-t from-black via-black/80 to-transparent p-4 transition-transform duration-300 group-hover:translate-y-0"
				>
					<img
						src={mdiplaycircleoutlineI012}
						alt="mdiplaycircleoutlineI012"
						class="mx-auto"
					/>
					<h3 class="mb-1 line-clamp-2 text-sm font-semibold text-white">{movie?.title}</h3>

				</div>
			</div>
		</a>
	{/each}
</div>
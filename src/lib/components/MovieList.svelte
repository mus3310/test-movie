<script lang="ts">
	import mdiplaycircleoutlineI012 from '$lib/images/mdiplaycircleoutlinei012-xx3h.svg';
    let { movies } = $props();
</script>
<!-- For Movies and Series -->
<div class="my-3 grid grid-cols-6 gap-2">
	<!-- <pre>{JSON.stringify(allMovies, null, 2)}</pre> -->
	{#each movies as movie (movie?.id)}
		<a href={`${movie?.type === 'Movies' ? '/movies' : '/series'}/${movie?.id}`} class="group relative cursor-pointer">
			<div
				class="relative overflow-hidden rounded-lg bg-gray-800 shadow-lg transition-transform duration-300 group-hover:scale-105"
			>
				<img src={movie?.poster_path} alt={movie?.name} class="frame1-image11" />
				<div
					class="absolute right-0 bottom-0 left-0 translate-y-full transform bg-gradient-to-t from-black via-black/80 to-transparent p-4 transition-transform duration-300 group-hover:translate-y-0"
				>
					<img
						src={mdiplaycircleoutlineI012}
						alt="mdiplaycircleoutlineI012"
						class="mx-auto"
					/>
					<h3 class="mb-1 line-clamp-2 text-sm font-semibold text-white">{movie?.name}</h3>

					<div class="space-y-1 text-xs text-gray-300">
						<div>Release: {movie?.created_at ? new Date(movie?.created_at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' }) : 'ไม่ระบุ'}</div>
						<div>Genres: {movie?.genres?.map(genre => genre.name).join(' ')}</div>
					</div>
				</div>
			</div>
			<!-- Mobile title - shows below poster on mobile -->
			<h3 class="text-center mt-2 block line-clamp-2 text-sm font-semibold text-white md:hidden">{movie?.name}</h3>
		</a>
	{/each}
</div>
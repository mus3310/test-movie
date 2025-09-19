<script lang="ts">
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	
	interface Props {
		total?: number;
		page_size?: number;
	}
	
	let { total = 100, page_size = 10 }: Props = $props();

	// ดึง page ปัจจุบันจาก URL - ใช้ $derived แทน $:
	const currentPage = $derived(Number(page.url.searchParams.get('page') ?? 1));

	// กำหนดจำนวนหน้าสูงสุด - ใช้ $derived เพื่อคำนวณจาก total และ page_size
	const totalPages = $derived(Math.ceil(total / page_size));

	// จำนวนหน้าที่จะแสดงใน pagination
	const maxVisible = 5;

	// หา start และ end ของ window - ใช้ $derived แทน $:
	const paginationWindow = $derived(() => {
		let tempStart = Math.max(1, currentPage - Math.floor(maxVisible / 2));
		let tempEnd = Math.min(totalPages, tempStart + maxVisible - 1);

		// ถ้า end ชนขอบ → เลื่อน start กลับ
		tempStart = Math.max(1, tempEnd - maxVisible + 1);

		return {
			start: tempStart,
			end: tempEnd
		};
	});

	const start = $derived(paginationWindow().start);
	const end = $derived(paginationWindow().end);

	// เปลี่ยนหน้า
	async function goToPage(p: number) {
		if (p >= 1 && p <= totalPages) {
			// console.log('goToPage', p);
			// console.log('page.url', page.url);
			// console.log('page.url.pathname', page.url.pathname);
			if(page.url.pathname.includes('search_movie')){
				console.log('on search_movie');
				await goto(`${page.url.pathname}?keyword=${page.url.searchParams.get('keyword')}&page=${p}`, { replaceState: false });
				window.location.reload();
			} else {
				await goto(`${page.url.pathname}?page=${p}`, { replaceState: false });
				window.location.reload();
			}

			// await goto(`${page.url.pathname}?page=${p}`, { replaceState: false });
			// window.location.reload();
		}
	}
</script>

<div class="pagination">
	<button onclick={() => goToPage(currentPage - 1)} disabled={currentPage === 1}> &lt; </button>

	<!-- ถ้า start > 1 แสดงปุ่มหน้าแรก -->
	{#if start > 1}
		<button onclick={() => goToPage(1)}>1</button>
		<span>...</span>
	{/if}

	<!-- แสดงหน้าใน window -->
	{#each Array(end - start + 1) as _, i}
		<button class:active={currentPage === start + i} onclick={() => goToPage(start + i)}>
			{start + i}
		</button>
	{/each}
  
  <!-- ถ้า end < totalPages แสดงปุ่มหน้าสุดท้าย -->
	{#if end < totalPages}
		<span>...</span>
		<button onclick={() => goToPage(totalPages)}>{totalPages}</button>
	{/if}

	<button onclick={() => goToPage(currentPage + 1)} disabled={currentPage === totalPages}>
		&gt;
	</button>
</div>

<style>
	.pagination {
		display: flex;
		justify-content: center;
		margin-top: 25px;
		gap: 8px;
	}

	.pagination button {
		background: #1a1a2e;
		border: none;
		color: white;
		padding: 8px 12px;
		border-radius: 6px;
		cursor: pointer;
	}

	.pagination button.active {
		background: #7c3aed;
	}

	.pagination button:hover:not(.active):not(:disabled) {
		background: #2d2d44;
	}

	.pagination button:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.pagination span {
		color: #aaa;
		padding: 0 4px;
	}
</style>

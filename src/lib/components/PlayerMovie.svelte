<script lang="ts">
	import { browser } from '$app/environment';
	import type { MovieDataDetail } from '$lib/types/moviesDetail';

	// Dynamic import Plyr and HLS.js only on client-side
	let Plyr: any;
	let Hls: any;

	interface Props {
		movieDetail?: MovieDataDetail | null;
		videoSources?: Array<{ src: string; type: string; size?: number }>;
		posterUrl?: string;
		autoplay?: boolean;
		volume?: number;
		adsEnabled?: boolean;
		adsTagUrl?: string;
	}

	let {
		movieDetail = null,
		videoSources = [
			{
				src: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8',
				type: 'application/x-mpegURL'
			}
		],
		posterUrl = '',
		autoplay = false,
		volume = 1,
		adsEnabled = true,
		adsTagUrl = 'https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator='
	}: Props = $props();

	let videoElement: HTMLVideoElement = $state() as HTMLVideoElement;
	let player: any;
	let hls: any;
	let isLoading = $state(true);
	let plyrReady = $state(false);
	let isHLS = $state(false);
	let hlsLevels = $state<any[]>([]);
	let currentLevel = $state(-1);
	let showHLSInfo = $state(false);
	let isAutoQuality = $state(true);

	// Use $effect for initialization and cleanup in Svelte 5
	$effect(() => {
		const initializePlayer = async () => {
			// Only run on client-side to avoid SSR issues
			if (!browser) return;

			try {
				// Dynamic import Plyr to avoid SSR issues
				const PlyrModule = await import('plyr');
				Plyr = (PlyrModule as any).default || PlyrModule;

				// Check if we have HLS sources
				isHLS = videoSources.some(
					(source) => source.type === 'application/x-mpegURL' || source.src.includes('.m3u8')
				);

				// Import HLS.js if needed
				if (isHLS) {
					try {
						const HlsModule = await import('hls.js');
						Hls = (HlsModule as any).default || HlsModule;
					} catch (hlsError) {
						console.error('Failed to load HLS.js:', hlsError);
						isHLS = false;
					}
				}
			} catch (error) {
				console.error('Failed to load Plyr:', error);
				return;
			}

		// Setup HLS if needed
		if (isHLS && Hls && Hls.isSupported()) {
			hls = new Hls({
				enableSoftwareAES: true,
				maxLoadingDelay: 4,
				maxBufferLength: 30,
				maxBufferSize: 60 * 1000 * 1000,
				maxBufferHole: 0.5
			});

			// Load HLS source
			const hlsSource = videoSources.find(
				(source) => source.type === 'application/x-mpegURL' || source.src.includes('.m3u8')
			);
			if (hlsSource) {
				hls.loadSource(hlsSource.src);
				hls.attachMedia(videoElement);
			}

			// HLS event handlers
			hls.on(Hls.Events.MANIFEST_LOADED, (event: any, data: any) => {
				console.log('HLS Manifest loaded:', data);
				hlsLevels = data.levels;
				console.log('Available HLS levels:', hlsLevels);

				// HLS levels loaded - quality menu should now be available
				console.log(
					'HLS levels loaded:',
					hlsLevels.map((l) => `${l.width}x${l.height}`)
				);
			});

			hls.on(Hls.Events.LEVEL_SWITCHED, (event: any, data: any) => {
				currentLevel = data.level;
				// Update auto quality state based on hls.autoLevelEnabled
				isAutoQuality = hls.autoLevelEnabled;
				console.log('HLS Level switched to:', currentLevel, hlsLevels[currentLevel]);
				console.log('Auto quality enabled:', isAutoQuality);
			});

			// HLS error handling
			hls.on(Hls.Events.ERROR, (event: any, data: any) => {
				console.error('HLS Error:', data);
				if (data.fatal) {
					switch (data.type) {
						case Hls.ErrorTypes.NETWORK_ERROR:
							console.log('Network error encountered, trying to recover...');
							hls.startLoad();
							break;
						case Hls.ErrorTypes.MEDIA_ERROR:
							console.log('Media error encountered, trying to recover...');
							hls.recoverMediaError();
							break;
						default:
							console.log('Fatal error encountered, cannot recover');
							hls.destroy();
							break;
					}
				}
			});
		} else if (isHLS && videoElement.canPlayType('application/vnd.apple.mpegurl')) {
			// Native HLS support (Safari)
			const hlsSource = videoSources.find(
				(source) => source.type === 'application/x-mpegURL' || source.src.includes('.m3u8')
			);
			if (hlsSource) {
				videoElement.src = hlsSource.src;
			}
		}

		// Initialize Plyr ตามมาตรฐาน Plyr.io
		if (videoElement && Plyr) {
			player = new Plyr(videoElement, {
				// ตั้งค่าตาม Plyr.io documentation
				autoplay: autoplay,
				volume: volume,
				muted: false,
				clickToPlay: true,
				hideControls: true,
				resetOnEnd: false,
				keyboard: {
					focused: true,
					global: false
				},
				tooltips: {
					controls: true,
					seek: true
				},
				captions: {
					active: false,
					language: 'auto',
					update: false
				},
				fullscreen: {
					enabled: true,
					fallback: true,
					iosNative: false,
					container: null
				},
				// Controls ตามมาตรฐาน Plyr.io
				controls: [
					'play-large',
					'restart',
					'rewind',
					'play',
					'fast-forward',
					'progress',
					'current-time',
					'duration',
					'mute',
					'volume',
					'captions',
					'settings',
					'pip',
					'airplay',
					'fullscreen'
				],
				settings: ['captions', 'quality', 'speed'],
				// Quality options ตาม Plyr.io
				quality: {
					default: 'Auto',
					options: isHLS
						? [1080, 720, 540, 432, 360, 270]
						: videoSources.filter((s) => s.size).map((source) => source.size!),
					forced: true,
					onChange: (quality: any) => {
						console.log(`Quality changed to: ${quality}`);
						if (isHLS) {
							handleHLSQualityChange(quality);
						}
					}
				},
				// Speed options ตาม Plyr.io
				speed: {
					selected: 1,
					options: [0.5, 0.75, 1, 1.25, 1.5, 2]
				},
				ads: {
					enabled: adsEnabled,
					publisherId: '124319096', // Google Ad Manager Publisher ID
					tagUrl: adsTagUrl,
					// VAST ad configuration
					skipButton: {
						enabled: true,
						delay: 5,
						text: 'ข้าม โฆษณา'
					},
					// Preroll ads configuration
					preroll: {
						enabled: true,
						skipDelay: 5
					},
					// Localization for ads
					i18n: {
						advertisement: 'โฆษณา',
						skip: 'ข้าม',
						skipIn: 'ข้ามใน {time}',
						loading: 'กำลังโหลดโฆษณา...'
					}
				},
				// Localization สำหรับภาษาไทย
				i18n: {
					restart: 'เริ่มใหม่',
					rewind: 'ย้อนกลับ {seektime}s',
					play: 'เล่น',
					pause: 'หยุดชั่วคราว',
					fastForward: 'เดินหน้า {seektime}s',
					seek: 'ข้ามไป {seektime}s',
					seekLabel: '{currentTime} จาก {duration}',
					played: 'เล่นแล้ว',
					buffered: 'บัฟเฟอร์',
					currentTime: 'เวลาปัจจุบัน',
					duration: 'ระยะเวลา',
					volume: 'ระดับเสียง',
					mute: 'ปิดเสียง',
					unmute: 'เปิดเสียง',
					enableCaptions: 'เปิดคำบรรยาย',
					disableCaptions: 'ปิดคำบรรยาย',
					enterFullscreen: 'เต็มจอ',
					exitFullscreen: 'ออกจากเต็มจอ',
					frameTitle: 'Player สำหรับ {title}',
					captions: 'คำบรรยาย',
					settings: 'ตั้งค่า',
					pip: 'Picture-in-Picture',
					menuBack: 'กลับไปเมนูก่อนหน้า',
					speed: 'ความเร็ว',
					normal: 'ปกติ',
					quality: 'คุณภาพ',
					loop: 'เล่นซ้ำ',
					start: 'เริ่ม',
					end: 'จบ',
					all: 'ทั้งหมด',
					reset: 'รีเซ็ต',
					disabled: 'ปิดใช้งาน',
					enabled: 'เปิดใช้งาน',
					advertisement: 'โฆษณา',
				}
			});

			// Event listeners ตาม Plyr.io documentation
			player.on('ready', () => {
				isLoading = false;
				plyrReady = true;
				console.log('Plyr is ready');

				// Player is ready for HLS
				console.log('Plyr ready - HLS levels available:', hlsLevels.length);
			});

			player.on('loadstart', () => {
				isLoading = true;
			});

			player.on('canplay', () => {
				isLoading = false;
			});

			player.on('play', () => {
				console.log('Video started playing');
			});

			player.on('pause', () => {
				console.log('Video paused');
			});

			player.on('ended', () => {
				console.log('Video ended');
			});

			player.on('timeupdate', () => {
				// Update progress if needed
			});

			player.on('volumechange', () => {
				console.log(`Volume: ${player.volume}`);
			});

			player.on('qualitychange', (event: any) => {
				console.log(`Quality changed: ${event.detail.quality}p`);
			});

			player.on('fullscreenchange', () => {
				console.log(`Fullscreen: ${player.fullscreen.active}`);
			});

			// Error handling
			player.on('error', (event: any) => {
				console.error('Plyr error:', event.detail);
			});

			// Ads event handlers สำหรับ Google Ad Manager VAST
			if (adsEnabled) {
				// Ad started
				player.on('adstart', (event: any) => {
					console.log('Ad started:', event.detail);
					// สามารถส่งข้อมูลไป analytics ได้ที่นี่
				});

				// Ad ended
				player.on('adend', (event: any) => {
					console.log('Ad ended:', event.detail);
					// สามารถส่งข้อมูลไป analytics ได้ที่นี่
				});

				// Ad skipped
				player.on('adskip', (event: any) => {
					console.log('Ad skipped:', event.detail);
					// สามารถส่งข้อมูลไป analytics ได้ที่นี่
				});

				// Ad error
				player.on('aderror', (event: any) => {
					console.error('Ad error:', event.detail);
					// Fallback: เล่นวิดีโอหลักทันทีถ้าโฆษณาผิดพลาด
					console.log('Ad failed, continuing with main content...');
				});

				// Ad impression
				player.on('adimpression', (event: any) => {
					console.log('Ad impression:', event.detail);
				});

				// Ad clicked
				player.on('adclick', (event: any) => {
					console.log('Ad clicked:', event.detail);
				});

				// Ad progress
				player.on('adprogress', (event: any) => {
					console.log('Ad progress:', event.detail);
				});
			}
		}
	};

		initializePlayer();

		// Return cleanup function for $effect
		return () => {
			// Clean up ตาม Plyr.io best practices
			if (player) {
				player.destroy();
			}
			// Clean up HLS
			if (hls) {
				hls.destroy();
			}
		};
	});

	$effect(() => {
		if (browser && player && videoSources.length > 0 && !isHLS) {
			// Only update source for non-HLS videos
			player.source = {
				type: 'video',
				title: movieDetail?.name || 'Movie Player',
				poster: posterUrl,
				sources: videoSources.filter((s) => s.type !== 'application/x-mpegURL'),
				tracks: [
					{
						kind: 'captions',
						label: 'Thai',
						srclang: 'th',
						src: '',
						default: false
					},
					{
						kind: 'captions',
						label: 'English',
						srclang: 'en',
						src: '',
						default: false
					}
				]
			};
		}
	});

	// Function to update HLS source
	function updateHLSSource(newSources: typeof videoSources) {
		if (!isHLS || !hls) return;

		const hlsSource = newSources.find(
			(source) => source.type === 'application/x-mpegURL' || source.src.includes('.m3u8')
		);

		if (hlsSource && hlsSource.src !== hls.url) {
			hls.loadSource(hlsSource.src);
		}
	}

	// Watch for HLS source changes using $effect
	$effect(() => {
		if (browser && isHLS) {
			updateHLSSource(videoSources);
		}
	});

	// Function to change HLS quality level
	function changeQualityLevel(levelIndex: number) {
		if (!hls || !hlsLevels.length) return;

		if (levelIndex === -1) {
			// Auto quality
			hls.currentLevel = -1;
			isAutoQuality = true;
			console.log('Switched to auto quality');
		} else {
			// Manual quality
			if (levelIndex >= 0 && levelIndex < hlsLevels.length) {
				hls.currentLevel = levelIndex;
				isAutoQuality = false;
				console.log(`Manually switched to level ${levelIndex}:`, hlsLevels[levelIndex]);
			}
		}
	}

	// Function to get quality label
	function getQualityLabel(level: any): string {
		if (!level) return 'Unknown';

		const resolution = `${level.width}x${level.height}`;
		const bitrate = Math.round(level.bitrate / 1000);
		const fps = level.attrs?.FRAME_RATE ? `@${level.attrs.FRAME_RATE}fps` : '';

		return `${resolution} (${bitrate}k) ${fps}`.trim();
	}

	// Function to handle HLS quality change from Plyr
	function handleHLSQualityChange(quality: any) {
		if (!hls || !hlsLevels.length) return;

		console.log('Handling quality change:', quality, typeof quality);

		if (quality === 'Auto' || quality === 'auto') {
			// Enable auto quality
			hls.currentLevel = -1;
			isAutoQuality = true;
			console.log('Switched to auto quality via Plyr');
		} else {
			// Manual quality selection
			let targetHeight = 0;

			if (typeof quality === 'number') {
				targetHeight = quality;
			} else if (typeof quality === 'string') {
				if (quality.endsWith('p')) {
					targetHeight = parseInt(quality.replace('p', ''));
				} else {
					targetHeight = parseInt(quality);
				}
			}

			if (targetHeight > 0) {
				const levelIndex = hlsLevels.findIndex((level) => level.height === targetHeight);

				if (levelIndex >= 0) {
					hls.currentLevel = levelIndex;
					isAutoQuality = false;
					console.log(`Switched to ${targetHeight}p via Plyr (level ${levelIndex})`);
				} else {
					console.warn(`No HLS level found for height ${targetHeight}`);
				}
			}
		}
	}
</script>

<!-- Plyr CSS ต้อง import ตาม Plyr.io documentation -->
<svelte:head>
	{#if browser}
		<link rel="stylesheet" href="https://cdn.plyr.io/3.8.3/plyr.css" />
	{/if}
</svelte:head>

<div class="plyr-container">
	<!-- Loading Spinner -->
	{#if isLoading || !browser}
		<div class="plyr-loading">
			<div class="plyr-loading-spinner">
				<div class="spinner"></div>
				<p>กำลังโหลดวิดีโอ...</p>
			</div>
		</div>
	{/if}

	<!-- Video Element ตาม Plyr.io structure -->
	{#if browser}
		<video
			bind:this={videoElement}
			class="plyr-video"
			crossorigin="anonymous"
			playsinline
			poster={posterUrl}
			preload="metadata"
			data-plyr-title={movieDetail?.name || 'Movie Player'}
			controls={!plyrReady}
		>
			<!-- Multiple Video Sources for Quality Selection -->
			{#if !isHLS}
				{#each videoSources as source}
					<source src={source.src} type={source.type} data-size={source.size} />
				{/each}
			{/if}

			<!-- Caption tracks -->
			<track kind="captions" label="Thai" srclang="th" />
			<track kind="captions" label="English" srclang="en" />

			<!-- Fallback -->
			<p>
				เบราว์เซอร์ของคุณไม่รองรับการเล่นวิดีโอ HTML5
				<a href={videoSources[0]?.src} download>ดาวน์โหลดวิดีโอ</a>
			</p>
		</video>
	{:else}
		<!-- SSR Fallback -->
		<div class="ssr-video-placeholder">
			<div class="video-placeholder-content">
				<svg
					width="48"
					height="48"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2"
				>
					<polygon points="5,3 19,12 5,21 5,3"></polygon>
				</svg>
				<p>Video Player</p>
			</div>
		</div>
	{/if}

	<!-- Movie Info Overlay (Optional) -->
	{#if movieDetail && !isLoading}
		<div class="movie-info-overlay">
			<div class="movie-info-content">
				<h3 class="movie-title">{movieDetail.name}</h3>
				{#if movieDetail.tagline}
					<p class="movie-tagline">{movieDetail.tagline}</p>
				{/if}
				{#if movieDetail.genres && movieDetail.genres.length > 0}
					<div class="movie-genres">
						{#each movieDetail.genres.slice(0, 3) as genre}
							<span class="genre-tag">{genre}</span>
						{/each}
					</div>
				{/if}
			</div>
		</div>
	{/if}

	<!-- HLS Debug Info (Optional - only show in development) -->
	{#if isHLS && hlsLevels.length > 0 && browser && window.location.hostname === 'localhost'}
		<div class="hls-debug-info">
			<div class="hls-debug-content">
				<strong>HLS Debug:</strong>
				{#if currentLevel >= 0 && hlsLevels[currentLevel]}
					{hlsLevels[currentLevel].width}x{hlsLevels[currentLevel].height}
					({Math.round(hlsLevels[currentLevel].bitrate / 1000)}k)
					{isAutoQuality ? '(Auto)' : '(Manual)'}
				{:else}
					Auto mode
				{/if}
			</div>
		</div>
	{/if}
</div>

<style>
	/* Container สำหรับ Plyr player */
	.plyr-container {
		position: relative;
		width: 100%;
		background: #000;
		border-radius: 8px;
		overflow: hidden;
		box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
	}

	/* Video element */
	.plyr-video {
		width: 100%;
		height: auto;
		aspect-ratio: 16/9;
	}

	/* Loading state */
	.plyr-loading {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background: rgba(0, 0, 0, 0.8);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 100;
	}

	.plyr-loading-spinner {
		text-align: center;
		color: white;
	}

	.spinner {
		width: 40px;
		height: 40px;
		border: 4px solid rgba(255, 255, 255, 0.3);
		border-top: 4px solid #fff;
		border-radius: 50%;
		animation: spin 1s linear infinite;
		margin: 0 auto 16px;
	}

	@keyframes spin {
		0% {
			transform: rotate(0deg);
		}
		100% {
			transform: rotate(360deg);
		}
	}

	/* SSR Video Placeholder */
	.ssr-video-placeholder {
		width: 100%;
		aspect-ratio: 16/9;
		background: #1a1a1a;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 8px;
	}

	.video-placeholder-content {
		text-align: center;
		color: #666;
	}

	.video-placeholder-content svg {
		margin: 0 auto 12px;
		opacity: 0.5;
	}

	.video-placeholder-content p {
		margin: 0;
		font-size: 14px;
	}

	/* Movie info overlay */
	.movie-info-overlay {
		position: absolute;
		top: 16px;
		left: 16px;
		background: rgba(0, 0, 0, 0.7);
		border-radius: 8px;
		padding: 16px;
		max-width: 300px;
		opacity: 0;
		transition: opacity 0.3s ease;
		z-index: 50;
	}

	.plyr-container:hover .movie-info-overlay {
		opacity: 1;
	}

	.movie-title {
		color: white;
		font-size: 18px;
		font-weight: bold;
		margin: 0 0 8px 0;
		line-height: 1.3;
	}

	.movie-tagline {
		color: #ccc;
		font-size: 14px;
		margin: 0 0 12px 0;
		line-height: 1.4;
	}

	.movie-genres {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
	}

	.genre-tag {
		background: #3b82f6;
		color: white;
		padding: 4px 8px;
		border-radius: 4px;
		font-size: 12px;
		font-weight: 500;
	}

	/* Custom Plyr theme overrides */
	:global(.plyr) {
		border-radius: 8px;
	}

	:global(.plyr--video) {
		background: #000;
	}

	:global(.plyr__control) {
		color: #fff;
		transition: all 0.2s ease;
	}

	:global(.plyr__control:hover) {
		background: rgba(255, 255, 255, 0.1);
		transform: scale(1.05);
	}

	:global(.plyr__control--pressed) {
		background: #3b82f6;
		color: #fff;
	}

	:global(.plyr__progress__value) {
		background: #3b82f6;
	}

	:global(.plyr__volume__value) {
		background: #3b82f6;
	}

	:global(.plyr__controls) {
		background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
		padding: 16px;
	}

	:global(.plyr__control--overlaid) {
		background: rgba(59, 130, 246, 0.9);
		border: 3px solid #fff;
		border-radius: 50%;
	}

	:global(.plyr__control--overlaid:hover) {
		background: #3b82f6;
		transform: scale(1.1);
	}

	/* Responsive design */
	@media (max-width: 768px) {
		.movie-info-overlay {
			position: static;
			opacity: 1;
			max-width: none;
			margin-top: 16px;
		}

		:global(.plyr__controls) {
			padding: 12px;
		}
	}

	/* Settings menu styling */
	:global(.plyr__menu) {
		background: rgba(0, 0, 0, 0.9);
		border: 1px solid rgba(255, 255, 255, 0.1);
		border-radius: 8px;
		backdrop-filter: blur(10px);
	}

	:global(.plyr__menu__item) {
		color: #fff;
	}

	:global(.plyr__menu__item:hover) {
		background: rgba(59, 130, 246, 0.8);
	}

	/* Tooltip styling */
	:global(.plyr__tooltip) {
		background: rgba(0, 0, 0, 0.8);
		color: #fff;
		border-radius: 4px;
		font-size: 12px;
	}

	/* HLS Debug Info (Development only) */
	.hls-debug-info {
		position: absolute;
		bottom: 60px;
		left: 16px;
		background: rgba(0, 0, 0, 0.8);
		color: #22c55e;
		border: 1px solid rgba(34, 197, 94, 0.3);
		border-radius: 4px;
		padding: 8px 12px;
		font-size: 11px;
		font-family: monospace;
		z-index: 50;
		backdrop-filter: blur(5px);
	}

	.hls-debug-content {
		white-space: nowrap;
	}

	/* Custom Ads Styling */
	:global(.plyr--ads-loading) {
		background: rgba(0, 0, 0, 0.8);
	}

	:global(.plyr--ads-loading::before) {
		content: 'กำลังโหลดโฆษณา...';
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		color: white;
		font-size: 16px;
		z-index: 100;
	}

	:global(.plyr__ad-overlay) {
		background: rgba(0, 0, 0, 0.7);
		color: white;
		font-family: 'Sarabun', sans-serif;
	}

	:global(.plyr__ad-skip-button) {
		background: rgba(59, 130, 246, 0.9);
		color: white;
		border: none;
		padding: 8px 16px;
		border-radius: 4px;
		font-size: 14px;
		font-weight: 500;
		cursor: pointer;
		transition: all 0.2s ease;
	}

	:global(.plyr__ad-skip-button:hover) {
		background: #3b82f6;
		transform: scale(1.05);
	}

	:global(.plyr__ad-time) {
		color: #fbbf24;
		font-weight: bold;
	}

	:global(.plyr__ad-text) {
		color: white;
		font-size: 14px;
		opacity: 0.9;
	}

	/* Ad countdown styling */
	:global(.plyr__ad-countdown) {
		position: absolute;
		top: 16px;
		right: 16px;
		background: rgba(0, 0, 0, 0.8);
		color: white;
		padding: 8px 12px;
		border-radius: 4px;
		font-size: 14px;
		font-weight: 500;
		z-index: 100;
	}
</style>

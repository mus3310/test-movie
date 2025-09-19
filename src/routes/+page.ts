import api from '$lib/api';

import type { LoadEvent } from '@sveltejs/kit';

export const load = async (event: LoadEvent) => {
  console.log('event: ', event.url.searchParams.get('page'));
  
  const getMovies = async (params: any) => {
    return api.get('/api/movies', { ...params }, { fetch: event.fetch } as RequestInit)
  }

  const [lastest, comedy, animation, horror, genres] = await Promise.all([
    getMovies({
      page: 1,
      page_size: 12,
      sort_by: 'created_at',
    }),
    getMovies({
      page: 1,
      page_size: 12,
      sort_by: 'created_at',
      genres_id: '647f0006b56673f4f462eda9',
    }),
    getMovies({
      page: 1,
      page_size: 12,
      sort_by: 'created_at',
      genres_id: '647efff6b56673f4f462eda8',
    }),
    getMovies({
      page: 1,
      page_size: 12,
      sort_by: 'created_at',
      genres_id: '647f0067b56673f4f462edb1',
    }),
    api.get('/api/genres', {}, { fetch: event.fetch } as RequestInit)
  ])

  return {
    lastest,
    comedy,
    animation,
    horror,
    genres,
  };
};
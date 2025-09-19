import api from '$lib/api';

export const load = async (event) => {
  console.log('page: ', event.url.searchParams.get('page'));
  
  const getMovies = async (params: any) => {
    return api.get('/api/movieseries', { ...params }, { fetch: event.fetch } as RequestInit)
  }

  const [allMovies] = await Promise.all([
    getMovies({
      page: event.url.searchParams.get('page') ?? 1,
      page_size: 30,
      sort_by: 'last_updated_date',
    }),
    
  ])
  
//   console.log('allMovies: ', allMovies);
  return {
    allMovies,
  };
};
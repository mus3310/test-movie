import { writable } from "svelte/store";
import api from "$lib/api";

export const listHome = writable({    
    moviesSeries: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,        
    },
    movies: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    moviesLatest: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    moviesComedy: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    moviesAnimation: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    moviesHorror: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    series: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    porns: {
        ads: null,
        data: [],
        page: 0,
        page_size: 0,
        total: 0,  
    },
    genres: {
        data: [],
    },
});
const getTimeHeader = () => {
	const date = new Date();
	return {
		timestamp: date.toString().split('(')[0].trim(),
		timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
	};
};

// export const fetchMoviesLastest = async (params = {
//     page: 1,
//     page_size: 12,
//     sort_by: 'created_at',
//     // genres_id: '647efff6b56673f4f462eda8',
// }) => {
//     const { timestamp, timezone } = getTimeHeader();
//     try {
//         // console.log('---api -->', window.location.origin)
//         const myHeaders = new Headers()
//         myHeaders.append("Referer", window.location.origin)
//         myHeaders.append("timestamp", timestamp)
//         myHeaders.append("timezone", timezone)
//         myHeaders.append("Authorization", "Basic aWRvby1kZXY6ZEg2YlhFdFE5N2pMVm0zUEdvNE93QjU=")

//         const requestOptions = {
//             method: "GET",
//             headers: myHeaders,
//             redirect: "follow"
//         }

//         // สร้าง query string จาก parameters
//         const queryParams = new URLSearchParams(params).toString();
//         const response = await fetch(`/api/movies?${queryParams}`, requestOptions)


//         if (response.ok) {
//             const movies = await response.json();            
//             listHome.update((o) => {
//                 o.moviesLatest = movies;                
//                 return o;
//             });            
//             return movies;
//         }

//         return [];
//     } catch (error) {
//         console.error('Error fetching movies:', error);
//         throw error;
//     }
// }

export const fetchMoviesLastest = async (params = {
    page: 1,
    page_size: 12,
    sort_by: 'created_at',
    // genres_id: '647efff6b56673f4f462eda8',
}) => {
    try {
        const movies = await api.get('/api/movies', { ...params });
        listHome.update((o) => {
            o.moviesLatest = movies;                
            return o;
        });            
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }           
}

export const fetchMoviesComedy = async (params = {
    page: 1,
    page_size: 12,
    sort_by: 'created_at',
    genres_id: '647f0006b56673f4f462eda9',
}) => {

    try {
        const movies = await api.get('/api/movies', { ...params });
        listHome.update((o) => {
            o.moviesComedy = movies;                
            return o;
        });            
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }     
}

export const fetchMoviesAnimation = async (params = {
    page: 1,
    page_size: 12,
    sort_by: 'created_at',
    genres_id: '647efff6b56673f4f462eda8',
}) => {

    try {
        const movies = await api.get('/api/movies', { ...params });
        listHome.update((o) => {
            o.moviesAnimation = movies;                
            return o;
        });            
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }     
}

export const fetchMoviesHorror = async (params = {
    page: 1,
    page_size: 12,
    sort_by: 'created_at',
    genres_id: '647f0067b56673f4f462edb1',
}) => {

    try {
        const movies = await api.get('/api/movies', { ...params });
        listHome.update((o) => {
            o.moviesHorror = movies;                
            return o;
        });            
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }  
}

export const fetchGenres = async () => {
    try {
        const movies = await api.get('/api/genres');
        listHome.update((o) => {
            o.genres = movies;                
            return o;
        });            
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }  
}


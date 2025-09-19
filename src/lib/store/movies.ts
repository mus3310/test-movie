// import { apiService } from '../api/index';

import { writable } from "svelte/store";

export const listMovies = writable({    
    moviesSeries: {
        ads: null,
        data: [],
        page: 1,
        page_size: 10,
        total: 0,        
    },
    movies: {},
    series: {
        ads: null,
        data: [],
        page: 1,
        page_size: 10,
        total: 0, 
    },
    porns: {
        ads: null,
        data: [],
        page: 1,
        page_size: 10,
        total: 0, 
    },
    searchMovies: {
        ads: null,
        data: [],
        page: 1,
        page_size: 10,
        total: 0, 
    },
    genre: {},
});
const getTimeHeader = () => {
	const date = new Date();
	return {
		timestamp: date.toString().split('(')[0].trim(),
		timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
	};
};

export const fetchMoviesSeries = async (params = {
    page: 1,
    page_size: 30,
    sort_by: 'last_updated_date',
    // genres_id: '647efccab56673f4f462eda6'
}) => {
    const { timestamp, timezone } = getTimeHeader();
    try {
        const myHeaders = new Headers()
        myHeaders.append("Referer", window.location.origin)
        myHeaders.append("timestamp", timestamp)
        myHeaders.append("timezone", timezone)
        myHeaders.append("Authorization", "Basic aWRvby1kZXY6ZEg2YlhFdFE5N2pMVm0zUEdvNE93QjU=")

        const requestOptions = {
            method: "GET",
            headers: myHeaders,
            redirect: "follow"
        }

        // สร้าง query string จาก parameters
        const queryParams = new URLSearchParams(params).toString();
        const response = await fetch(`/api/movieseries?${queryParams}`, requestOptions)


        if (response.ok) {
            const movies = await response.json();            
            listMovies.update((o) => {
                o.moviesSeries = movies;                
                return o;
            });            
            return movies;
        }

        return [];
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }
}
export const fetchSeries = async (params = {
    page: 1,
    page_size: 30,
    sort_by: 'last_updated_date',    
}) => {
    const { timestamp, timezone } = getTimeHeader();
    try {
        const myHeaders = new Headers()
        myHeaders.append("Referer", window.location.origin)
        myHeaders.append("timestamp", timestamp)
        myHeaders.append("timezone", timezone)
        myHeaders.append("Authorization", "Basic aWRvby1kZXY6ZEg2YlhFdFE5N2pMVm0zUEdvNE93QjU=")

        const requestOptions = {
            method: "GET",
            headers: myHeaders,
            redirect: "follow"
        }

        const queryParams = new URLSearchParams(params).toString();
        const response = await fetch(`/api/series?${queryParams}`, requestOptions)


        if (response.ok) {
            const data = await response.json();            
            listMovies.update((o) => {
                o.series = data;                
                return o;
            });            
            return data;
        }

        return [];
    } catch (error) {
        console.error('Error fetching series:', error);
        throw error;
    }
}
export const fetchPorns = async (params = {
    page: 1,
    page_size: 30,
    sort_by: 'last_updated_date',    
}) => {
    const { timestamp, timezone } = getTimeHeader();
    try {
        const myHeaders = new Headers()
        myHeaders.append("Referer", window.location.origin)
        myHeaders.append("timestamp", timestamp)
        myHeaders.append("timezone", timezone)
        myHeaders.append("Authorization", "Basic aWRvby1kZXY6ZEg2YlhFdFE5N2pMVm0zUEdvNE93QjU=")

        const requestOptions = {
            method: "GET",
            headers: myHeaders,
            redirect: "follow"
        }

        const queryParams = new URLSearchParams(params).toString();
        const response = await fetch(`/api/porns?${queryParams}`, requestOptions)


        if (response.ok) {
            const data = await response.json();            
            listMovies.update((o) => {
                o.porns = data;                
                return o;
            });            
            return data;
        }

        return [];
    } catch (error) {
        console.error('Error fetching porns:', error);
        throw error;
    }
}
export const searchMovies = async (params = {}) => {
    const { timestamp, timezone } = getTimeHeader();
    try {
        const myHeaders = new Headers()
        myHeaders.append("Referer", window.location.origin)
        myHeaders.append("timestamp", timestamp)
        myHeaders.append("timezone", timezone)
        myHeaders.append("Authorization", "Basic aWRvby1kZXY6ZEg2YlhFdFE5N2pMVm0zUEdvNE93QjU=")

        const requestOptions = {
            method: "GET",
            headers: myHeaders,
            redirect: "follow"
        }

        const queryParams = new URLSearchParams(params).toString();
        const response = await fetch(`/api/movieseries?${queryParams}`, requestOptions)


        if (response.ok) {
            const data = await response.json();            
            listMovies.update((o) => {
                o.searchMovies = data;                
                return o;
            });            
            return data;
        }

        return [];
    } catch (error) {
        console.error('Error fetching search movies:', error);
        throw error;
    }
}


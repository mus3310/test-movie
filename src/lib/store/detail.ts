// import { writable } from "svelte/store";
import { config } from "$lib/config";

const getTimeHeader = () => {
    const date = new Date();
    return {
        timestamp: date.toString().split('(')[0].trim(),
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
    };
};

export const fetchMoviesDetail = async (params: any) => {
    const { timestamp, timezone } = getTimeHeader();
    try {
        console.log('config.domainUrl: ', config.domainUrl);
        const myHeaders = new Headers()
        myHeaders.append("Referer", config.domainUrl)
        myHeaders.append("timestamp", timestamp)
        myHeaders.append("timezone", timezone)
        myHeaders.append("Authorization", "Basic aWRvby1kZXY6ZEg2YlhFdFE5N2pMVm0zUEdvNE93QjU=")

        const requestOptions = {
            method: "GET",
            headers: myHeaders,
            redirect: "follow"
        }

        const response = await fetch(`/api${params}`, requestOptions)

        if (response.ok) {
            const movies = await response.json();
            return movies;
        }
        return [];
    } catch (error) {
        console.error('Error fetching movies:', error);
        throw error;
    }
}
export const fetchSeriesDetail = async (params: any) => {
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

        const response = await fetch(`/api/series${params}`, requestOptions)

        if (response.ok) {
            const series = await response.json();
            return series;
        }

        return [];
    } catch (error) {
        console.error('Error fetching series:', error);
        throw error;
    }
}
export const fetchPornDetail = async (params: any) => {
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

        const response = await fetch(`/api${params}`, requestOptions)

        if (response.ok) {
            const porns = await response.json();
            return porns;
        }

        return [];
    } catch (error) {
        console.error('Error fetching porns:', error);
        throw error;
    }
}


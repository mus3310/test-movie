export type MovieDataDetail = {
    id: string;
    name: string;
    overview: string;
    tagline: string;
    genres: string[];
    poster_path: string;
    backdrop_path: string;
    release_date: string;
    seasons: Season[];
    // prons
    title: string;
    detail: string;
    image_url: string;
    av_code: string;
};

type Episode = {
    id: string,
    name: string,
    poster_path: string,
    season_number: number,
    episode_number: number
}

type Season = {
    id: string,
    name: string,
    overview: string,
    poster_path: string,
    season_number: number,
    episodes: Episode[],
    release_date: string
}

// export type PornDataDetail = {
//     id: string;
//     title: string;
//     detail: string;
//     image_url: string;
//     av_code: string;
//     genres: string[];
// }
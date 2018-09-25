//
//  TMDBConstants.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 22/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

extension TMDBClient {
    
    struct Constants {
        static let ApiKey = "1f54bd990f1cdfb230adb312546d765d"
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let BaseImageURLString = "http://image.tmdb.org/t/p/"
        static let SecureBaseImageURLString =  "https://image.tmdb.org/t/p/"
        static let PosterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
        static let ProfileSizes = ["w45", "w185", "h632", "original"]
        static let MoviePerPage = 20
    }
    
    struct Methods {
        static let SearchMovie = "/search/movie"
        static let UpcomingMovies = "/movie/upcoming"
        static let MovieDetails = "/movie/{movie_id}"
        static let Genres = "/genre/movie/list"
    }
    
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let Query = "query"
        static let Page = "page"
        static let MovieID = "movie_id"
        static let AppendToResponse = "append_to_response"
    }
    
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
    }

    struct JSONResponseKeys {
        // Common Movies
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieBackdropPath = "backdrop_path"
        static let MovieReleaseDate = "release_date"
        static let MovieRuntime = "runtime"
        static let MovieVideos = "videos"
        
        // Upcoming Movies
        static let MovieGenres = "genre_ids"
        static let MovieResults = "results"
        static let MoviePages = "total_pages"

        // Movie Details
        static let MovieDetailsGenres = "genres"
        
        // Genres
        static let GenreID = "id"
        static let GenreName = "name"
        static let GenreResults = "genres"
        
        //Videos
        static let VideoSite = "site"
        static let VideoKey = "key"
        static let VideoResults = "results"
    }
    
    struct PosterSizes {
        static let RowPoster = Constants.PosterSizes[2]
        static let DetailPoster = Constants.PosterSizes[4]
    }
}

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
    }
    
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
    }

    struct JSONResponseKeys {
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MovieGenres = "genre_ids"
        static let MoviePosterPath = "poster_path"
        static let MovieBackdropPath = "backdrop_path"
        static let MovieReleaseDate = "release_date"
        static let MovieResults = "results"
        
        static let GenreID = "id"
        static let GenreName = "name"
        static let GenreResults = "genres"
    }
}

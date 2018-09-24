//
//  Movie.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 21/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import Foundation

class Movie {
    
    let id: Int?
    let title: String?
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let runtime: Int?
    var genreIds: Array<Int>?
    var genres: Array<Genre>?
    var genreNames: String {
        get {
            var names = [String]()
            if let genres = genres {
                _ = genres.map{ (genre) -> Void in
                    if let name = genre.name {
                        names.append(name)
                    }
                }
            }
            return names.joined(separator: ", ")
        }
    }
    
    
    init(dictionary: [String:AnyObject]) {
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as? Int
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as? String
        overview = dictionary["overview"] as? String
        releaseDate = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        runtime = dictionary[TMDBClient.JSONResponseKeys.MovieRuntime] as? Int
        if let genres = dictionary[TMDBClient.JSONResponseKeys.MovieGenres] as? Array<Int> {
            genreIds = genres
        } else {
            if let genresObject = dictionary[TMDBClient.JSONResponseKeys.MovieDetailsGenres] as? [[String:AnyObject]] {
                genres = Genre.genresFromResponse(genresObject)
            }
        }
        
    }
    
    
    static func moviesFromResponse(_ response: [[String:AnyObject]]) -> [Movie] {
        var movies = [Movie]()
        for dict in response {
            movies.append(Movie(dictionary: dict))
        }
        return movies
    }
    
}

extension Movie: Equatable {
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
}


class Genre {
    let id: Int?
    let name: String?
    
    init(dictionary: [String:AnyObject]) {
         id = dictionary[TMDBClient.JSONResponseKeys.GenreID] as? Int
        name = dictionary[TMDBClient.JSONResponseKeys.GenreName] as? String
    }
    
    static func genresFromResponse(_ response: [[String:AnyObject]]) -> [Genre] {
        var genres = [Genre]()
        for dict in response {
            genres.append(Genre(dictionary: dict))
        }
        return genres
    }
    
    
}


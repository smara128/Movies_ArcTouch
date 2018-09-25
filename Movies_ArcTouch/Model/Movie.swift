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
    var videos: Array<Video>?
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
    static var pages: Int?
    
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
        if let videoResults = dictionary[TMDBClient.JSONResponseKeys.MovieVideos] as? [String:AnyObject] {
            if let results = videoResults[TMDBClient.JSONResponseKeys.VideoResults] as? [[String:AnyObject]]{
                print(videoResults)
                videos = Video.videosFromResponse(results)
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


class Video {
    
    let site: String?
    let key: String?
    
    init(dictionary: [String:AnyObject]) {
        site = dictionary[TMDBClient.JSONResponseKeys.VideoSite] as? String
        key = dictionary[TMDBClient.JSONResponseKeys.VideoKey] as? String
    }
    
    static func videosFromResponse(_ response: [[String:AnyObject]]) -> [Video] {
        var videos = [Video]()
        for dict in response {
            videos.append(Video(dictionary: dict))
        }
        return videos
    }
}


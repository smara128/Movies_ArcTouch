//
//  TMDBClient.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 22/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import Foundation

class TMDBClient : NSObject {
    
    var session = URLSession.shared
    
    
    func getGenres(_ completionHandlerForGenres: @escaping (_ response: [Genre]?, _ error: NSError?) -> Void) -> URLSessionTask {
        let task = taskForGETMethod(Methods.Genres, parameters: nil) { (response, error) in
            if let error = error {
                completionHandlerForGenres(nil, error)
            } else {
                if let response = response?[TMDBClient.JSONResponseKeys.GenreResults] as? [[String:AnyObject]] {
                    let genres = Genre.genresFromResponse(response)
                    completionHandlerForGenres(genres, nil)
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't parsed the json genres key."]
                    let error = NSError(domain: "convertData", code: 2, userInfo: [NSLocalizedDescriptionKey: userInfo])
                    completionHandlerForGenres(nil, error)
                }
            }
        }
        return task
    }
    
    func getUpcomingMovies(forPage page: Int = 1, _ completionHandlerForUpcomingMovies: @escaping (_ response: [Movie]?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let parameters = [TMDBClient.ParameterKeys.Page:page as AnyObject]
        
        let task = taskForGETMethod(Methods.UpcomingMovies, parameters: parameters) { (response, error) in
            if let error = error {
                completionHandlerForUpcomingMovies(nil, error)
            } else {
                if let response = response?[TMDBClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
                    let movies = Movie.moviesFromResponse(response)
                    completionHandlerForUpcomingMovies(movies, nil)
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't parsed the json results key."]
                    let error = NSError(domain: "convertData", code: 1, userInfo: [NSLocalizedDescriptionKey: userInfo])
                    completionHandlerForUpcomingMovies(nil, error)
                }
            }
        }
        return task
    }
    
    func getMovieDetails(forId id: Int, _ completionHandlerForMovieDetails: @escaping (_ response: Movie?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let parameters = [TMDBClient.ParameterKeys.AppendToResponse:"videos" as AnyObject]
        
        let mutableMethod: String = substituteKeyInMethod(TMDBClient.Methods.MovieDetails, key: TMDBClient.ParameterKeys.MovieID, value: "\(id)")!
        
        let task = taskForGETMethod(mutableMethod, parameters: parameters) { (response, error) in
            if let error = error {
                completionHandlerForMovieDetails(nil, error)
            } else {
                if let response = response as? [String:AnyObject] {
                    let movie = Movie(dictionary: response)
                    completionHandlerForMovieDetails(movie, nil)
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't parsed the json results key."]
                    let error = NSError(domain: "convertData", code: 1, userInfo: [NSLocalizedDescriptionKey: userInfo])
                    completionHandlerForMovieDetails(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    func getMoviesForSearchString(_ searchString: String, completionHandlerForMovies: @escaping (_ result: [Movie]?, _ error: NSError?) -> Void) -> URLSessionTask? {
        
        let parameters = [TMDBClient.ParameterKeys.Query: searchString]
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters as [String:AnyObject]) { (results, error) in
            if let error = error {
                completionHandlerForMovies(nil, error)
            } else {
                if let results = results?[TMDBClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
                    let movies = Movie.moviesFromResponse(results)
                    completionHandlerForMovies(movies, nil)
                } else {
                    completionHandlerForMovies(nil, NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        return task
    }
    
    // Mark: Base Requests
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, completionHandlerForGET: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let url = urlFromParameters(parameters, withPathExtension: method)
        print(url.absoluteString)
        let request = NSMutableURLRequest(url: url)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convert(data, completionHadlerForData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    
    func taskForGETImage(_ size: String, filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let baseURL = URL(string: TMDBClient.Constants.SecureBaseImageURLString)!
        let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            completionHandlerForImage(data, nil)
        }
        task.resume()
        return task
    }
    
    private func urlFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        
        components.scheme = TMDBClient.Constants.ApiScheme
        components.host = TMDBClient.Constants.ApiHost
        components.path = TMDBClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        let queryItem = URLQueryItem(name: ParameterKeys.ApiKey, value: Constants.ApiKey)
        components.queryItems?.append(queryItem)
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    private func convert(_ data: Data, completionHadlerForData:(_ response: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResponse: AnyObject? = nil
        do {
            parsedResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            print(parsedResponse!)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            let parseError = NSError(domain: "converData", code: 0, userInfo: userInfo)
            completionHadlerForData(nil, parseError)
        }
        completionHadlerForData(parsedResponse, nil)
    }
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Mark: Shared
    class func sharedInstance() -> TMDBClient {
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        return Singleton.sharedInstance
    }
}

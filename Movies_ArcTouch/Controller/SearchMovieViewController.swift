//
//  SearchMovieViewController.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 24/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    let searchCellId = "searchCell"
    var movies = [Movie]()
    var allUpcomingMovies = [Movie]()
    var allGenres = [Genre]()
    var searchTask: URLSessionTask?
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = TMDBClient.sharedInstance().getGenres { (genres, error) in
            if let genres = genres {
                self.allGenres = genres
                _ = TMDBClient.sharedInstance().getUpcomingMovies(forPage: self.page, { (movies, error) in
                    if let movies = movies {
                        self.allUpcomingMovies.append(contentsOf: movies)
                    }
                })
            }
        }
    }


    // Mark: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let task = searchTask {
            task.cancel()
        }
        
        if searchText == "" {
            movies = [Movie]()
            movieTableView?.reloadData()
            return
        }
        
        filter(searchText)
    }
    
    func filter(_ searchText: String) {
        movies = allUpcomingMovies.filter { (movie) -> Bool in
            if let title = movie.title, title.contains(searchText) {
                return true
            } else {
                return false
            }
        }
        
        if movies.count > 0 {
            movieTableView.reloadData()
        } else {
            if Movie.pages != nil, page <= Movie.pages! {
                getMoreMovies(for: page) { (movies, error) in
                    if let movies = movies {
                        DispatchQueue.main.async {
                            self.allUpcomingMovies.append(contentsOf: movies)
                            self.filter(searchText)
                        }
                        
                    }
                }
            }
        }
    }
    
    func getMoreMovies(for page: Int, _ completionHandler: @escaping (_ response: [Movie]?, _ error: NSError?) -> Void) {
        if allUpcomingMovies.count <= TMDBClient.Constants.MoviePerPage * page {
            self.page += 1
            searchTask = TMDBClient.sharedInstance().getUpcomingMovies(forPage: self.page) { (movies, error) in
                if let movies = movies {
                    print("Loading page \(self.page)")
                    completionHandler(movies, nil)
                }
            }
            
        }
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    
    // Mark: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId) as! MovieListTableViewCell
        
        let movie = self.movies[indexPath.row]
        
        cell.movieNameLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        cell.overviewLabel.setContentOffset(CGPoint.zero, animated: false)

        if let genres = movie.genreIds {
            cell.genresLabel.text = formatGenres(genres)
        }
        if let date = movie.releaseDate {
            cell.releaseDateLabel.text = formatDate(date)
        }

        if let posterPath = movie.posterPath {
            let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.backdropImageView.image = image
                    }
                } else {
                    print(error ?? "empty error")
                }
            })
        }
        
        return cell
    }
    
   
    // Mark: Display formatters
    func formatDate(_ dateIn: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-mm-dd"
        
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMM dd, yyyy"
        
        if let dateOut = dateFormatterGet.date(from: dateIn) {
            return dateFormatterDisplay.string(from:dateOut)
        } else {
            print("Error decoding string")
            return dateIn
        }
    }
    
    func formatGenres(_ genreIds: Array<Int>) -> String {
        var names = [String]()
        _ = genreIds.map { (id) -> Void in
            if let genre = self.allGenres.filter({ $0.id == id }).first {
                if let name = genre.name {
                    names.append(name)
                }
            }
        }
        return names.joined(separator: ", ")
    }

    
}


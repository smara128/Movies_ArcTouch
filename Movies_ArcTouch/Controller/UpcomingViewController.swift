//
//  UpcomingViewController.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 21/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    let upcomingCellId = "upcomingCell"
    var upcomingMovies: [Movie]?
    var allGenres: [Genre]?
    var searchTask: URLSessionDataTask?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = TMDBClient.sharedInstance().getGenres { (allGenres, error) in
            if let allGenres = allGenres {
                self.allGenres = allGenres
                _ = TMDBClient.sharedInstance().getUpcomingMovies(forPage: 1) { (movies, error) in
                    if let movies = movies {
                        self.upcomingMovies = movies
                        DispatchQueue.main.async {
                            self.upcomingTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let destination = segue.destination as? MovieDetailsViewController {
                if let cell = sender as? UITableViewCell, let indexPath = upcomingTableView.indexPath(for: cell) {
                    destination.movieId = upcomingMovies?[indexPath.row].id
                }
            }
        }
    }
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        let height = searchBar.frame.size.height
        self.searchBarTopConstraint.constant = self.searchBarTopConstraint.constant == -height ? CGFloat(0) : -height
        UIView .animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    

    // Mark: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcomingMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((indexPath.row + 1) % TMDBClient.Constants.MoviePerPage == 0) {
            getMoreMovies(for: ((indexPath.row + 1)/TMDBClient.Constants.MoviePerPage))
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: upcomingCellId, for: indexPath) as! MovieListTableViewCell
        guard let movie = self.upcomingMovies?[indexPath.row] else {
            return cell
        }
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
    
    
    func getMoreMovies(for page: Int) {
        if let moviesCount = upcomingMovies?.count {
            if moviesCount <= TMDBClient.Constants.MoviePerPage * page {
                let nextPage = page + 1
                print("Loading page \(nextPage)")
                _ = TMDBClient.sharedInstance().getUpcomingMovies(forPage: nextPage) { (movies, error) in
                    if let movies = movies {
                        self.upcomingMovies?.append(contentsOf: movies)
                        DispatchQueue.main.async {
                            self.upcomingTableView.reloadData()
                        }
                    }
                }
            }
        }
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
            if let genre = self.allGenres?.filter({ $0.id == id }).first {
                if let name = genre.name {
                    names.append(name)
                }
            }
        }
        return names.joined(separator: ", ")
    }
    
}

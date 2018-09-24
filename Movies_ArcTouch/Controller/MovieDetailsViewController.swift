//
//  MovieDetailsViewController.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 23/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet var rating: [UIImageView]!
    
    var movieId: Int?
    var movie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = movieId {
            _ = TMDBClient.sharedInstance().getMovieDetails(forId: id, { (movie, error) in
                if let movie = movie {
                    self.movie = movie
                    DispatchQueue.main.async {
                        self.setupViews()
                    }
                }
            })
        }
    }

    func setupViews() {
        if let movie = movie {
            nameLabel.text = movie.title
            overviewTextView.text = movie.overview
            durationLabel.text = movie.runtime != nil ? "\(movie.runtime!) min" : ""
            if let posterPath = movie.posterPath {
                let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                    if let imageData = imageData, let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.backdropImageView.image = image
                        }
                    } else {
                        print(error ?? "empty error")
                    }
                })
            }
            genresLabel.text = movie.genreNames
        }
        
    }
    
   

}

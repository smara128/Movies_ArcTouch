//
//  UpcomingViewController.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 21/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var upcomingTableView: UITableView!
    
    let upcomingCellId = "upcomingCell"
    var upcomingMovies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TMDBClient.sharedInstance().getUpcomingMovies { (movies, error) in
            if let movies = movies {
                self.upcomingMovies = movies
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
            }
        }
    }
    
    // Mark: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcomingMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: upcomingCellId, for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    

    
    
}

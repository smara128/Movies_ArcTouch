//
//  MovieListTableViewCell.swift
//  Movies_ArcTouch
//
//  Created by Silvia Florido on 22/09/18.
//  Copyright © 2018 Silvia Florido. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  WatchListTableViewCell.swift
//  WikiFilms
//
//  Created by Nil Bagaria Nofre on 21/1/26.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 2
        
        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ratingLabel.textColor = .systemYellow
    }
}

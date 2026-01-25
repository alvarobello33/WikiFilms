//
//  PopularCollectionViewCell.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/12/25.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMovie.layer.cornerRadius = 15
        imgMovie.clipsToBounds = true
    }
    

}

//
//  TopMoviesCollectionViewCell.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/12/25.
//

import UIKit

class TopMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberTopMovie: UILabel!
    
    @IBOutlet weak var imgTopMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imgTopMovie.layer.cornerRadius = 15
        imgTopMovie.clipsToBounds = true
    }
    

}

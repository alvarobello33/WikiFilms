//
//  PopularTableViewCell.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/1/26.
//

import UIKit
import SDWebImage

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    private var movies: [TMDBMovie] = []
    
    
    // Closure que avisará al HomeController cuando se pulse una película
    var onMovieSelected: ((TMDBMovie) -> Void)?

    func configure(title: String, movies: [TMDBMovie]) {
        self.movies = movies
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        //Registrem la collection personalitzada
        collectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularCollectionCell")
        
    }

}

extension PopularTableViewCell: UICollectionViewDataSource {
    
    //Nombre de items de la collection (tants com movies hi ha)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    //Carregar la collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PopularCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionCell", for: indexPath) as! PopularCollectionViewCell
        cell.backgroundColor = .clear
        
        //Obtenim la movie que correspon
        let movie = movies[indexPath.item]
        
        // Carreguem imatge
        if let poster = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            cell.imgMovie.sd_setImage(with: url,
                                      placeholderImage: UIImage(named: "poster_placeholder"))
        } else {
            cell.imgMovie.image = UIImage(named: "poster_placeholder")
        }
        
        return cell
    }
}

extension PopularTableViewCell: UICollectionViewDelegateFlowLayout {
    
    //Ajustar tamany de les celes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 200)
    }

    
    //Definim espaiat entre columnes (elements)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    //Espaiat entre files (elements)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // Detectamos cuando se pulse una celda
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        onMovieSelected?(movie)  // Avisamos al HomeController
    }
    

}



//
//  TopMoviesTableViewCell.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/1/26.
//

import UIKit
import SDWebImage

class TopMoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionTopMovies: UICollectionView!
    
    private var movies: [TMDBMovie] = []
    
    
    // Closure que avisará al HomeController cuando se pulse una película
    var onMovieSelected: ((TMDBMovie) -> Void)?
    
    func configure(title: String, movies: [TMDBMovie]) {
        self.movies = movies
        collectionTopMovies.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionTopMovies.delegate = self
        collectionTopMovies.dataSource = self
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        collectionTopMovies.backgroundColor = .clear
        
        //Registrem la collection personalitzada
        collectionTopMovies.register(UINib(nibName: "TopMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopMoviesCollectionCell")
        
        // Hacer que las celdas tengan tamaño automático
        if let layout = collectionTopMovies.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

}


extension TopMoviesTableViewCell: UICollectionViewDataSource {
    
    //Nombre de items de la collection (tants com movies hi ha)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    //Carregar la collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TopMoviesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopMoviesCollectionCell", for: indexPath) as! TopMoviesCollectionViewCell
        cell.backgroundColor = .clear
        
        //Obtenim la movie que correspon
        let movie = movies[indexPath.item]
        
        cell.numberTopMovie.text = "\(indexPath.item + 1)"
        
        //Carreguem imatge
        if let poster = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            cell.imgTopMovie.sd_setImage(with: url,
                                      placeholderImage: UIImage(named: "poster_placeholder"))
        } else {
            cell.imgTopMovie.image = UIImage(named: "poster_placeholder")
        }
        
        return cell
    }
}

extension TopMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    //Definim espaiat entre columnes (elements)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    //Espaiat entre files (elements)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    //Detectem al premer una cel·la
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        onMovieSelected?(movie)  //Avisem al HomeController
    }
}

//
//  SearchViewController.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 24/1/26.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var movies: [TMDBMovie] = []
    var selectedMovie: TMDBMovie?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Barra de search
        searchBar.barTintColor = UIColor(red: 70/255, green: 70/255, blue: 75/255, alpha: 1)
        searchBar.searchTextField.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 75/255, alpha: 1)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        
        searchBar.delegate = self
        
        
        //Collection
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        
        collection.register(
            UINib(nibName: "PopularCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "PopularCollectionCell"
        )
        
        loadPopularMovies()
    }
    
    //De inicio mostramos las pelis populares para no tener la vista vacía
    private func loadPopularMovies() {

        TMDBClient.shared.getPopularMovies { result in
            
            switch result {
            case .success(let movies):
                self.movies = movies
                self.collection.reloadData()
                
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    //Funcion para navegar a detalles de la pelicula
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDetail" {
            if let destinationVC = segue.destination as? MovieDetailViewController {
                destinationVC.movie = selectedMovie
            }
        }
    }
    

}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        //Si no hay texto de buscar, mostramos populares otra vez
        if text.isEmpty {
            loadPopularMovies()
            return
        }

        TMDBClient.shared.searchMovies(query: text) { result in
            switch result {
            case .success(let movies):
                print(movies)
                self.movies = movies
                self.collection.reloadData()

            case .failure(let error):
                print("Search error:", error)
            }
        }
    }
    
    //Cierra el teclado al pulsar search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}


extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PopularCollectionCell",
            for: indexPath
        ) as! PopularCollectionViewCell

        let movie = movies[indexPath.item]

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

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    //Detectamos cuando se pulse una celda
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.item]
        performSegue(withIdentifier: "searchToDetail", sender: nil)
    }
}

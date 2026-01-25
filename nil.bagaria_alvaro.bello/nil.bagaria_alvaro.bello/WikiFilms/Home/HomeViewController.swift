//
//  HomeViewController.swift
//  WikiFilms
//
//  Created by user282659 on 12/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeListTable: UITableView!
    
    var topRatedMovies: [TMDBMovie] = []
    var popularMovies: [TMDBMovie] = []
    
    var selectedMovie: TMDBMovie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Registrem la cel·la personalitzada de TopMovies
        homeListTable.register(UINib(nibName: "TopMoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "TopMoviesListCell")
        
        //Registrem la cel·la personalitzada de Popular Movies
        homeListTable.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularListCell")
        
        homeListTable.dataSource = self
        homeListTable.delegate = self
        
        homeListTable.backgroundColor = .clear
        
        
        loadMovies()
    }
    
    private func loadMovies() {
        TMDBClient.shared.getTopRatedMovies { result in
            switch result {
            case .success(let movies):
                print(movies)
                self.topRatedMovies = movies
                self.homeListTable.reloadData()
            case .failure(let error):
                print("Error:", error)
            }
        }
    

        TMDBClient.shared.getPopularMovies { result in
            
            switch result {
            case .success(let movies):
                
                self.popularMovies = movies
                self.homeListTable.reloadData()
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    //Funcion para navegar a detalles de la pelicula
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            if let destinationVC = segue.destination as? MovieDetailViewController {
                destinationVC.movie = selectedMovie
            }
        }
    }


    
}

// MARK: Table Data Source
extension HomeViewController: UITableViewDataSource {

    //2 Secciones (topMovies) (populaarMovies)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //1 fila (collection)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1

    }
    
    //MARK: Creació de la cel·la
    //Crea automaticament una cel·la i/o reutilitza una existent si pot i ens la retorna
    //Minim sempre (des de l'apartat visual) a la Prototype li hem de posar 1.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //(0) Carreguem cela Collection de TopMovies
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopMoviesListCell", for: indexPath) as! TopMoviesTableViewCell
            
            cell.configure(title: NSLocalizedString("top_rated", comment: ""), movies: topRatedMovies)
            cell.onMovieSelected = { [weak self] movie in
                self?.selectedMovie = movie
                self?.performSegue(withIdentifier: "showMovieDetails", sender: nil)
            }
            
            return cell
            
            
        } else {
            //(1) Carreguem cela Collection de PopularMovies
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularListCell", for: indexPath) as! PopularTableViewCell
            
            cell.configure(title: NSLocalizedString("popular", comment: ""), movies: popularMovies)
            cell.onMovieSelected = { [weak self] movie in
                self?.selectedMovie = movie
                self?.performSegue(withIdentifier: "showMovieDetails", sender: nil)
            }
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 64 : 0
    }

    
    //Format titol seccio
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            //Definim una vista buida pel header de cada seccio
            let headerView = UIView()
            headerView.backgroundColor = .clear

            //Definim el label (titol seccio)
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            //Assignem la font i l'estil de la lletra
            label.font = UIFont(name: "DIN Condensed Bold", size: 32)
            label.textColor = .white
            
            //Seleccionem el titol del header
            label.text = NSLocalizedString("top_rated_movies", comment: "")
            
            //Afegim el label a la vista
            headerView.addSubview(label)

            //Afegim constraints als titols de seccio
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 2),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
            ])
            
            //retornem la vista que conté el titol de seccio
            return headerView
        }
        return nil
        
    }
}


// MARK: Table Delegate
extension HomeViewController: UITableViewDelegate {
    
    //tamaño sección
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let totalHeight = tableView.bounds.height
        if indexPath.section == 0 {
            //Top Movies
            return totalHeight * 0.3
        } else {
            //Popular Movies (Dinamico)
            let items = popularMovies.count
                    
            //Ancho items (considerando padding de la collectionView)
            let collectionViewWidth = tableView.bounds.width - 32 // 16 pts padding a cada lado
            
            let itemWidth: CGFloat = 150
            let spacing: CGFloat = 16
            
            //Calculamos cuantos items caben por fila segun ancho
            let itemsPerRow = max(Int((collectionViewWidth + spacing) / (itemWidth + spacing)), 1)
            
            //Num de filas necesarias
            let rows = 1 + ceil(Double(items) / Double(itemsPerRow))
            
            let itemHeight: CGFloat = 200
            
            return CGFloat(rows) * itemHeight + CGFloat(rows - 1) * spacing + 16 // padding entre filas
                
        }
        
    }

    
    //Funcio per detectar el click a una cel·la de la taula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("Row Selected: \(indexPath.row)")
        
        
    }
     
}

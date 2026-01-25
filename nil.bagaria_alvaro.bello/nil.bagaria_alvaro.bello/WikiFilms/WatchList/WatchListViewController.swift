//
//  WatchListViewController.swift
//  WikiFilms
//
//  Created by user282659 on 1/18/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

struct WatchListMovie {
    let id: Int
    let title: String
    let posterPath: String
    let rating: Double
    let overview: String
    let backdropPath: String
}

class WatchListViewController: UIViewController {

    @IBOutlet weak var tableViewWatchList: UITableView!
    
    var movies: [WatchListMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewWatchList.delegate = self
        tableViewWatchList.dataSource = self
        
        tableViewWatchList.rowHeight = 110
        tableViewWatchList.separatorStyle = .none
        
        loadWatchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWatchList()
    }
    
    func loadWatchList() {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let database = Firestore.firestore()
        
        database.collection("users").document(userID).collection("watchlist").getDocuments { snapshot, error in
            
            if error != nil {
                print("Error loading WatchList.")
                return
            }
            
            self.movies = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                    
                return WatchListMovie(
                    id: data["id"] as? Int ?? 0,
                    title: data["title"] as? String ?? "",
                    posterPath: data["poster_path"] as? String ?? "",
                    rating: data["vote_average"] as? Double ?? 0.0,
                    overview: data["overview"] as? String ?? "",
                    backdropPath: data["backdrop_path"] as? String ?? "",
                )
            } ?? []
            
            //Recarreguem la vista
            DispatchQueue.main.async {
                self.tableViewWatchList.reloadData()
            }
        }
    }
    
    //Funcio per eliminar
    func deleteMovie(at indexPath: IndexPath){
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let movie = movies[indexPath.row]
        let database = Firestore.firestore()
        
        database.collection("users").document(userID).collection("watchlist").document(String(movie.id)).delete { error in
            if error != nil{
                self.showAlert(title: "Error", message: NSLocalizedString("delete_error", comment: ""))
            }
            
            //Si va be, eliminem de l'array local
            self.movies.remove(at: indexPath.row)
            
            //actualitzem la taula
            DispatchQueue.main.async{
                self.tableViewWatchList.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    //Funcio per mostrar alertes
    func showAlert(title: String, message: String) {
        let saveChangesAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default)
        saveChangesAlert.addAction(acceptAction)
        
        present(saveChangesAlert, animated: true)
    }
}

extension WatchListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchListCell", for: indexPath) as! WatchListTableViewCell
        
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.ratingLabel.text = "★ \(String(format: "%.1f", movie.rating))"
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)") {
            cell.posterImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "Movie_Image"))
        }
        
        return cell
    }
    
    //Opcio per eliminar (swipe)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            deleteMovie(at: indexPath)
        }
    }
    
    //Segue cap a detais de la peli
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "watchListToDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Preparem dades per el canvi d vista (segue)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "watchListToDetail",
           let indexPath = sender as? IndexPath,
           let destination = segue.destination as? MovieDetailViewController {
            
            let watchListMovie = movies[indexPath.row]
            
            //convertim watchListMovie a TMDBMovie per la vista detallada des de la watchlist
            let movie = TMDBMovie(
                id: watchListMovie.id,
                title: watchListMovie.title,
                overview: watchListMovie.overview,
                poster_path: watchListMovie.posterPath,
                release_date: nil,
                vote_average: watchListMovie.rating,
                backdrop_path: watchListMovie.backdropPath
            )
            
            destination.movie = movie
            
        }
    }
}

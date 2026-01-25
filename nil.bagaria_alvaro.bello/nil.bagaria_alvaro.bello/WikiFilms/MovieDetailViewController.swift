//
//  MovieDetailViewController.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 20/1/26.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseFirestore

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movie: TMDBMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        //titleLabel.text = movie?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func configureView(){
        
        guard let movie = movie else { return }
        
        //titol
        titleLabel.text = movie.title
                
        //sinopsis
        overviewTextView.text = movie.overview
        overviewTextView.isEditable = false
        overviewTextView.isScrollEnabled = true
        
        //imatge
        if let poster_path = movie.poster_path {
            let posterURL  = URL (string: "https://image.tmdb.org/t/p/w500\(poster_path)")
            posterImage.sd_setImage(with: posterURL, placeholderImage: UIImage(systemName: "Movie_Image"))
        }  else {
            //Icona generica si no hi ha poster
            posterImage.image = UIImage(systemName: "film")
            posterImage.contentMode = .scaleAspectFit
            posterImage.tintColor = UIColor.white.withAlphaComponent(0.5)
        }
        
        //Background imatge
        if let backdropPath = movie.backdrop_path, !backdropPath.isEmpty,
           let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)") {

            backgroundImage.sd_setImage(with: backdropURL)

        } else if let posterPath = movie.poster_path, !posterPath.isEmpty,
                  let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {

            backgroundImage.sd_setImage(with: posterURL)

        } else {
            //Fons neutre si no hi ha cap imatge
            backgroundImage.image = UIImage(systemName: "film")
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.tintColor = UIColor.white.withAlphaComponent(0.15)
        }
        
        //Estetica del poster
        posterImage.layer.cornerRadius = 12
        posterImage.layer.masksToBounds = true
        posterImage.layer.borderWidth = 0.5
        posterImage.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor //blanc amb 20% opacitat
        
        //Estetica backdrop
        backgroundImage.layer.cornerRadius = 20
        backgroundImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        backgroundImage.clipsToBounds = true
        
        //Text overview
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        overviewTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        //Rating
        let rating = movie.vote_average
        
        //text + icona
        ratingLabel.text = "★ \(String(format: "%.1f", rating))"
        ratingLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        ratingLabel.alpha = 0.9
        
        //Calculem color segons la nota
        switch rating {
        case 8.5...10.0:
            ratingLabel.textColor = .systemGreen
        case 6.5..<8.5:
            ratingLabel.textColor = .systemYellow
        case 5.0..<6.5:
            ratingLabel.textColor = .systemOrange
        default:
            ratingLabel.textColor = .systemRed
        }
       
    }
    
    //Funcionalitat boto per guardar a la WatchList de l'usuari
    @IBAction func saveToWatchListButton(_ sender: UIButton) {
        
        guard let movie = movie else { return }
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let database = Firestore.firestore()
        
        let movieData: [String: Any] = [
            "id": movie.id,
            "title": movie.title,
            "overview": movie.overview,
            "poster_path": movie.poster_path ?? "",
            "vote_average": movie.vote_average,
            "backdrop_path": movie.backdrop_path ?? ""
        ]
        
        database.collection("users").document(userID).collection("watchlist").document(String(movie.id)).setData(movieData) { error in
            
            if error != nil {
                self.showAlert(title: "Error", message: NSLocalizedString("not_saved", comment: ""))
            } else {
                self.showAlert(title: NSLocalizedString("saved", comment: ""), message: NSLocalizedString("added_watchlist", comment: ""))
            }
        }
    }
    
    //Funcio per alertes
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default))
        present(alert, animated: true)
    }
    

}

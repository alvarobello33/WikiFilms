//
//  TMDBClient.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/12/25.
//

import Foundation
import Alamofire

public final class TMDBClient {

    public static let shared = TMDBClient()

    private init() {}

    public func getTopRatedMovies(
        completion: @escaping (Result<[TMDBMovie], Error>) -> Void
    ) {
        AF.request(TMDBRouter.topRated)
            .validate()
            .responseDecodable(of: TMDBMovieResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    public func getPopularMovies(
        completion: @escaping (Result<[TMDBMovie], Error>) -> Void
    ) {
        
        var allMovies: [TMDBMovie] = []
        let group = DispatchGroup()

        for page in 1...4 {
            group.enter()
            AF.request(TMDBRouter.popular(page: page))
                .validate()
                .responseDecodable(of: TMDBMovieResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        allMovies.append(contentsOf: data.results)
                    case .failure(let error):
                        print("Error on popular page \(page):", error)
                    }
                    group.leave()
                }
        }

        group.notify(queue: .main) {
            completion(.success(allMovies))
        }
    }

    public func searchMovies(
        query: String,
        completion: @escaping (Result<[TMDBMovie], Error>) -> Void
    ) {
        
        var allMovies: [TMDBMovie] = []
        let group = DispatchGroup()

        for page in 1...8 {
            group.enter()
            AF.request(TMDBRouter.search(query: query, page: page))
                .validate()
                .responseDecodable(of: TMDBMovieResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        allMovies.append(contentsOf: data.results)
                    case .failure(let error):
                        print("Error on search page \(page):", error)
                    }
                    group.leave()
                }
        }

        group.notify(queue: .main) {
            completion(.success(allMovies))
        }

    }
}


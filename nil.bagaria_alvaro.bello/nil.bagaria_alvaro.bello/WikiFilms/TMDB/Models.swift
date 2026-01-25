//
//  Models.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/12/25.
//

import Foundation

nonisolated public struct TMDBMovieResponse: Decodable, Sendable {
    public let page: Int
    public let results: [TMDBMovie]
}

nonisolated public struct TMDBMovie: Decodable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let poster_path: String?
    public let release_date: String?
    public let vote_average: Double
    public let backdrop_path: String?
}

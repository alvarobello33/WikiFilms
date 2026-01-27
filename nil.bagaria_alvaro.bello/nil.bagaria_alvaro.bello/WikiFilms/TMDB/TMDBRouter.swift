//
//  TMDBRouter.swift
//  WikiFilms
//
//  Created by Alvaro Bello Garrido on 22/12/25.
//

import Foundation
import Alamofire

enum TMDBRouter: URLRequestConvertible {

    static let baseURL = "https://api.themoviedb.org/3"
    static let bearerToken = CHANGE_FOR_YOUR_TMDB_TOKEN
    
    //Escollim idioma per les peticions (i traduccions)
    private var tmdbLanguage: String {
        switch Locale.current.language.languageCode?.identifier {
        case "es":
            return "es-ES"
        default:
            return "en-US"
        }
    }

    case topRated
    case popular(page: Int = 1)
    case search(query: String, page: Int = 1)

    var method: HTTPMethod { .get }

    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .topRated:
            return "/movie/top_rated"
        case .search:
            return "/search/movie"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .popular(let page):
            return [
                "page": page,
                "language": tmdbLanguage
            ]
        case .topRated:
            return [
                "page": 1, //Siempre página 1
                "language": tmdbLanguage
            ]
        case .search(let query, let page):
            return [
                "query": query,
                "page": page,
                "language": tmdbLanguage
            ]
        }
    }


    func asURLRequest() throws -> URLRequest {
        let url = try Self.baseURL.asURL()
        
        //Anadimos path al urlRequest
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method

        //Anaadimos token al urlRequest
        request.setValue("Bearer \(Self.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")

        //Anadimos parametros al urlRequest
        return try URLEncoding.default.encode(request, with: parameters)
    }
}


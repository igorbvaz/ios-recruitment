//
//  Endpoints.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//
import Foundation

protocol Endpoint {
    var url: URL? { get }
}

struct API {
    static let scheme = "https"
    static let baseUrl = "api.github.com"
}

class Endpoints {

    static func buildURL(path: String, queryItems: [URLQueryItem] = [URLQueryItem]()) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.baseUrl
        components.path = path
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "per_page", value: "20"))
        return components.url
    }

    enum Users: Endpoint {
        case getUsers(lastUserId: Int)
        case searchUsers(searchText: String, page: Int)
        case getUser(userLogin: String)
        case repositories(userLogin: String, page: Int)

        var url: URL? {
            switch self {
            case .getUsers(let lastUserId):
                return buildURL(path: "/users", queryItems: [URLQueryItem(name: "since", value: "\(lastUserId)")])
            case .searchUsers(let searchText, let page):
                return buildURL(path: "/search/users", queryItems: [URLQueryItem(name: "q", value: searchText), URLQueryItem(name: "page", value: "\(page)")])
            case .getUser(let userLogin):
                return buildURL(path: "/users/\(userLogin)")
            case .repositories(let userLogin, let page):
                return buildURL(path: "/users/\(userLogin)/repos", queryItems: [URLQueryItem(name: "page", value: "\(page)")])
            }
        }
    }

}


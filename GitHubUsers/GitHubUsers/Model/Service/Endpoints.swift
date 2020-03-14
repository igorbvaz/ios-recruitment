//
//  Endpoints.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

struct API {
    static let baseUrl = "https://api.github.com"
}

class Endpoints {

    private static func getUrl(path: String) -> String {
        return "\(API.baseUrl)\(path)"
    }

    enum Users: Endpoint {
        case getUsers(offset: Int)
        case searchUsers(searchText: String, page: Int)
        case getUser(userLogin: String)
        case repositories(userLogin: String, page: Int)

        var path: String {
            switch self {
            case .getUsers(let offset):
                return "/users?since=\(offset)&per_page=20"
            case .searchUsers(let searchText, let page):
                return "/search/users?q=\"\(searchText)\"page=\(page)&per_page=20"
            case .getUser(let userLogin):
                return "/users/\(userLogin)"
            case .repositories(let userLogin, let page):
                return "/users/\(userLogin)/repos?page=\(page)&per_page=20"
            }
        }

        var url: String {
            return Endpoints.getUrl(path: path)
        }
    }

}


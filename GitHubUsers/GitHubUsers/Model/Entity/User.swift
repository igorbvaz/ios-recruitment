//
//  User.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

struct User: Decodable {
    var login: String
    var id: Int
    var avatar_url: String
    var gravatar_id: String
    var url: String
    var name: String
    var company: String
    var location: String
    var email: String
    var bio: String
    var public_repos: Int
    var public_gists: Int
    var followers: Int
    var following: Int
}

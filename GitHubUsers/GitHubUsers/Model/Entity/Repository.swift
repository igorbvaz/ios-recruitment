//
//  Repository.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class Repository: Decodable {
    var id: Int
    var node_id: String
    var name: String
    var full_name: String
    var `private`: Bool
    var owner: BasicUser
    var html_url: String
    var description: String
}

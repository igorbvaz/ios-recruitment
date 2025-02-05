//
//  Repository.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

struct Repository: Decodable {
    var id: Int
    var name: String
    var description: String?
    var stargazers_count: Int
}

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
    var full_name: String
    var `private`: Bool
    var description: String
}

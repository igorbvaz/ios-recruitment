//
//  BasicUser.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

struct BasicUser: Decodable {
    var login: String
    var id: Int
    var avatar_url: String
}

//
//  SearchUsersResponse.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class SearchUsersResponse: Decodable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [BasicUser]
}

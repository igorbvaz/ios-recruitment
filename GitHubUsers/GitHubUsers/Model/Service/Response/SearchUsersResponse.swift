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

    init(total_count: Int, incomplete_results: Bool, items: [BasicUser]) {
        self.total_count = total_count
        self.incomplete_results = incomplete_results
        self.items = items
    }
}

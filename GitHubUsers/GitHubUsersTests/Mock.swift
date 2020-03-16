//
//  Mock.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 14/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import Foundation

class Mock {
    static let string = "string"
    static let int = 10
    static let bool = false
    static var error: Error = NSError(domain: "", code: 404, userInfo: nil)
}

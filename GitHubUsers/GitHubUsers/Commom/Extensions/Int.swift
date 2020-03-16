//
//  Int.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import Foundation

extension Int {
    func toK() -> String {
        if self >= 1000 {
            return "\(self / 1000)K"
        } else {
            return "\(self)"
        }
    }
}

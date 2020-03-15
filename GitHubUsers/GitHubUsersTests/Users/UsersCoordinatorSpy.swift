//
//  UsersCoordinatorSpy.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 14/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
@testable import GitHubUsers

class UsersCoordinatorSpy: UsersCoordinatorProtocol {
    var navigationController: UINavigationController

    var didRouteToDetails = false

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func route(path: CoordinatorPath) {
        guard let path = path as? UsersPath else { return }
        switch path {
        case .details:
            didRouteToDetails = true
        }
    }


}

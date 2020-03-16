//
//  AppCoordinatorSpy.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
@testable import GitHubUsers
class AppCoordinatorSpy: AppCoordinatorProtocol {
    var navigationController: UINavigationController

    var didRouteToUsers = false

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}

    func route(path: CoordinatorPath) {
        guard let path = path as? AppPath else { return }
        switch path {
        case .users:
            didRouteToUsers = true
        }
    }


}

//
//  AppCoordinator.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let usersCoordinator = UsersCoordinator(navigationController: navigationController)
        usersCoordinator.start()
    }

    func route(path: CoordinatorPath) {}
}

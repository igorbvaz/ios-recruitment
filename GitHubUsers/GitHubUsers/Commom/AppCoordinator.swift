//
//  AppCoordinator.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {}

enum AppPath: CoordinatorPath {
    case users
}
class AppCoordinator: AppCoordinatorProtocol {
    var navigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let logoViewController = LogoViewController(viewModel: LogoViewModel(coordinator: self))
        navigationController.navigationBar.transparent = true
        navigationController.pushViewController(logoViewController, animated: false)
    }

    func route(path: CoordinatorPath) {
        guard let path = path as? AppPath else { return }
        switch path {
        case .users:
            let navigationController = UINavigationController()
            UIApplication.shared.windows.first?.rootViewController = navigationController
            let usersCoordinator = UsersCoordinator(navigationController: navigationController)
            usersCoordinator.start()
        }

    }
}

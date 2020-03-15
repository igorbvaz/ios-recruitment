//
//  UsersCoordinator.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

enum UsersPath: CoordinatorPath {
    case details(basicUser: BasicUser)
}
protocol UsersCoordinatorProtocol: Coordinator {}

class UsersCoordinator: UsersCoordinatorProtocol {
    var navigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = UsersListViewController(viewModel: UsersListViewModel(coordinator: self))
        navigationController.navigationBar.tintColor = R.color.contrast()
        navigationController.pushViewController(viewController, animated: false)
    }

    func route(path: CoordinatorPath) {
        guard let path = path as? UsersPath else { return }
        switch path {
        case .details(let basicUser):
            let viewController = UserDetailsViewController(viewModel: UserDetailsViewModel(coordinator: self, userLogin: basicUser.login))
            navigationController.navigationBar.transparent = true
                navigationController.pushViewController(viewController, animated: true)
        }
    }


}

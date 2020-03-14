//
//  Coordinator.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

protocol CoordinatorPath {}

protocol Coordinator {
    var navigationController: UINavigationController { get }
    init(navigationController: UINavigationController)
    func start()
    func route(path: CoordinatorPath)
}

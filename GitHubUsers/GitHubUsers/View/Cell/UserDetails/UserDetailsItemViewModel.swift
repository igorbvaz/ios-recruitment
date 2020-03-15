//
//  UserDetailsItemViewModel.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

protocol UserDetailsItemViewModelOutputs {
    var name: String { get }
    var `private`: Bool { get }
    var description: String { get }
}
class UserDetailsItemViewModel {

    var repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

}

extension UserDetailsItemViewModel: UserDetailsItemViewModelOutputs {
    var name: String {
        return repository.name
    }
    var `private`: Bool {
        return repository.private
    }

    var description: String {
        return repository.description ?? R.string.localizable.noDescription()
    }
}

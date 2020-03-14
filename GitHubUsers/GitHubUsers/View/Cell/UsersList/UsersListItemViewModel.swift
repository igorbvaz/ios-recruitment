//
//  UsersListItemViewModel.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import RxSwift

protocol UsersListItemViewModelOutputs {
    var login: String { get }
}
class UsersListItemViewModel: ViewModelProtocol {
    var disposeBag = DisposeBag()

    var basicUser: BasicUser

    init(basicUser: BasicUser) {
        self.basicUser = basicUser
    }
}

extension UsersListItemViewModel: UsersListItemViewModelOutputs {
    var login: String {
        return basicUser.login
    }

    var photo: URL {
        return URL(string: basicUser.avatar_url) ?? URL(string: "")!
    }
}

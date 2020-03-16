//
//  UsersMock.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 14/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import RxSwift
@testable import GitHubUsers
class UsersMock: Mock {

    static var basicUser: BasicUser {
        return BasicUser(login: string, id: int, avatar_url: string)
    }

    static var basicUserArray: [BasicUser] {
        return [basicUser]
    }

    static var searchUsersResponse: SearchUsersResponse {
        return SearchUsersResponse(total_count: int, incomplete_results: bool, items: basicUserArray)
    }

    static var user: User {
        return User(login: string, id: int, avatar_url: string, gravatar_id: string, url: string, name: string, company: string, location: string, email: string, bio: string, public_repos: int, public_gists: int, followers: int, following: int)
    }

    static var repository: Repository {
         return Repository(id: int, name: string, private: bool, description: string)
    }

    static var repositoriesArray: [Repository] {
        return [repository]
    }

}

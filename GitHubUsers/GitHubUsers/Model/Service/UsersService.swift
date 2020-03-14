//
//  UsersService.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import RxSwift

protocol UsersServiceProtocol {
    func getUsers(offset: Int) -> Observable<Result<[BasicUser]>>
    func searchUsers(searchText: String, page: Int) -> Observable<Result<SearchUsersResponse>>
    func getUser(userLogin: String) -> Observable<Result<User>>
    func repositories(userLogin: String, page: Int) -> Observable<Result<[Repository]>>
}
class UsersService: Service, UsersServiceProtocol {
    func getUsers(offset: Int) -> Observable<Result<[BasicUser]>> {
        return requestArray(url: Endpoints.Users.getUsers(offset: offset).url, method: .get, parameters: nil)
    }

    func searchUsers(searchText: String, page: Int) -> Observable<Result<SearchUsersResponse>> {
        return request(url: Endpoints.Users.searchUsers(searchText: searchText, page: page).url, method: .get, parameters: nil)
    }

    func getUser(userLogin: String) -> Observable<Result<User>> {
        return request(url: Endpoints.Users.getUser(userLogin: userLogin).url, method: .get, parameters: nil)
    }

    func repositories(userLogin: String, page: Int) -> Observable<Result<[Repository]>> {
        return requestArray(url: Endpoints.Users.repositories(userLogin: userLogin, page: page).url, method: .get, parameters: nil)
    }


}

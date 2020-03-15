//
//  UsersServiceMock.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 14/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
@testable import GitHubUsers
class UsersServiceMock: UsersServiceProtocol {

    var resultType: ResultType = .success

    var getUsersCalled = false
    var searchUsersCalled = false
    var getUserCalled = false
    var repositoriesCalled = false
    
    func getUsers(lastUserId: Int) -> Observable<Result<[BasicUser]>> {
        getUsersCalled = true
        switch resultType {
        case .success:
            return Observable.just(Result.success(value: UsersMock.basicUserArray))
        case .failure:
            return Observable.just(Result.failure(error: UsersMock.error))
        }
    }

    func searchUsers(searchText: String, page: Int) -> Observable<Result<SearchUsersResponse>> {
        searchUsersCalled = true
        switch resultType {
        case .success:
            return Observable.just(Result.success(value: UsersMock.searchUsersResponse))
        case .failure:
            return Observable.just(Result.failure(error: UsersMock.error))
        }
    }

    func getUser(userLogin: String) -> Observable<Result<User>> {
        getUserCalled = true
        switch resultType {
        case .success:
            return Observable.just(Result.success(value: UsersMock.user))
        case .failure:
            return Observable.just(Result.failure(error: UsersMock.error))
        }
    }

    func repositories(userLogin: String, page: Int) -> Observable<Result<[Repository]>> {
        repositoriesCalled = true
        switch resultType {
        case .success:
            return Observable.just(Result.success(value: UsersMock.repositoriesArray))
        case .failure:
            return Observable.just(Result.failure(error: UsersMock.error))
        }
    }


}

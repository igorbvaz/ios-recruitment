//
//  UsersDetailsViewModel.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserDetailsViewModelInputs {
    var didLoad: PublishSubject<Void> { get }
    var `deinit`: PublishSubject<Void> { get }
    var loadNextPage: PublishSubject<Void> { get }
}

protocol UserDetailsViewModelOutputs {
    var photoDriver: Driver<String> { get }
    var nameDriver: Driver<String> { get }
    var bioDriver: Driver<String> { get }
    var followersDriver: Driver<String> { get }
    var publicReposDriver: Driver<String> { get }
    var followingDriver: Driver<String> { get }
    var dataSource: Driver<[SectionViewModel<UserDetailsItemViewModel>]> { get }
    var showUserDetailsLoadingStateDriver: Driver<Bool> { get }
    var showUserDetailsEmptyStateDriver: Driver<Bool> { get }
    var errorDriver: Driver<String> { get }
}

protocol UserDetailsViewModelProtocol: ViewModelProtocol {
    var inputs: UserDetailsViewModelInputs { get }
    var outputs: UserDetailsViewModelOutputs { get }
}
class UserDetailsViewModel: UserDetailsViewModelProtocol, UserDetailsViewModelInputs {

    var inputs: UserDetailsViewModelInputs { return self }
    var outputs: UserDetailsViewModelOutputs { return self }

    var didLoad = PublishSubject<Void>()
    var `deinit` = PublishSubject<Void>()
    var loadNextPage = PublishSubject<Void>()

    var disposeBag = DisposeBag()

    private var getUserResult: Observable<Result<User>>

    private var repositoriesResult: Observable<Result<[Repository]>>
    private var repositoriesPageBehaviorRelay = BehaviorRelay<Int>(value: 1)
    private var repositoriesTableIsLoadingPublishSubject = PublishSubject<Bool>()
    private var repositoriesBehaviorRelay = BehaviorRelay<[Repository]>(value: [])

    init(coordinator: UsersCoordinatorProtocol, service: UsersServiceProtocol = UsersService(), userLogin: String) {
        let repositoriesTableLoading = PublishSubject<Bool>()
        repositoriesTableIsLoadingPublishSubject = repositoriesTableLoading
        let repositoriesPage = BehaviorRelay<Int>(value: 1)
        repositoriesPageBehaviorRelay = repositoriesPage

        // User
        getUserResult = didLoad.flatMapLatest({ _ -> Observable<Result<User>> in
            return service.getUser(userLogin: userLogin)
        }).share()

        // Repositories
        repositoriesResult = Observable.merge(didLoad, loadNextPage).flatMapLatest({ _ -> Observable<Result<[Repository]>> in
            repositoriesTableLoading.onNext(true)
            return service.repositories(userLogin: userLogin, page: repositoriesPage.value)
        }).share()

        repositoriesResult.map { $0.value }.unwrap().bind(onNext: { [weak self] results in
            guard let this = self else { return }
            this.repositoriesBehaviorRelay.accept(this.repositoriesBehaviorRelay.value + results)
        }).disposed(by: disposeBag)

        repositoriesResult.bind(onNext: { _ in
            repositoriesTableLoading.onNext(false)
        }).disposed(by: disposeBag)

    }

}

extension UserDetailsViewModel: UserDetailsViewModelOutputs {

    var photoDriver: Driver<String> {
        return getUserResult.map { $0.value }.unwrap().map { $0.avatar_url }.asDriver(onErrorJustReturn: "")
    }

    var nameDriver: Driver<String> {
       return getUserResult.map { $0.value }.unwrap().map { $0.name }.asDriver(onErrorJustReturn: "")
    }

    var bioDriver: Driver<String> {
        return getUserResult.map { $0.value }.unwrap().map { $0.bio }.unwrap().asDriver(onErrorJustReturn: "")
    }

    var locationDriver: Driver<String> {
        return getUserResult.map { $0.value }.unwrap().map { $0.bio }.unwrap().asDriver(onErrorJustReturn: "")
    }

    var followersDriver: Driver<String> {
        return getUserResult.map { $0.value }.unwrap().map { $0.followers.toK() }.asDriver(onErrorJustReturn: "")
    }

    var publicReposDriver: Driver<String> {
       return getUserResult.map { $0.value }.unwrap().map { $0.public_repos.toK() }.asDriver(onErrorJustReturn: "")
    }

    var followingDriver: Driver<String> {
        return getUserResult.map { $0.value }.unwrap().map { $0.following.toK() }.asDriver(onErrorJustReturn: "")
    }

    var dataSource: Driver<[SectionViewModel<UserDetailsItemViewModel>]> {
        return repositoriesBehaviorRelay.map { repositorys in
            return [SectionViewModel<UserDetailsItemViewModel>(items: repositorys.map { repository in
                return UserDetailsItemViewModel(repository: repository)
            })]
        }.asDriver(onErrorJustReturn: [])
    }

    var showUserDetailsLoadingStateDriver: Driver<Bool> {
        return repositoriesTableIsLoadingPublishSubject.map { $0 }.asDriver(onErrorJustReturn: false)
    }

    var showUserDetailsEmptyStateDriver: Driver<Bool> {
        return repositoriesBehaviorRelay.map { $0.isEmpty }.map { _ in return true }.asDriver(onErrorJustReturn: true)
    }

    var errorDriver: Driver<String> {
        return Observable.merge(getUserResult.map { ($0.error?.asAFError?.errorDescription ?? "")}, repositoriesResult.map { $0.error?.asAFError?.errorDescription ?? "" }) .asDriver(onErrorJustReturn: "")
    }

}

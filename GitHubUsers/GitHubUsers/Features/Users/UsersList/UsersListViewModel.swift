//
//  UsersListViewModel.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

protocol UsersListViewModelInputs {
    var didLoad: PublishSubject<Void> { get }
    var loadNextPage: PublishSubject<Void> { get }
    var basicUserSelected: PublishSubject<BasicUser> { get }
    var searchTextPublishSubject: PublishSubject<String> { get }
    var searchBarDidEndPublishSubject: PublishSubject<Void> { get }
}

protocol UsersListViewModelOutputs {
    var dataSource: Driver<[SectionViewModel<UsersListItemViewModel>]> { get }
    var showUsersListLoadingStateDriver: Driver<Bool> { get }
    var showUsersListEmptyStateDriver: Driver<Bool> { get }
    var errorDriver: Driver<String> { get }
}

protocol UsersListViewModelProtocol: ViewModelProtocol {
    var inputs: UsersListViewModelInputs { get }
    var outputs: UsersListViewModelOutputs { get }
}
class UsersListViewModel: UsersListViewModelProtocol, UsersListViewModelInputs {
    var inputs: UsersListViewModelInputs { return self }
    var outputs: UsersListViewModelOutputs { return self }

    var didLoad = PublishSubject<Void>()
    var loadNextPage = PublishSubject<Void>()
    var basicUserSelected = PublishSubject<BasicUser>()
    var searchTextPublishSubject = PublishSubject<String>()
    var searchBarDidEndPublishSubject = PublishSubject<Void>()

    var loadUsersNextPage = PublishSubject<Void>()
    var loadSearchUsersNextPage = PublishSubject<Void>()
    var searchUsersNextPage = BehaviorRelay<Int>(value: 1)
    var isSearchingBehaviorRelay: BehaviorRelay<Bool>
    var currentSearchTextBehaviorRelay: BehaviorRelay<String>

    var disposeBag = DisposeBag()
    private var getUsersResult: Observable<Result<[BasicUser]>>
    private var searchUsersResult: Observable<Result<SearchUsersResponse>>
    private var usersBehaviorRelay = BehaviorRelay<[BasicUser]>(value: [])
    private var usersTableIsLoadingPublishSubject = PublishSubject<Bool>()

    init(coordinator: UsersCoordinatorProtocol, service: UsersServiceProtocol = UsersService()) {
        let usersTableLoading = PublishSubject<Bool>()
        usersTableIsLoadingPublishSubject = usersTableLoading
        let usersList = BehaviorRelay<[BasicUser]>(value: [])
        usersBehaviorRelay = usersList
        let seachUsersPage = BehaviorRelay<Int>(value: 1)
        searchUsersNextPage = seachUsersPage
        let isSearching = BehaviorRelay<Bool>(value: false)
        isSearchingBehaviorRelay = isSearching
        let currentSearchText = BehaviorRelay<String>(value: "")
        currentSearchTextBehaviorRelay = currentSearchText

        // Users
        getUsersResult = Observable.merge(didLoad, loadUsersNextPage).flatMapLatest({ _ -> Observable<Result<[BasicUser]>> in
            usersTableLoading.onNext(true)
            return service.getUsers(lastUserId: usersList.value.last?.id ?? 0)
        }).share()

        getUsersResult.map { $0.value }.unwrap().bind(onNext: { results in
            usersList.accept(usersList.value + results)
        }).disposed(by: disposeBag)

        getUsersResult.bind(onNext: { _ in
            usersTableLoading.onNext(false)
        }).disposed(by: disposeBag)

        // Search Users
        searchUsersResult = loadSearchUsersNextPage.withLatestFrom(searchTextPublishSubject).flatMapLatest({ searchText -> Observable<Result<SearchUsersResponse>> in
            usersTableLoading.onNext(true)
            return service.searchUsers(searchText: searchText, page: seachUsersPage.value)
        }).share()

        searchUsersResult.map { $0.value }.unwrap().bind(onNext: { [weak self] results in
            self?.searchUsersNextPage.accept((self?.searchUsersNextPage.value ?? 0) + 1)
            usersList.accept(usersList.value + results.items)
        }).disposed(by: disposeBag)

        searchUsersResult.bind(onNext: { _ in
            usersTableLoading.onNext(false)
        }).disposed(by: disposeBag)

        // Coordinator
        basicUserSelected.subscribe(onNext: { basicUser in
            coordinator.route(path: UsersPath.details(basicUser: basicUser))
        }).disposed(by: disposeBag)

        // Other
        searchTextPublishSubject.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).bind(onNext: { [weak self] text in
            isSearching.accept(!text.isEmpty)
            currentSearchText.accept(text)
            self?.searchUsersNextPage.accept(1)
            self?.usersBehaviorRelay.accept([])
            self?.loadNextPage.onNext(())
        }).disposed(by: disposeBag)

        loadNextPage.withLatestFrom(isSearching).filter { $0 == false }.map { _ in return Void() }.bind(to: loadUsersNextPage).disposed(by: disposeBag)

        loadNextPage.withLatestFrom(isSearching).filter { $0 == true }.map { _ in return Void() }.bind(to: loadSearchUsersNextPage).disposed(by: disposeBag)
    }

}

extension UsersListViewModel: UsersListViewModelOutputs {
    var dataSource: Driver<[SectionViewModel<UsersListItemViewModel>]> {
        return usersBehaviorRelay.map { basicUsers in
            return [SectionViewModel<UsersListItemViewModel>(items: basicUsers.map { basicUser in
                return UsersListItemViewModel(basicUser: basicUser)
            })]
        }.asDriver(onErrorJustReturn: [])
    }

    var showUsersListLoadingStateDriver: Driver<Bool> {
        return usersTableIsLoadingPublishSubject.map { $0 }.asDriver(onErrorJustReturn: false)
    }

    var showUsersListEmptyStateDriver: Driver<Bool> {
        return Observable.zip(searchBarDidEndPublishSubject, usersBehaviorRelay.map { $0.isEmpty }).map { _ in return true }.asDriver(onErrorJustReturn: true)
    }

    var errorDriver: Driver<String> {
        return Observable.merge(getUsersResult.map { ($0.error?.asAFError?.errorDescription ?? "")}, searchUsersResult.map { $0.error?.asAFError?.errorDescription ?? "" }) .asDriver(onErrorJustReturn: "")
    }
}

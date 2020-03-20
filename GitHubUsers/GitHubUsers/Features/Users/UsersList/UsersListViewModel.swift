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
    var cancelButtonTappedPublishSubject: PublishSubject<Void> { get }
}

protocol UsersListViewModelOutputs {
    var dataSource: Driver<[SectionViewModel<UsersListItemViewModel>]> { get }
    var showUsersListLoadingStateDriver: Driver<Bool> { get }
    var showUsersListEmptyStateDriver: Driver<Bool> { get }
    var errorDriver: Driver<String> { get }
    var searchTextDriver: Driver<String> { get }
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
    var cancelButtonTappedPublishSubject = PublishSubject<Void>()

    var loadUsersNextPage = PublishSubject<Void>()
    var loadSearchUsersNextPage = PublishSubject<Void>()
    var searchUsersNextPage = BehaviorRelay<Int>(value: 1)
    var isSearchingBehaviorRelay: BehaviorRelay<Bool>
    var currentSearchTextBehaviorRelay: BehaviorRelay<String>

    var disposeBag = DisposeBag()
    private var getUsersResult: Observable<Result<[BasicUser]>>
    private var getUsersFinishedBehaviorRelay = BehaviorRelay<Bool>(value: false)
    private var searchUsersResult: Observable<Result<SearchUsersResponse>>
    private var searchUsersFinishedBehaviorRelay = BehaviorRelay<Bool>(value: false)
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
        let getUsersFinished = BehaviorRelay<Bool>(value: false)
        getUsersFinishedBehaviorRelay = getUsersFinished
        let searchUsersFinished = BehaviorRelay<Bool>(value: false)
        searchUsersFinishedBehaviorRelay = searchUsersFinished

        // Users
        getUsersResult = Observable.merge(didLoad, loadUsersNextPage).filter { _ in return !getUsersFinished.value }.flatMapLatest({ _ -> Observable<Result<[BasicUser]>> in
            usersTableLoading.onNext(true)
            return service.getUsers(lastUserId: usersList.value.last?.id ?? 0)
        }).share()

        getUsersResult.map { $0.value }.unwrap().bind(onNext: { results in
            getUsersFinished.accept(results.isEmpty)
            usersList.accept(usersList.value + results)
        }).disposed(by: disposeBag)

        getUsersResult.bind(onNext: { _ in
            usersTableLoading.onNext(false)
        }).disposed(by: disposeBag)

        // Search Users
        searchUsersResult = loadSearchUsersNextPage.withLatestFrom(searchTextPublishSubject).filter { _ in return !searchUsersFinished.value }.flatMapLatest({ searchText -> Observable<Result<SearchUsersResponse>> in
            usersTableLoading.onNext(true)
            return service.searchUsers(searchText: searchText, page: seachUsersPage.value)
        }).share()

        searchUsersResult.map { $0.value }.unwrap().bind(onNext: { [weak self] results in
            searchUsersFinished.accept(results.items.isEmpty)
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

        // Search
        searchTextPublishSubject.filter { $0 != currentSearchText.value }.debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).bind(onNext: { [weak self] text in
                isSearching.accept(!text.isEmpty)
                currentSearchText.accept(text)
                getUsersFinished.accept(false)
                searchUsersFinished.accept(false)
                self?.searchUsersNextPage.accept(1)
                self?.usersBehaviorRelay.accept([])
                self?.loadNextPage.onNext(())
        }).disposed(by: disposeBag)

        cancelButtonTappedPublishSubject.subscribe(onNext: { [weak self] _ in
            self?.searchTextPublishSubject.onNext("")
        }).disposed(by: disposeBag)

        searchBarDidEndPublishSubject.subscribe(onNext: { _ in
            currentSearchText.accept(currentSearchText.value)
        }).disposed(by: disposeBag)

        // Pagination
        loadNextPage.withLatestFrom(isSearchingBehaviorRelay).filter { $0 == false }.map { _ in return Void() }.bind(to: loadUsersNextPage).disposed(by: disposeBag)

        loadNextPage.withLatestFrom(isSearchingBehaviorRelay).filter { $0 == true }.map { _ in return Void() }.bind(to: loadSearchUsersNextPage).disposed(by: disposeBag)
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
        return Observable.merge(searchBarDidEndPublishSubject, usersBehaviorRelay.map { _ in return Void() }).withLatestFrom(usersBehaviorRelay).map { $0.isEmpty }.asDriver(onErrorJustReturn: false)
    }

    var errorDriver: Driver<String> {
        return Observable.merge(getUsersResult.map { ($0.error?.asAFError?.errorDescription ?? "")}, searchUsersResult.map { $0.error?.asAFError?.errorDescription ?? "" }) .asDriver(onErrorJustReturn: "")
    }

    var searchTextDriver: Driver<String> {
        return currentSearchTextBehaviorRelay.asDriver()
    }
}

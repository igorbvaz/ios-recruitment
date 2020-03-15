//
//  UsersListViewModelSpec.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 14/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import Quick
import Nimble
import RxTest
import RxSwift
@testable import GitHubUsers

class UsersListViewModelSpec: QuickSpec {
    override func spec() {
        describe("UsersList ViewModel") {

            var coordinator: UsersCoordinatorSpy!
            var service: UsersServiceMock!
            var viewModel: UsersListViewModel!

            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            // ViewModel Outpus
            var dataSourceObserver: TestableObserver<[SectionViewModel<UsersListItemViewModel>]>!
            var showUsersListLoadingStateObserver: TestableObserver<Bool>!
            var showUsersListEmptyStateObserver: TestableObserver<Bool>!
            var errorObserver: TestableObserver<String>!

            beforeEach {
                coordinator = UsersCoordinatorSpy(navigationController: UINavigationController())
                service = UsersServiceMock()
                viewModel = UsersListViewModel(coordinator: coordinator, service: service)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()

                dataSourceObserver = scheduler.createObserver([SectionViewModel<UsersListItemViewModel>].self)
                viewModel.outputs.dataSource.drive(dataSourceObserver).disposed(by: disposeBag)

                showUsersListLoadingStateObserver = scheduler.createObserver(Bool.self)
                viewModel.outputs.showUsersListLoadingStateDriver.drive(showUsersListLoadingStateObserver).disposed(by: disposeBag)

                showUsersListEmptyStateObserver = scheduler.createObserver(Bool.self)
                viewModel.outputs.showUsersListEmptyStateDriver.drive(showUsersListEmptyStateObserver).disposed(by: disposeBag)

                errorObserver = scheduler.createObserver(String.self)
                viewModel.outputs.errorDriver.drive(errorObserver).disposed(by: disposeBag)
            }

            afterEach {
                coordinator = nil
                service = nil
                viewModel = nil
                scheduler = nil
                disposeBag = nil
            }

            context("when viewDidLoad") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should call service's getUsers") {
                    expect(service.getUsersCalled).to(beTrue())
                }

            }

            context("when loadNextPage while not searching") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, false)]).bind(to: viewModel.isSearchingBehaviorRelay).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should call service's getUsers") {
                    expect(service.getUsersCalled).to(beTrue())
                }

            }

            context("when loadNextPage while searching") {
                beforeEach {
                    scheduler.createColdObservable([.next(5, UsersMock.string)]).bind(to: viewModel.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(10, true)]).bind(to: viewModel.isSearchingBehaviorRelay).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should call service's searchUsers") {
                    expect(service.searchUsersCalled).to(beTrue())
                }

            }

            context("when user taps a BasicUser") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, UsersMock.basicUser)]).bind(to: viewModel.basicUserSelected).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should route to details") {
                    expect(coordinator.didRouteToDetails).to(beTrue())
                }
            }

            context("when user clears search field") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, "")]).bind(to: viewModel.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should call service's getUsers") {
                    expect(service.getUsersCalled).toEventually(beTrue(), timeout: 1)
                }

            }

            context("when user types something on search fields") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, UsersMock.string)]).bind(to: viewModel.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should call service's searchUsers") {
                    expect(service.searchUsersCalled).toEventually(beTrue())
                }

            }

            context("when getUsers is called") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.loadUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output showLoading") {
                    expect(showUsersListLoadingStateObserver.events.first?.value.element).toEventually(beTrue())
                    expect(showUsersListLoadingStateObserver.events.last?.value.element).toEventually(beFalse())
                }

            }

            context("when getUsers succeeds") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.loadUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }
                it("should output dataSource") { expect(dataSourceObserver.events.last?.value.element?.first?.items.first?.basicUser.id).toEventually(equal(UsersMock.basicUser.id))
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.count).to(be(UsersMock.basicUserArray.count))
                }
            }

            context("when getUsers succeeds after pagination") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.loadUsersNextPage).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(100, ())]).bind(to: viewModel.loadUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output dataSource") { expect(dataSourceObserver.events.last?.value.element?.first?.items.first?.basicUser.id).toEventually(equal(UsersMock.basicUser.id))
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.count).to(be(UsersMock.basicUserArray.count + UsersMock.basicUserArray.count))
                }
            }

            context("when getUsers is called but fails") {
                beforeEach {
                    service.resultType = .failure
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.loadUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output error") {
                    expect(errorObserver.events.first?.value.element).toEventually(equal(UsersMock.error.asAFError?.errorDescription ?? ""))
                }
            }

            context("when searchUsers is called") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, UsersMock.string)]).bind(to: viewModel.inputs.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadSearchUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output showLoading") {
                    expect(showUsersListLoadingStateObserver.events.first?.value.element).toEventually(beTrue())
                    expect(showUsersListLoadingStateObserver.events.last?.value.element).toEventually(beFalse())
                }

            }

            context("when searchUsers succeeds") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, UsersMock.string)]).bind(to: viewModel.inputs.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadSearchUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output dataSource") { expect(dataSourceObserver.events.last?.value.element?.first?.items.first?.basicUser.id).toEventually(equal(UsersMock.basicUser.id))
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.count).to(be(UsersMock.basicUserArray.count))
                }
            }

            context("when searchUsers succeeds after pagination") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, UsersMock.string)]).bind(to: viewModel.inputs.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadSearchUsersNextPage).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(100, ())]).bind(to: viewModel.loadSearchUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output dataSource") { expect(dataSourceObserver.events.last?.value.element?.first?.items.first?.basicUser.id).toEventually(equal(UsersMock.basicUser.id))
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.count).to(be(UsersMock.basicUserArray.count + UsersMock.basicUserArray.count))
                }
            }

            context("when searchUsers is called but fails") {
                beforeEach {
                    service.resultType = .failure
                    scheduler.createColdObservable([.next(10, UsersMock.string)]).bind(to: viewModel.inputs.searchTextPublishSubject).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadSearchUsersNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }
                it("should output error") {
                    expect(errorObserver.events.last?.value.element).toEventually(equal(UsersMock.error.asAFError?.errorDescription ?? ""))
                }
            }

        }
    }
}

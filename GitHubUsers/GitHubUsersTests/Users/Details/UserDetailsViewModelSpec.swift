//
//  UserDetailsViewModelSpec.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTest
import Quick
import Nimble
@testable import GitHubUsers

class UserDetailsViewModelSpec: QuickSpec {
    override func spec() {
        describe("UserDetails ViewModel") {

            var coordinator: UsersCoordinatorSpy!
            var service: UsersServiceMock!
            var viewModel: UserDetailsViewModel!

            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            // ViewModel Outpus
            var photoObserver: TestableObserver<String>!
            var nameObserver: TestableObserver<String>!
            var bioObserver: TestableObserver<String>!
            var followersObserver: TestableObserver<String>!
            var publicReposObserver: TestableObserver<String>!
            var followingObserver: TestableObserver<String>!
            var dataSourceObserver: TestableObserver<[SectionViewModel<UserDetailsItemViewModel>]>!
            var showUserDetailsLoadingStateObserver: TestableObserver<Bool>!
            var showUserDetailsEmptyStateObserver: TestableObserver<Bool>!
            var errorObserver: TestableObserver<String>!

            beforeEach {
                coordinator = UsersCoordinatorSpy(navigationController: UINavigationController())
                service = UsersServiceMock()
                viewModel = UserDetailsViewModel(coordinator: coordinator, service: service, userLogin: UsersMock.string)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()

                photoObserver = scheduler.createObserver(String.self)
                viewModel.outputs.photoDriver.drive(photoObserver).disposed(by: disposeBag)

                nameObserver = scheduler.createObserver(String.self)
                viewModel.outputs.nameDriver.drive(nameObserver).disposed(by: disposeBag)

                bioObserver = scheduler.createObserver(String.self)
                viewModel.outputs.bioDriver.drive(bioObserver).disposed(by: disposeBag)

                followersObserver = scheduler.createObserver(String.self)
                viewModel.outputs.followersDriver.drive(followersObserver).disposed(by: disposeBag)

                publicReposObserver = scheduler.createObserver(String.self)
                viewModel.outputs.publicReposDriver.drive(publicReposObserver).disposed(by: disposeBag)

                followingObserver = scheduler.createObserver(String.self)
                viewModel.outputs.followingDriver.drive(followingObserver).disposed(by: disposeBag)

                dataSourceObserver = scheduler.createObserver([SectionViewModel<UserDetailsItemViewModel>].self)
                viewModel.outputs.dataSource.drive(dataSourceObserver).disposed(by: disposeBag)

                showUserDetailsLoadingStateObserver = scheduler.createObserver(Bool.self)
                viewModel.outputs.showUserDetailsLoadingStateDriver.drive(showUserDetailsLoadingStateObserver).disposed(by: disposeBag)

                showUserDetailsEmptyStateObserver = scheduler.createObserver(Bool.self)
                viewModel.outputs.showUserDetailsEmptyStateDriver.drive(showUserDetailsEmptyStateObserver).disposed(by: disposeBag)

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
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should call service's getUser") {
                    expect(service.getUserCalled).to(beTrue())
                }

                it("should call service's repositories") {
                    expect(service.repositoriesCalled).to(beTrue())
                }
            }

            context("when getUser is called") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output showLoading") {
                    expect(showUserDetailsLoadingStateObserver.events.first?.value.element).toEventually(beTrue())
                    expect(showUserDetailsLoadingStateObserver.events.last?.value.element).toEventually(beFalse())
                }

            }

            context("when getUser succeeds") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output user data") {
                    expect(photoObserver.events.last?.value.element).to(equal(UsersMock.string))
                    expect(nameObserver.events.last?.value.element).to(equal(UsersMock.string))
                    expect(bioObserver.events.last?.value.element).to(equal(UsersMock.string))
                    expect(followersObserver.events.last?.value.element).to(equal("\(UsersMock.int)"))
                    expect(publicReposObserver.events.last?.value.element).to(equal("\(UsersMock.int)"))
                    expect(followingObserver.events.last?.value.element).to(equal("\(UsersMock.int)"))
                }
            }

            context("when getUser fails") {
                beforeEach {
                    service.resultType = .failure
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output an error") {
                    expect(errorObserver.events.last?.value.element).toEventually(equal(UsersMock.error.asAFError?.errorDescription ?? ""))
                }
            }

            context("when repositories is called") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.loadNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output showLoading") {
                    expect(showUserDetailsLoadingStateObserver.events.first?.value.element).toEventually(beTrue())
                    expect(showUserDetailsLoadingStateObserver.events.last?.value.element).toEventually(beFalse())
                }

            }

            context("when repositories succeeds") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.loadNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output dataSource") {
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.first?.name).to(equal(UsersMock.string))
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.count).to(equal(UsersMock.repositoriesArray.count))
                }
            }

            context("when repositories fails") {
                beforeEach {
                    service.resultType = .failure
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.loadNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output an error") {
                    expect(errorObserver.events.last?.value.element).toEventually(equal(UsersMock.error.asAFError?.errorDescription ?? ""))
                }
            }

            context("when repositories succeeds after pagination") {
                beforeEach {
                    service.resultType = .success
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, ())]).bind(to: viewModel.loadNextPage).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should output dataSource") {
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.first?.name).to(equal(UsersMock.string))
                    expect(dataSourceObserver.events.last?.value.element?.first?.items.count).to(equal(UsersMock.repositoriesArray.count + UsersMock.repositoriesArray.count))
                }
            }

        }
    }
}

//
//  LogoViewModelSpec.swift
//  GitHubUsersTests
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
@testable import GitHubUsers

class LogoViewModelSpec: QuickSpec {
    override func spec() {
        describe("Logo ViewModel") {
            var coordinator: AppCoordinatorSpy!
            var viewModel: LogoViewModelProtocol!

            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            // ViewModel Outputs
            var showAnimationObserver: TestableObserver<String>!

            beforeEach {
                coordinator = AppCoordinatorSpy(navigationController: UINavigationController())
                viewModel = LogoViewModel(coordinator: coordinator)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()

                showAnimationObserver = scheduler.createObserver(String.self)
                viewModel.outputs.showAnimation.drive(showAnimationObserver).disposed(by: disposeBag)
            }

            context("when didLoad") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didLoad).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should show animation") {
                    expect(showAnimationObserver.events.first?.value.element).to(equal("github"))
                }
            }

            context("when animation finishes") {
                beforeEach {
                    scheduler.createColdObservable([.next(10, ())]).bind(to: viewModel.inputs.didFinishAnimation).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("should route to users") {
                    expect(coordinator.didRouteToUsers).to(beTrue())
                }
            }

        }
    }
}

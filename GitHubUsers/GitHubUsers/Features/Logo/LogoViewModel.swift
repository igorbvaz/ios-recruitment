//
//  LogoViewModel.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LogoViewModelInputs {
    var didLoad: PublishSubject<Void> { get }
    var didFinishAnimation: PublishSubject<Void> { get }
}

protocol LogoViewModelOutputs {
    var showAnimation: Driver<String> { get }
}

protocol LogoViewModelProtocol: ViewModelProtocol {
    var inputs: LogoViewModelInputs { get }
    var outputs: LogoViewModelOutputs { get }
}
class LogoViewModel: LogoViewModelProtocol, LogoViewModelInputs {
    var inputs: LogoViewModelInputs { return self }
    var outputs: LogoViewModelOutputs { return self }

    var disposeBag = DisposeBag()

    var didLoad = PublishSubject<Void>()
    var didFinishAnimation = PublishSubject<Void>()

    init(coordinator: AppCoordinatorProtocol) {
        didFinishAnimation.subscribe(onNext: { _ in
            coordinator.route(path: AppPath.users)
        }).disposed(by: disposeBag)
    }
}

extension LogoViewModel: LogoViewModelOutputs {
    var showAnimation: Driver<String> {
        return didLoad.map { _ in return "github" }.asDriver(onErrorJustReturn: "")
    }
}

//
//  LogoViewController.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import Lottie
class LogoViewController: ViewController<LogoView> {

    var viewModel: LogoViewModelProtocol!

    init(viewModel: LogoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutputs()
        setupInputs()
        viewModel.inputs.didLoad.onNext(())
    }

}

extension LogoViewController {
    private func setupOutputs() {
        viewModel.outputs.showAnimation.drive(onNext: { [weak self] animationName in
            self?.mainView.animationView.animation = Animation.named(animationName)
            self?.mainView.animationView.play(completion: { (completed) in
                if completed {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.mainView.animationView.transform = .init(scaleX: 0.9, y: 0.9)
                    }) { (completed) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self?.mainView.animationView.transform = .init(scaleX: 10, y: 10)
                        }) { (completed) in
                            self?.viewModel.inputs.didFinishAnimation.onNext(())
                        }
                    }

                }
            })
        }).disposed(by: disposeBag)
    }

    private func setupInputs() {

    }
}

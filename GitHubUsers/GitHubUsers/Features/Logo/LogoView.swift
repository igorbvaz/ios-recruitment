//
//  LogoView.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import Lottie

class LogoView: UIView {

    var animationView = AnimationView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        backgroundColor = UIColor.white
        setupAnimationView()
    }
}

extension LogoView {

    private func setupAnimationView() {
        addSubview(animationView)

        animationView.animationSpeed = 2
        animationView.loopMode = .playOnce

        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(232)
        }
    }

}

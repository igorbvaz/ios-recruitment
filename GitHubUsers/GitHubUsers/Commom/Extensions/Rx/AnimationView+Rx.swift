//
//  AnimationView+Rx.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import RxSwift
import RxCocoa
import Lottie

extension Reactive where Base: AnimationView {
    var play: Binder<String> {
        return Binder(self.base) { control, value in
            control.animation = Animation.named(value)
            control.play()
        }
    }
}

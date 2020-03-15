//
//  UIImageView+Rx.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

extension Reactive where Base: UIImageView {
    var imageWithUrl: Binder<String> {
        return Binder(self.base) { control, value in
            guard let url = URL(string: value) else { return }
            control.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "person"), imageTransition: .crossDissolve(0.5))
        }
    }
}

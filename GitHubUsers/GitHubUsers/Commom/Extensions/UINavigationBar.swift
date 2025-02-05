//
//  UINavigationBar.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

extension UINavigationBar {
    var transparent: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.setBackgroundImage(UIImage(), for: .default)
                self.shadowImage = UIImage()
            } else {
                self.setBackgroundImage(nil, for: .default)
                self.shadowImage = nil
            }

        }
    }

}

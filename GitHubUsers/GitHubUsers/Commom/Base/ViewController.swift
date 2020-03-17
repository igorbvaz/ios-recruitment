//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift

class ViewController<T: UIView>: UIViewController {
    let disposeBag = DisposeBag()

    var mainView = T()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlert(text: String?) {
        guard let text = text, !text.isEmpty else { return }
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showMainViewAnimated() {
        navigationController?.navigationBar.alpha = 0
        mainView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.navigationBar.alpha = 1
            self.mainView.alpha = 1
        }
    }
}

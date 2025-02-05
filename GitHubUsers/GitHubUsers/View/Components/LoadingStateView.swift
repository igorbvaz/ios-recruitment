//
//  LoadingStateView.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class LoadingStateView: UIView {

    private var stackView = UIStackView()
    var activityIndicatorView: UIActivityIndicatorView!
    var textLabel = UILabel()

    private var text: String?

    convenience init(size: CGSize, text: String = "") {
        self.init(frame: CGRect(origin: .zero, size: size))
        self.text = text
        self.activityIndicatorView = UIActivityIndicatorView(style: .medium)
        setup()
    }

    private func setup() {
        stupAppearance()
        setupStackView()
    }

    private func stupAppearance() {
        backgroundColor = R.color.background()
    }

    private func setupStackView() {
        addSubview(stackView)

        stackView.axis = .vertical
        stackView.spacing = 8

        stackView.snp.makeConstraints { (make) in
            make.left.right.centerY.equalToSuperview()
        }

        setupActivityIndicatorView()
        setupTextLabel()
    }

    private func setupActivityIndicatorView() {
        stackView.addArrangedSubview(activityIndicatorView)

        activityIndicatorView.startAnimating()
    }

    private func setupTextLabel() {
        stackView.addArrangedSubview(textLabel)

        textLabel.text = text
        textLabel.textColor = UIColor.lightGray
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
    }

}


//
//  UserInfoView.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    private var stackView = UIStackView()
    private var topLabel = UILabel()
    var bottomLabel = UILabel()

    var topText: String! {
        didSet {
            topLabel.text = topText.uppercased()
        }
    }
    var bottomText: String! {
        didSet {
            bottomLabel.text = bottomText
        }
    }

    init(topText: String = "", bottomText: String = "120") {
        self.topText = topText
        self.bottomText = bottomText
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        setupStackView()
    }

}

extension UserInfoView {
    private func setupStackView() {
        addSubview(stackView)

        stackView.axis = .vertical

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        setupTopLabel()
        setupBottomLabel()
    }

    private func setupTopLabel() {
        stackView.addArrangedSubview(topLabel)

        topLabel.text = topText.uppercased()
        topLabel.textColor = R.color.textSecondary()
        topLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
    }

    private func setupBottomLabel() {
        stackView.addArrangedSubview(bottomLabel)

        bottomLabel.text = bottomText
        bottomLabel.textColor = R.color.textSecondary()
        bottomLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        bottomLabel.numberOfLines = 1
        bottomLabel.textAlignment = .center
        bottomLabel.setContentHuggingPriority(.required, for: .vertical)
    }
}

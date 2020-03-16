//
//  UserDetailsItemCell.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class UserDetailsItemCell: UITableViewCell {

    var mainStackView = UIStackView()
    var topStackView = UIStackView()
    var nameLabel = UILabel()
    var privateImageView = UIImageView()
    var descriptionLabel = UILabel()

    var viewModel: UserDetailsItemViewModel! {
        didSet {
            bindViewModel()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    private func bindViewModel() {
        nameLabel.text = viewModel.name
        privateImageView.isHidden = !viewModel.private
        descriptionLabel.text = viewModel.description
    }

    private func setup() {
        setupMainStackView()
    }
}

extension UserDetailsItemCell {

    private func setupMainStackView() {
        addSubview(mainStackView)

        mainStackView.axis = .vertical
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(16)
        }

        setupTopStackView()
        setupDescriptionLabel()
    }

    private func setupTopStackView() {
        mainStackView.addArrangedSubview(topStackView)

        topStackView.axis = .horizontal

        setupNameLabel()
        setupPrivateImageView()
    }

    private func setupNameLabel() {
        topStackView.addArrangedSubview(nameLabel)

        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = R.color.textPrimary()
    }

    private func setupPrivateImageView() {
        topStackView.addArrangedSubview(privateImageView)

        privateImageView.image = UIImage(systemName: "lock")
    }

    private func setupDescriptionLabel() {
        mainStackView.addArrangedSubview(descriptionLabel)

        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = R.color.textSecondary()
        descriptionLabel.numberOfLines = 0
    }

}


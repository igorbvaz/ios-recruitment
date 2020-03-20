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
    var starImageView = UIImageView()
    var starCountLabel = UILabel()
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
        descriptionLabel.text = viewModel.description
        starCountLabel.text = viewModel.stars
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
        topStackView.spacing = 2

        setupNameLabel()
        setupStarImageView()
        setupStarCountLabel()
    }

    private func setupNameLabel() {
        topStackView.addArrangedSubview(nameLabel)

        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = R.color.textPrimary()
    }

    private func setupStarImageView() {
        topStackView.addArrangedSubview(starImageView)

        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = R.color.textSecondary()
        starImageView.contentMode = .scaleAspectFit

        starImageView.snp.makeConstraints { (make) in
            make.width.equalTo(10)
        }
    }

    private func setupStarCountLabel() {
        topStackView.addArrangedSubview(starCountLabel)

        starCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        starCountLabel.textColor = R.color.textSecondary()
    }

    private func setupDescriptionLabel() {
        mainStackView.addArrangedSubview(descriptionLabel)

        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = R.color.textSecondary()
        descriptionLabel.numberOfLines = 0
    }

}


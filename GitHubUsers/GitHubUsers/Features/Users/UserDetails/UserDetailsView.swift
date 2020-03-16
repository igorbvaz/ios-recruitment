//
//  UserDetailsView.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit

class UserDetailsView: UIView {

    var tableView = UITableView()

    var headerView = UIView()

    var headerBottomView = UIView()

    var cardView = UIView()

    var imageContainerView = UIView()
    var photoImageView = UIImageView()

    var nameAndDescriptionStackView = UIStackView()
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()

    var infoStackView = UIStackView()

    var followersUserInfoView = UserInfoView(topText: R.string.localizable.followers())
    var followingUserInfoView = UserInfoView(topText: R.string.localizable.following())
    var publicReposUserInfoView = UserInfoView(topText: R.string.localizable.publicRepos())

    var sectionLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        setupTableView()
    }

}

extension UserDetailsView {

    private func setupTableView() {
        addSubview(tableView)

        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundView = UIView()

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        setupTableViewHeader()
    }

    private func setupTableViewHeader() {
        headerView = UIView(frame: .init(origin: .zero, size: .init(width: self.bounds.width, height: 400)))
        headerView.clipsToBounds = true

        setupHeaderBottomView()
        setupCardView()

        tableView.tableHeaderView = headerView
    }

    private func setupHeaderBottomView() {
        headerView.addSubview(headerBottomView)

        headerBottomView.backgroundColor = R.color.background()

        headerBottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(130)
        }

        setupSectionLabel()
    }

    private func setupSectionLabel() {
        headerBottomView.addSubview(sectionLabel)

        sectionLabel.text = R.string.localizable.repositories()
        sectionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        sectionLabel.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16).priority(.high)
        }
    }

    private func setupCardView() {
        headerView.addSubview(cardView)

        cardView.backgroundColor = R.color.background()
        cardView.makeShadow()
        cardView.alpha = 0.95
        cardView.layer.cornerRadius = 10

        cardView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview().offset(100)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16).priority(.high)
            make.bottom.equalTo(sectionLabel.snp.top).offset(-16)
        }

        setupImageContainerView()
        setupNameAndDescriptionStackView()
        setupInfoStackView()

    }

    private func setupImageContainerView() {
        cardView.addSubview(imageContainerView)

        imageContainerView.backgroundColor = UIColor.white
        imageContainerView.makeShadow()
        imageContainerView.layer.cornerRadius = 50
        imageContainerView.layer.borderColor = UIColor.white.cgColor
        imageContainerView.layer.borderWidth = 1

        imageContainerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-40)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }

        setupPhotoImageView()
    }

    private func setupPhotoImageView() {
        imageContainerView.addSubview(photoImageView)

        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 50
        photoImageView.clipsToBounds = true

        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func setupNameAndDescriptionStackView() {
        cardView.addSubview(nameAndDescriptionStackView)

        nameAndDescriptionStackView.axis = .vertical
        nameAndDescriptionStackView.spacing = 4

        nameAndDescriptionStackView.snp.makeConstraints { (make) in
            make.top.equalTo(imageContainerView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        setupNameLabel()
        setupDescriptionLabel()
    }

    private func setupNameLabel() {
        nameAndDescriptionStackView.addArrangedSubview(nameLabel)

        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = R.color.textPrimary()
        nameLabel.textAlignment = .center
    }

    private func setupDescriptionLabel() {
        nameAndDescriptionStackView.addArrangedSubview(descriptionLabel)

        descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        descriptionLabel.textColor = R.color.textSecondary()
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 3
    }

    private func setupInfoStackView() {
        cardView.addSubview(infoStackView)

        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually

        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(nameAndDescriptionStackView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview().inset(16)
        }

        infoStackView.addArrangedSubview(followersUserInfoView)
        infoStackView.addArrangedSubview(publicReposUserInfoView)
        infoStackView.addArrangedSubview(followingUserInfoView)
    }

}

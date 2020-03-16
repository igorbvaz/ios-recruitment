//
//  UsersListCell.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import AlamofireImage

class UsersListCell: UITableViewCell {

    var photoImageView = UIImageView()
    var loginLabel = UILabel()

    var viewModel: UsersListItemViewModel! {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        loginLabel.text = viewModel.login
        photoImageView.image = nil
        photoImageView.af.setImage(withURL: viewModel.photo, imageTransition: .crossDissolve(0.5))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        setupPhotoImageView()
        setupLoginLabel()
    }

}

extension UsersListCell {
    private func setupPhotoImageView() {
        addSubview(photoImageView)

        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        photoImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(40)
            make.height.equalTo(40).priority(.high)
        }
    }

    private func setupLoginLabel() {
        addSubview(loginLabel)

        loginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(photoImageView.snp.right).offset(8)
            make.top.bottom.right.equalToSuperview().inset(16)
        }
    }
}

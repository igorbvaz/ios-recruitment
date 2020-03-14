//
//  UsersListView.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import SnapKit

class UsersListView: UIView {

    var tableView = UITableView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        setupAppearance()
        setupTableView()
    }

}

extension UsersListView {

    private func setupAppearance() {
        backgroundColor = R.color.background()
    }

    private func setupTableView() {
        addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0).priority(.high)
            make.left.right.bottom.equalToSuperview()
        }

    }
}

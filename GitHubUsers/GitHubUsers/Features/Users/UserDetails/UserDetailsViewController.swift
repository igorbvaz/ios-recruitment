//
//  UserDetailsViewController.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 15/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxDataSources

class UserDetailsViewController: ViewController<UserDetailsView> {

    var viewModel: UserDetailsViewModel!

    let dataSource = RxTableViewSectionedReloadDataSource<SectionViewModel<UserDetailsItemViewModel>>(configureCell: { _, _, _, _ -> UITableViewCell in
        return UITableViewCell()
    })

    init(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupOutputs()
        setupIntputs()
        viewModel.inputs.didLoad.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.tableView.backgroundView?.applyGradient(startColor: R.color.primary()!.cgColor, endColor: R.color.primaryDark()!.cgColor)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.transparent = false
        navigationController?.navigationBar.barTintColor = nil
    }

}

extension UserDetailsViewController {

    private func setupTableView() {
        let identifier = String(describing: UserDetailsItemCell.self)
        mainView.tableView.register(UserDetailsItemCell.self, forCellReuseIdentifier: identifier)

        dataSource.configureCell = { _, tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? UserDetailsItemCell else { return UserDetailsItemCell() }
            cell.viewModel = viewModel
            return cell
        }

        mainView.tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

        mainView.tableView.rx.willDisplayCell.bind(onNext: { [weak self] event in
            if event.indexPath.row == (self?.mainView.tableView.numberOfRows(inSection: 0) ?? 0) - 5 {
                self?.viewModel.loadNextPage.onNext(())
            }
        }).disposed(by: disposeBag)

        mainView.tableView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            guard let navigationBar = self?.navigationController?.navigationBar else { return }
            if (self?.mainView.tableView.contentOffset.y ?? CGFloat(0)) >= CGFloat(90) {
                navigationBar.transparent = false
                navigationBar.barTintColor = R.color.primary()
            } else {
                navigationBar.transparent = true
                navigationBar.barTintColor = nil
            }
        }).disposed(by: disposeBag)

    }

    private func setupOutputs() {
        viewModel.outputs.photoDriver.drive(mainView.photoImageView.rx.imageWithUrl).disposed(by: disposeBag)
        viewModel.outputs.nameDriver.drive(mainView.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.bioDriver.drive(mainView.descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.followersDriver.drive(mainView.followersUserInfoView.bottomLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.publicReposDriver.drive(mainView.publicReposUserInfoView.bottomLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.followingDriver.drive(mainView.followingUserInfoView.bottomLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.dataSource.drive(mainView.tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        viewModel.outputs.showUserDetailsEmptyStateDriver.drive(onNext: { [weak self] show in
            guard let this = self else { return }
            this.mainView.tableView.tableFooterView = show ? EmptyStateView(size: .init(width: this.mainView.bounds.width, height: this.mainView.tableView.bounds.height - (this.mainView.tableView.tableHeaderView?.bounds.height ?? 0)), text: R.string.localizable.noResults(), image: UIImage(systemName: "magnifyingglass")) : UIView()
        }).disposed(by: disposeBag)

        viewModel.outputs.showUserDetailsLoadingStateDriver.drive(onNext: { [weak self] show in
            guard let this = self else { return }
            let screenHeight = UIApplication.shared.windows.first?.bounds.height ?? 0
            let headerheight = this.mainView.tableView.tableHeaderView?.bounds.height ?? 0
            this.mainView.tableView.tableFooterView = show ? LoadingStateView(size: .init(width: 70, height: screenHeight - headerheight), text: R.string.localizable.loading()) : UIView()
        }).disposed(by: disposeBag)

        viewModel.outputs.errorDriver.drive(onNext: { [weak self] error in
            self?.showAlert(text: error)
        }).disposed(by: disposeBag)
    }

    private func setupIntputs() {

    }
}

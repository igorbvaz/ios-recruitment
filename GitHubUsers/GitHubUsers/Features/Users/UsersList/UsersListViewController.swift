//
//  UsersListViewController.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class UsersListViewController: ViewController<UsersListView> {

    var viewModel: UsersListViewModel!
    var shouldSearch = true

    let dataSource = RxTableViewSectionedReloadDataSource<SectionViewModel<UsersListItemViewModel>>(configureCell: { _, _, _, _ -> UITableViewCell in
        return UITableViewCell()
    })

    init(viewModel: UsersListViewModel) {
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
        setupAppearance()
        setupTableView()
        setupSearchController()
        setupOutputs()
        setupInputs()
        viewModel.inputs.didLoad.onNext(())
    }

}

extension UsersListViewController {

    private func setupAppearance() {
        title = R.string.localizable.gitHub()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        let identifier = String(describing: UsersListCell.self)
        mainView.tableView.register(UsersListCell.self, forCellReuseIdentifier: identifier)

        dataSource.configureCell = { _, tableView, indexPath, viewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? UsersListCell else { return UsersListCell() }
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

    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = R.string.localizable.searchGitHubUsers()
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false

        viewModel.outputs.searchTextDriver.drive(searchController.searchBar.rx.text).disposed(by: disposeBag)
    }

    private func setupOutputs() {
        viewModel.outputs.dataSource.drive(mainView.tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        viewModel.outputs.showUsersListEmptyStateDriver.drive(onNext: { [weak self] show in
            self?.mainView.tableView.tableFooterView = show ? EmptyStateView(size: .init(width: self?.view.bounds.width ?? 300, height: 160), text: R.string.localizable.noResults(), image: UIImage(systemName: "magnifyingglass")) : UIView()
        }).disposed(by: disposeBag)

        viewModel.outputs.showUsersListLoadingStateDriver.drive(onNext: { [weak self] show in
            self?.mainView.tableView.tableFooterView = show ? LoadingStateView(size: .init(width: 70, height: 70), text: R.string.localizable.loading()) : UIView()
        }).disposed(by: disposeBag)

        viewModel.outputs.errorDriver.drive(onNext: { [weak self] error in
            self?.showAlert(text: error)
        }).disposed(by: disposeBag)
    }

    private func setupInputs() {
        mainView.tableView.rx.modelSelected(UsersListItemViewModel.self).map { $0.basicUser }.bind(to: viewModel.inputs.basicUserSelected).disposed(by: disposeBag)
    }
}

extension UsersListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputs.searchTextPublishSubject.onNext(searchBar.text!)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.inputs.searchBarDidEndPublishSubject.onNext(())
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.cancelButtonTappedPublishSubject.onNext(())
    }

}

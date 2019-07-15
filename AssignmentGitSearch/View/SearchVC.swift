//
//  SearchVC.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    private var viewModel: SearchViewModel?
    @IBOutlet weak var lblNoSearch: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        self.registerCallback()
        self.registerTableViewCell()
        self.searchTableView.rowHeight = UITableView.automaticDimension
        self.searchTableView.estimatedRowHeight = 44.0
        self.showHideLblNoSearch()
        self.activity.stopAnimating()
        self.searchTableView.prefetchDataSource = self
    }
    
    private func registerCallback() {
        guard let viewModel = viewModel else { return }
        viewModel.didUpdate = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
                self.showHideLblNoSearch()
                self.activity.stopAnimating()
            }
        }
    }
    
    private func showHideLblNoSearch() {
        if let viewModel = viewModel, viewModel.numberOfRows() == 0 {
            self.lblNoSearch.isHidden = false
            return
        }
        self.lblNoSearch.isHidden = true
    }
    
    private func registerTableViewCell() {
        self.searchTableView.register(UserTableViewCell.nib(), forCellReuseIdentifier: UserTableViewCell.identifier)
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        DispatchQueue.main.async {
            self.activity.startAnimating()
            self.lblNoSearch.isHidden = true
        }
        GitServices.shared.fetchLogin(login: searchText) { (search, error) in
            guard error == nil, let search = search else { return }
            print("recieved object search - \(search)")
        }
        if let viewModel = viewModel  {
            viewModel.search(searchText: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "", let viewModel = viewModel {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                self.activity.startAnimating()
            }
            viewModel.clearSearch()
        }
    }
    
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        if let searchUser = viewModel.row(atIndex: indexPath) as? SearchedUser {
            if let cell = self.searchTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell {
                cell.configure(searchedUser: searchUser)
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension SearchVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
         guard let viewModel = viewModel else { return }
        if indexPaths.contains(where: viewModel.isLoadingCell) {
            viewModel.nextPage()
        }
    }
    
    
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userDetail = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC, let viewModel = viewModel, let login = viewModel.login(for: indexPath) {
            userDetail.login = login
            self.navigationController?.pushViewController(userDetail, animated: true)
        }
    }
}

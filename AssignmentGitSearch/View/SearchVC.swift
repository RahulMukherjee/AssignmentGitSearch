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
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        self.registerCallback()
        self.registerTableViewCell()
        self.searchTableView.rowHeight = UITableView.automaticDimension
        self.searchTableView.estimatedRowHeight = 44.0
    }
    
    private func registerCallback() {
        guard let viewModel = viewModel else { return }
        viewModel.didUpdate = { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
            }
        }
    }
    
    private func registerTableViewCell() {
        self.searchTableView.register(UserTableViewCell.nib(), forCellReuseIdentifier: UserTableViewCell.identifier)
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        GitServices.shared.fetchLogin(login: searchText) { (search, error) in
            guard error == nil, let search = search else { return }
            print("recieved object search - \(search)")
        }
        if let viewModel = viewModel  {
            viewModel.search(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let viewModel = viewModel  {
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
                return cell
            }
        }
        return UITableViewCell()
    }
}

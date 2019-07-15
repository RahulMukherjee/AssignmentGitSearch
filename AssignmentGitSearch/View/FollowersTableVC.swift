//
//  FollowersTableVC.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import UIKit

class FollowersTableVC: UIViewController {

    @IBOutlet weak var followersTable: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    private var viewModel: FollowersViewModel?
    var login: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        self.followersTable.rowHeight = UITableView.automaticDimension
        self.followersTable.estimatedRowHeight = 44.0
        self.activity.startAnimating()
        if let login = login {
            viewModel = FollowersViewModel(login: login)
            self.registerCallback()
        }
        self.title = "Followers"
    }

    private func registerTableViewCell() {
        self.followersTable.register(UserTableViewCell.nib(), forCellReuseIdentifier: UserTableViewCell.identifier)
    }
    
    private func registerCallback() {
        guard let viewModel = viewModel else { return }
        viewModel.didUpdate = { [weak self] _ in
            DispatchQueue.main.async {
                self?.followersTable.reloadData()
                self?.activity.stopAnimating()
            }
            
        }
    }
}

extension FollowersTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.numberOfRows()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        if let searchUser = viewModel.row(atIndex: indexPath) as? SearchedUser {
            if let cell = self.followersTable.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell {
                cell.configure(searchedUser: searchUser)
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}

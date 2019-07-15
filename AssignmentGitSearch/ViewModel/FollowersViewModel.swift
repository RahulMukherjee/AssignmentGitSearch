//
//  FollowersViewModel.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

class FollowersViewModel {
    private(set) var rows = [Row]()
    var login: String?
    
    //closure to be register by View Controller
    var didUpdate: ((FollowersViewModel)->Void)?
    
    init(login: String) {
        self.login = login
        self.buildData()
    }
    
    ///get the Row against indexpath
    public func row(atIndex indexpath: IndexPath) -> Row? {
        if indexpath.row < rows.count {
            return rows[indexpath.row]
        }
        return nil
    }
    
    ///Total number of rows
    public func numberOfRows() -> Int {
        return rows.count
    }
}

extension FollowersViewModel {
    ///Build and prepare cell data, once donw then initated the callback
    private func buildData() {
        rows = [Row]()
        if let login = login {
            GitServices.shared.fetchFollowers(login: login) { (searchedUser, error) in
                guard error == nil, let searchedUser = searchedUser else { return }
                self.rows = searchedUser
                self.didUpdate?(self)
            }
        }
    }
}

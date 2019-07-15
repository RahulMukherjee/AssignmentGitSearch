//
//  SearchViewModel.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

class SearchViewModel {
    private(set) var rows = [Row]()
    private var totalCount: Int = 0
    private var searchText: String?
    private var currentPage = 1
    
    //closure to be register by View Controller
    var didUpdate: ((SearchViewModel)->Void)?
    
    init() {
        self.buildData()
    }
    
    /// Call to search function to search for git user. Each time search call, fresh data get generated
    public func search(searchText: String) {
        self.currentPage = 1
        rows = [Row]()
        self.searchText = searchText
        self.buildData()
    }
    
    ///Get the Row against indexpath
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
    
    ///Refresh the viewModel data
    public func refreshData() {
        self.buildData()
    }
    
    ///Clear search data
    public func clearSearch() {
        self.currentPage = 1
        self.searchText = nil
        rows = [Row]()
        self.didUpdate?(self)
    }
    
    ///Prefetch/Fetch next page data
    public func nextPage() {
        guard self.numberOfRows() < totalCount else { return }
        self.buildData()
    }
    
    public func login(for indexPath: IndexPath) -> String? {
        if indexPath.row < rows.count, let searchedUser =  rows[indexPath.row] as? SearchedUser {
            return searchedUser.login
        }
        return nil
    }
    
    ///Return if it is loading cell, i.e last cell
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.numberOfRows() - 1
    }
    
}


extension SearchViewModel {
    ///Build and prepare cell data, once donw then initated the callback
    private func buildData() {
        if currentPage == 1 {
            rows = [Row]()
        }
        guard let searchText = searchText else { return }
        GitServices.shared.fetchLogin(login: searchText, page: "\(currentPage)") { (search, error) in
            guard error == nil, let search = search else { return }
            self.rows.append(contentsOf: search.items)
            self.totalCount = search.totalCount
            self.currentPage += 1
            self.didUpdate?(self)
        }
    }
}

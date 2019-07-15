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
    
    public func search(searchText: String) {
        self.clearSearch()
        self.searchText = searchText
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
    
    ///Refresh the viewModel data
    public func refreshData() {
        self.buildData()
    }
    
    public func clearSearch() {
        self.currentPage = 1
        self.searchText = nil
        rows = [Row]()
        self.didUpdate?(self)
    }
    
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
    
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.numberOfRows() - 1
    }
    
//    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath],indexPathsForVisibleRows: [IndexPath] = []) -> [IndexPath] {
//        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
//        return Array(indexPathsIntersection)
//    }
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

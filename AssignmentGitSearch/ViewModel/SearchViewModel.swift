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
    private var totalCount: Int?
    private var searchText: String?
    
    //closure to be register by View Controller
    var didUpdate: ((SearchViewModel)->Void)?
    
    init() {
        self.buildData()
    }
    
    public func search(searchText: String) {
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
        self.searchText = nil
        rows = [Row]()
        self.didUpdate?(self)
    }
    
    public func nextPage() {
        
    }
}


extension SearchViewModel {
    ///Build and prepare cell data, once donw then initated the callback
    func buildData() {
        rows = [Row]()
        guard let searchText = searchText else { return }
        GitServices.shared.fetchLogin(login: searchText) { (search, error) in
            guard error == nil, let search = search else { return }
            self.rows = search.items
            self.totalCount = search.totalCount
            self.didUpdate?(self)
        }
    }
}

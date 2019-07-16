//
//  SearchViewModelTests.swift
//  AssignmentGitSearchTests
//
//  Created by Rahul Mukherjee on 16/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import XCTest

class SearchViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchViewModel() {
        let viewModel = SearchViewModel()
        viewModel.search(searchText: "rahul")
        sleep(5)  //Wait for API call and data build
        let page1Count = viewModel.numberOfRows()
        XCTAssertTrue(page1Count > 0)
        XCTAssertNotNil(viewModel.row(atIndex: IndexPath(item: 0, section: 0)))
        viewModel.nextPage()
        sleep(5)  //Wait for API call and data build
        let page2Count = viewModel.numberOfRows()
        XCTAssertTrue(page2Count > 0)
         XCTAssertTrue(page2Count > page1Count)
        viewModel.clearSearch()
        XCTAssertTrue(viewModel.numberOfRows() == 0)
    }

}

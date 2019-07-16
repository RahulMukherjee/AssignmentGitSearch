//
//  FollowersViewModelTests.swift
//  AssignmentGitSearchTests
//
//  Created by Rahul Mukherjee on 16/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import XCTest

class FollowersViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFollowersViewModel() {
        let viewModel = FollowersViewModel(login: "rahul")
        sleep(5)  //Wait for API call and data build
        let page1Count = viewModel.numberOfRows()
        XCTAssertTrue(page1Count > 0)
        XCTAssertNotNil(viewModel.row(atIndex: IndexPath(item: 0, section: 0)))
    }

}

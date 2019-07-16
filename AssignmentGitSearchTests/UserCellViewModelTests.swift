//
//  UserCellViewModelTests.swift
//  AssignmentGitSearchTests
//
//  Created by Rahul Mukherjee on 16/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import XCTest

class UserCellViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserCellViewModel() {
        let searchedUser = SearchedUser(login: "rahul", avatarUrl: "http://example.com")
        let viewModel = UserCellViewModel(user: searchedUser)
        XCTAssertTrue(viewModel.userName != "")
        XCTAssertNotNil(viewModel.url)
    }

}

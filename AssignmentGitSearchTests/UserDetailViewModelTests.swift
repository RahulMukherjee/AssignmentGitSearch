//
//  UserDetailViewModelTests.swift
//  AssignmentGitSearchTests
//
//  Created by Rahul Mukherjee on 16/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import XCTest

class UserDetailViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserDetailViewModel() {
        let viewModel = UserDetailViewModel(login: "rahul")
        sleep(5)  //Wait for API call and data build
        XCTAssertNotNil(viewModel.avatarUrl)
        XCTAssertTrue(viewModel.name != "")
    }

}

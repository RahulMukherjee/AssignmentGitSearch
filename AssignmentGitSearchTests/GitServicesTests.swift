//
//  GitServicesTests.swift
//  AssignmentGitSearchTests
//
//  Created by Rahul Mukherjee on 16/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import XCTest

class GitServicesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchLogin() {
        let expexted = self.expectation(description: "myExpectation")
        GitServices.shared.fetchLogin(login: "rahul mukherjee") { (search,error) in
            if error != nil {
                XCTFail("Got error on API call")
                return
            }
            XCTAssertNotNil(search)
            expexted.fulfill()
        }
        self.waitForExpectations(timeout: 20)
    }
    
    func testFetchUser() {
        let expexted = self.expectation(description: "myExpectation")
        GitServices.shared.fetchUser(login: "rahul") { (user,error) in
            if error != nil {
                XCTFail("Got error on API call")
                return
            }
            XCTAssertNotNil(user)
            expexted.fulfill()
        }
        self.waitForExpectations(timeout: 20)
    }

    func testFetchFollowers() {
        let expexted = self.expectation(description: "myExpectation")
        GitServices.shared.fetchFollowers(login: "rahul") { (users,error) in
            if error != nil {
                XCTFail("Got error on API call")
                return
            }
            XCTAssertNotNil(users)
            expexted.fulfill()
        }
        self.waitForExpectations(timeout: 20)
    }
    
}

//
//  Models.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

protocol Row {
}

struct Search: Codable {
    var totalCount: Int
    var items: [SearchedUser]
}

struct SearchedUser: Codable, Row {
    var login: String
    var avatarUrl: String
}

struct User: Codable, Row {
    var login: String
    var id: Int
    var avatarUrl: String?
    var followersUrl: String
    var name: String
    var location: String?
    var publicRepos: Int?
    var publicGists: Int?
    var followers: Int?
    var updatedAt: String
}

struct NextLoading: Row {
    var currentPage: Int = 1
}

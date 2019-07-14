//
//  Errors.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

public enum GITServicesError: Error {
    case invalidURL
    case unknownError(String)
}

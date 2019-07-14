//
//  UserCellViewModel.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 14/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

class UserCellViewModel {
    
    private var user: SearchedUser
    public var userImageData:((Data)->Void)?
    
    init(user: SearchedUser) {
        self.user = user
        self.downloadImage()
    }
    public var userName: String {
        return user.login
    }
    public var url: URL? {
        return URL(string: user.avatarUrl)
    }
    
    private func downloadImage() {
        guard let url = URL(string: user.avatarUrl) else { return }
        GitServices.shared.getImageData(url: url) { (data, response, error) in
            guard let imageData = data, error == nil else { return }
            self.userImageData?(imageData)
        }
    }
    
    
}

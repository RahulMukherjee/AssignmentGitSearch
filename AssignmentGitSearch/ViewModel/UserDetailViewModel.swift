//
//  UserDetailViewModel.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

class UserDetailViewModel {
    public var login: String
    private var user: User?
    public var userDataAvailable:((UserDetailViewModel)->Void)?
    public var userImageData:((Data)->Void)?
    var errorOccured: ((Error?)->Void)?
    
    public var followersUrl: URL? {
        if let user = user {
            return URL(string: user.followersUrl)
        }
        return nil
    }
    
    ///Download user image data
    public func downloadUserImage() {
        self.downloadImage()
    }
    
    public var username: String {
        return user?.login ?? ""
    }
    
    public var name: String {
        return user?.name ?? ""
    }
    
    public var location: String {
        return user?.location ?? ""
    }
    public var publicRepos: String {
        return String(user?.publicRepos ?? 0)
    }
    
    public var publicGists: String {
        return String(user?.publicGists ?? 0)
    }
    
    public var followers: String {
        return String(user?.followers ?? 0)
    }
    
    public var showFollowers: Bool {
        if let user = user, let followersCount = user.followers  {
            return followersCount > 0
        }
        return false
    }
    
    var updatedAt: String {
        return "Last Updated at - " + (user?.updatedAt ?? "")
    }
    
    var avatarUrl: URL? {
        if let user = user {
            return URL(string: user.avatarUrl)
        }
        return nil
    }
    
    init(login: String) {
        self.login = login
        self.buildData()
    }
}

extension UserDetailViewModel {
    private func buildData() {
        GitServices.shared.fetchUser(login: self.login) { (user, error) in
            guard error == nil, let user = user else { return }
            self.user = user
            self.userDataAvailable?(self)
        }
    }
    
    private func downloadImage() {
        guard let user = user else {
            return
        }
        guard let url = URL(string: user.avatarUrl) else { return }
        GitServices.shared.getImageData(url: url) { (data, response, error) in
            guard let imageData = data, error == nil else {
                self.errorOccured?(error)
                return
            }
            self.userImageData?(imageData)
        }
    }
}

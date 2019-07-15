//
//  UserDetailVC.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import UIKit

class UserDetailVC: UIViewController {

    @IBOutlet weak var btnViewFollowers: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalFollowers: UILabel!
    @IBOutlet weak var lblPublicRepo: UILabel!
    @IBOutlet weak var lblLastUpdatedAt: UILabel!
    @IBOutlet weak var lblTotalGist: UILabel!
    var login: String?
    var viewModel: UserDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let login = login {
            viewModel = UserDetailViewModel(login: login)
            self.bindCallback()
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height / 2
            self.imgUser.layer.borderColor = UIColor.red.cgColor
            self.imgUser.layer.borderWidth = 1.0
            self.imgUser.layer.masksToBounds = true
            self.imgUser.image = UIImage(named: "userPlace")
            self.btnViewFollowers.isHidden = true
        }
        self.title = "User Detail"
    }
    
    func bindCallback() {
        guard let viewModel = viewModel else { return }
        viewModel.userDataAvailable = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.lblUserName.text = viewModel.login
                self.lblLocation.text = viewModel.location
                self.lblName.text = viewModel.name
                self.lblTotalFollowers.text = viewModel.followers
                self.lblPublicRepo.text = viewModel.publicRepos
                self.lblLastUpdatedAt.text = viewModel.updatedAt
                self.lblTotalGist.text = viewModel.publicGists
                if let imageUrl = viewModel.avatarUrl, let cacheImage = isCacheImage(url: imageUrl) {
                    self.imgUser.image = cacheImage
                    AppLog(">> Found image in cache")
                } else {
                    viewModel.downloadUserImage()
                }
                if viewModel.showFollowers {
                    self.btnViewFollowers.isHidden = false
                }
                self.view.setNeedsLayout()
            }
        }
        
        viewModel.userImageData = { [weak self] (imageData) in
            guard let self = self, let imageUrl = viewModel.avatarUrl else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                cacheImage(image: image!, url: imageUrl)
                self.imgUser.image = image
                AppLog(">> Downloaded and saved image to cache")
                self.view.setNeedsLayout()
            }
        }
        
        viewModel.errorOccured = { [weak self] error in
            guard let self = self, error != nil else { return }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Some issue occured while fetching data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func btnViewFollowersTapped(_ sender: Any) {
        if let followersTVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowersTableVC") as? FollowersTableVC, let login = login {
            followersTVC.login = login
            self.navigationController?.pushViewController(followersTVC, animated: true)
        }
    }

}

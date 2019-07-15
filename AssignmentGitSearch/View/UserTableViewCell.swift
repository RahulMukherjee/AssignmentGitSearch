//
//  UserTableViewCell.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 11/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var viewLbl: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    private var viewModel: UserCellViewModel?
    public static let identifier = "UserTableViewCell"
    public static func nib()-> UINib {
        return UINib(nibName: "UserTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(searchedUser: SearchedUser) {
        viewModel = UserCellViewModel(user: searchedUser)
        guard let viewModel = viewModel else { return }
        self.lblName.text = viewModel.userName
        self.viewLbl.layer.cornerRadius = 6
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height / 2
        self.imgUser.layer.borderColor = UIColor.red.cgColor
        self.imgUser.layer.borderWidth = 1.0
        self.imgUser.layer.masksToBounds = true
        self.imgUser.image = UIImage(named: "userPlace")
        self.processImage()
    }
    
    private func processImage() {
         guard let viewModel = viewModel else { return }
        guard let imageUrl = viewModel.url else { return }
        if let cacheImage = isCacheImage(url: imageUrl) {
            self.imgUser.image = cacheImage
            AppLog(">> Found image in cache")
            self.setNeedsLayout()
        } else {
            viewModel.userImageData = { [weak self] (imageData) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    cacheImage(image: image!, url: imageUrl)
                    self.imgUser.image = image
                    AppLog(">> Downloaded and saved image to cache")
                    self.setNeedsLayout()
                }
                
            }
        }
    }
    
}

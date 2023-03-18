//
//  ProfileHeader.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 30.01.2023.
//

import LBTATools
import SDWebImage

class ProfileHeader: UICollectionReusableView {
    
    let settingsButton = UIButton(image: UIImage(systemName: "gear")!, tintColor: .black, target: self, action: #selector(handleSettings))
    
    let profileImageView = CircularImageView(width: 100)
    
    let followButton = UIButton(title: "Follow", titleColor: .white, font: .boldSystemFont(ofSize: 13), target: self, action: #selector(handleFollow))
    
    let messageButton = UIButton(title: "Message", titleColor: .white, font: .boldSystemFont(ofSize: 13), backgroundColor: UIColor(cgColor: CGColor(gray: 0.15, alpha: 1)), target: self, action: #selector(handleMessageSend))
    
    let editProfileButton = UIButton(title: "Edit Profile", titleColor: .white,font: .boldSystemFont(ofSize: 13), backgroundColor: UIColor(#colorLiteral(red: 1, green: 0.3475894928, blue: 0, alpha: 1)), target: self, action: #selector(handleEditProfile))
    
    let postCountLabel = UILabel(text: "12", font: .boldSystemFont(ofSize: 15), textColor: .black, textAlignment: .center)
    let postLabel = UILabel(text: "posts", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followersCountLabel = UILabel(text: "12", font: .boldSystemFont(ofSize: 13), textColor: .black, textAlignment: .center)
    let followersLabel = UILabel(text: "followers", font: .systemFont(ofSize: 13),textColor: .lightGray, textAlignment: .center)
    
    let followingCountLabel = UILabel(text: "12", font: .boldSystemFont(ofSize: 13), textColor: .black, textAlignment: .center)
    let followingLabel = UILabel(text: "following", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let fullNameLabel = UILabel(text: "full name", font: .boldSystemFont(ofSize: 13), textColor: .black, textAlignment: .center)
    
    let bioLabel = UILabel(text: "", font: .systemFont(ofSize: 13), textColor: .darkGray, numberOfLines: 0)
    
    @objc func handleSettings() {
        
    }
    

    @objc fileprivate func handleMessageSend() {
        
    }

    @objc fileprivate func handleEditProfile() {
        //profileController?.changeProfileImage()
        profileController?.goToEdit()
    }
    
    @objc fileprivate func handleFollow() {
        profileController?.handleFollowUnfollow()
    }
    
    var user: User! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? ""))
            
            fullNameLabel.text = user.fullName
            
            followButton.setTitle(user.isFollowing == true ? "Unfollow" : "Follow", for: .normal)
            followButton.setTitleColor(user.isFollowing == true ? .white : .black, for: .normal)
            followButton.backgroundColor = user.isFollowing == true ? UIColor(cgColor: CGColor(gray: 0.15, alpha: 1)) : .white
            
            if user.isEditable == true {
                followButton.removeFromSuperview()
                messageButton.removeFromSuperview()
            } else {
                editProfileButton.removeFromSuperview()
            }
            
            postCountLabel.text = "\(user.posts?.count ?? 0)"
            
            followersCountLabel.text = "\(user.followers?.count ?? 0)"
            
            followingCountLabel.text = "\(user.following?.count ?? 0)"
            
            bioLabel.text = user.bio
            
        }
    }
    
    weak var profileController: ProfileController?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfile)))
        
        
        followButton.layer.cornerRadius = 6
        followButton.layer.borderWidth = 1
        messageButton.layer.cornerRadius = 6
        messageButton.layer.borderWidth = 1
        
        editProfileButton.layer.cornerRadius = 8
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 1
        
       
        stack(
            profileImageView,
            hstack(followButton.withSize(.init(width: 160, height: 28)),
                   messageButton.withSize(.init(width: 160, height: 28)), spacing: 6).padLeft(14).padRight(14),
            editProfileButton.withSize(.init(width: 160, height: 28)),
            hstack(stack(postCountLabel, postLabel),
                   stack(followersCountLabel, followersLabel),
                   stack(followingCountLabel, followingLabel),
                   spacing: 20, alignment: .center),
            fullNameLabel,
            bioLabel,
            spacing: 15,
            alignment: .center
        ).withMargins(.allSides(14))
        
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
    }
    
    let separatorView = UIView(backgroundColor: .init(white: 0.4, alpha: 0.3))
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//
//  UserPostCell.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 29.01.2023.
//

import LBTATools
import SDWebImage

protocol PostDelegate {
    func showComment(post: Post)
    func showOptions(post: Post)
    func handleLike(post: Post)
    func showLikes(post: Post)
    func userProfile(post: Post)
}

class UserPostCell: LBTAListCell<Post> {
    
    let profileImageView = CircularImageView(width: 44, image: UIImage(systemName: "person"))
    
    let usernameLabel = UILabel(text: "username", font: .boldSystemFont(ofSize: 15), textColor: .labelsColor)
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "text", font: .systemFont(ofSize: 15), textColor: .labelsColor  ,numberOfLines: 0)
    
    lazy var likeButton = UIButton(image: UIImage(systemName: "suit.heart")!,
                                      tintColor: .black, action: #selector(handleLike))
    
    lazy var commentButton = UIButton(image: UIImage(systemName: "text.bubble")!, tintColor: .iconColor, action: #selector(handleComment))
    
    lazy var optionsButton = UIButton(image: UIImage(systemName: "ellipsis")!,tintColor: .labelsColor, target: self, action: #selector(handleOptions))
    
    let likeCountsButton = UIButton(title: "0 likes", titleColor: .labelsColor, font: .boldSystemFont(ofSize: 14), target: self, action: #selector(handleShowLikes))
    
    let fromNowLabel = UILabel(text: "Posted 5d ago", textColor: .gray)
    
    @objc fileprivate func handleShowLikes() {
        (parentController as? PostDelegate)?.showLikes(post: item)
    }
    
    @objc fileprivate func handleLike() {
        (parentController as? PostDelegate)?.handleLike(post: item)
    }
    
    @objc fileprivate func handleComment() {
        (parentController as? PostDelegate)?.showComment(post: item)
    }
    
    
    @objc fileprivate func handleOptions() {
        (parentController as? PostDelegate)?.showOptions(post: item)
    }
    
    var newImageView: UIImageView?
    
    @objc func goToUserPorfile(sender: UITapGestureRecognizer) {
        (parentController as? PostDelegate)?.userProfile(post: item)
    }
    
    override var item: Post! {
        didSet {
            usernameLabel.text = item.user.fullName
            postImageView.sd_setImage(with: URL(string: item.imageUrl))
            postTextLabel.text = item.text
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? ""))
            fromNowLabel.text = item.fromNow
            
            if item.hasLiked == true {
                likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                likeButton.tintColor = .red
            } else {
                likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                likeButton.tintColor = .iconColor
            }
            
            
            likeCountsButton.setTitle("\(item.likesCount) likes", for: .normal)
            
            
        }
    }
    
    var imageHeightAnchor: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageHeightAnchor.constant = frame.width
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .viewBackgroundColor
        imageHeightAnchor = postImageView.heightAnchor.constraint(equalToConstant: 0)
        imageHeightAnchor.isActive = true
        
        //add to gesture
        let tapGs = UITapGestureRecognizer(target: self, action: #selector(goToUserPorfile))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.borderWidth = 0.5
        profileImageView.addGestureRecognizer(tapGs)
        
        
        stack(hstack(profileImageView,
                     stack(usernameLabel, fromNowLabel),
                     UIView(),
                     optionsButton.withWidth(25), spacing: 8).padLeft(16).padRight(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              hstack(likeButton, commentButton, UIView(), spacing: 6).padLeft(16),
              hstack(likeCountsButton, UIView(), spacing: 8).padLeft(16),
              spacing: 12).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
    }
    
}

 

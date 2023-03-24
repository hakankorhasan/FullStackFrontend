//
//  UserSearchCell.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 29.01.2023.
//

import LBTATools
import Alamofire
import SDWebImage

protocol SearchDelegate{
    func goUser(user: User)
}

extension UserSearchController {
    
    func didFollow(user: User) {
        
        guard let index = items.firstIndex(where: {$0.id == user.id}) else { return }
        
        let isFollowing = user.isFollowing == true
        
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { (dataResponse) in
                if let error = dataResponse.error {
                    print("Failed to unfollow: ",error)
                    return
                }
                
                self.items[index].isFollowing = !isFollowing
                self.collectionView.reloadItems(at: [[0, index]])
                
            }
        
    }
}

class UserSearchCell: LBTAListCell<User> {
    
    
    // profil fotoğrafı eklenecek
    
    let profileImageView = CircularImageView(width: 33, image: UIImage(systemName: "person"))
    
    let nameLabel = UILabel(text: "Full Name", font: .systemFont(ofSize: 16, weight: .regular), textColor: .black)
    
    lazy var followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleFollow))
    
    @objc fileprivate func handleFollow() {
        
        (parentController as? UserSearchController)?.didFollow(user: item)
        
    }
    
    override var item: User! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl ?? ""))
            nameLabel.text = item.fullName
            
            if item.isFollowing == true {
                followButton.backgroundColor = .black
                followButton.setTitleColor(.white, for: .normal)
                followButton.setTitle("Unfollow", for: .normal)
            } else {
                followButton.backgroundColor = .white
                followButton.setTitleColor(.black, for: .normal)
                followButton.setTitle("Follow", for: .normal)
            }
            
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        followButton.layer.cornerRadius = 15
        followButton.layer.borderWidth = 1
        
        
        hstack(profileImageView, UIView().withWidth(12), nameLabel,
        UIView(),
               followButton.withWidth(100).withHeight(28), alignment: .center).padLeft(24).padRight(24)
        

        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
        
        
    }
}

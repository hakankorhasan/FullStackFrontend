//
//  MessageController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 26.02.2023.
//

import UIKit
import LBTATools
import SDWebImage
import Alamofire


class MessageCell: LBTAListCell<User> {
    
    let profileImageView = CircularImageView(width: 44, image: UIImage(systemName: "person"))
    
    let fullNameLabel = UILabel(text: "fullName")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(goToMessage))
        self.addGestureRecognizer(tapGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func goToMessage() {
        let messageController = ViewController()
        parentController?.navigationController?.pushViewController(messageController, animated: true)
    }
    
    override func setupViews() {
        super.setupViews()
        
        hstack(profileImageView,
               fullNameLabel,
               spacing: 12,
               alignment: .center).withMargins(.allSides(16))
        
        
        addSeparatorView(leadingAnchor: profileImageView.leadingAnchor)

    }
    
    override var item: User! {
        didSet {
           
                fullNameLabel.text = item.fullName
                profileImageView.sd_setImage(with: URL(string: item.profileImageUrl ?? ""))
            
        }
    }
    
}


class AddMessageController: LBTAListController<MessageCell, User> {
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My followed"

        fetchUsers()
        
    }
    
    func fetchUsers(){
        Service.shared.followingForUsers { (res) in
            switch res {
            case .failure(let err):
                print("error:", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddMessageController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

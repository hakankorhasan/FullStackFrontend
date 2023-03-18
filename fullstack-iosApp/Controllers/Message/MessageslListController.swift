//
//  MessageslListController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 1.03.2023.
//

import UIKit
import LBTATools
import SDWebImage


class MessagesListCell: LBTAListCell<User> {
    
    let profileImageView = CircularImageView(width: 44, image: UIImage(systemName: "person"))
    
    let fullNameLabel = UILabel(text: "selam")
    
    let online = UIImageView(image: UIImage(systemName: "smallcircle.filled.circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(goToMessages))
        self.addGestureRecognizer(tapGes)
    }
    
    @objc fileprivate func goToMessages() {
        let messageController = ViewController()
        messageController.modalPresentationStyle = .fullScreen
        print(item.fullName)
        parentController?.navigationController?.pushViewController(messageController, animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        online.tintColor = .green
        
        hstack(profileImageView,
               fullNameLabel,
               UIView(),
               online,
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

class MessagesListController: LBTAListController<MessagesListCell, User>, UINavigationControllerDelegate {
    
    let userId: String
    
    init(userId: String) {
        print(userId)
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "plus.message"), style: .done, target: self, action: #selector(goToFollowedList))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        fetchMessagedUser()
    }
    
    @objc fileprivate func goToFollowedList() {
        let navController = AddMessageController(userId: "")
        navController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(navController, animated: true)
    }
    
    func fetchMessagedUser() {
        
        Service.shared.followingForUsers { res in
            switch res {
            case .failure(let err):
                print("err", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
        }
    }
    
    
}

extension MessagesListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


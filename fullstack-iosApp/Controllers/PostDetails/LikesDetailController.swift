//
//  LikesDetailController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 23.02.2023.
//

import LBTATools
import SDWebImage
import Alamofire

class LikesCell: LBTAListCell<Like> {
    
    let profileImageView = CircularImageView(width: 44, image: UIImage(systemName: "person"))
    
    let fullNameLabel = UILabel(text: "fullname", textColor: .labelsColor)
    
    override func setupViews() {
        super.setupViews()
        
        hstack(profileImageView,
               fullNameLabel,
               spacing: 12,
               alignment: .center).withMargins(.allSides(16))
        
        addSeparatorView(leadingAnchor: profileImageView.leadingAnchor)
        
    }
    
    override var item: Like! {
        didSet {
            fullNameLabel.text = item.user.fullName
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? ""))
        }
    }
}

class LikesDetailController: LBTAListController<LikesCell, Like> {
    
    let postId: String
    
    init(postId: String){
        self.postId = postId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Likes"
        setupActivityIndicatorView()
        fetchLikes()
    }
    
    fileprivate func fetchLikes() {
        
        let url = "\(Service.shared.baseUrl)/likes/\(postId)"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                self.activityIndicatorView.stopAnimating()
                
                guard let data = dataResp.data else { return }
                
                do {
                    let likes = try JSONDecoder().decode([Like].self, from: data)
                    self.items = likes
                    print(likes)
                    self.collectionView.reloadData()
                } catch(let err) {
                    print("decoding error: ", err)
                }
            }
    }
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.startAnimating()
        aiv.color = .darkGray
        
        return aiv
    }()
    
    fileprivate func setupActivityIndicatorView() {
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LikesDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

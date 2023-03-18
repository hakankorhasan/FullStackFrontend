//
//  NavBarController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 24.02.2023.
//

import LBTATools
import Alamofire

class NavBarCell: LBTAListCell<User> {
    
    let logoutButton = UIButton(image: UIImage(systemName: "figure.walk.arrival") ?? #imageLiteral(resourceName: "sosyal-fon1"), tintColor: .black, target: self, action: #selector(handleExit))
    
    let fullNameLabel = UILabel(text: "hakan körhasan", font: .boldSystemFont(ofSize: 16))
    
    let searchUserButton = UIButton(image: UIImage(systemName: "magnifyingglass") ?? #imageLiteral(resourceName: "sosyal-fon1"), tintColor: .black, target: self, action: #selector(handleSearch))
    
    
    override var item: User! {
        didSet {
            fullNameLabel.text = item.fullName
        }
    }
    
    
    @objc fileprivate func handleExit() {
        
    }
    
    @objc fileprivate func handleSearch() {
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        hstack(logoutButton, UIView(), fullNameLabel, UIView(), searchUserButton).padLeft(16).padRight(16)
        
        addSeparatorView(leadingAnchor: logoutButton.leadingAnchor)
    }
}

class NavBarController: LBTAListController<NavBarCell, User> {
    
    
    let userId: String
    var user: User?
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        
        let url = "\(Service.shared.baseUrl)/profile"
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                
                if let error = dataResp.error {
                    print("error", error)
                    return
                }
                
                let data = dataResp.data ?? Data()
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.user = user
                } catch (let err) {
                    print("decoding error:", err)
                }
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavBarController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
}

//
//  ProfileController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 29.01.2023.
//

import LBTATools
import WebKit
import Alamofire
import SDWebImage
import JGProgressHUD
import CoreData

extension ProfileController: PostDelegate {
    func userProfile(post: Post) {
        let currentUrl = post.user.id
        let userProfile = ProfileController(userId: currentUrl == user?.id ? "" : currentUrl)
        navigationController?.pushViewController(userProfile, animated: true)
    }
    
    func showLikes(post: Post) {
        let likesViewController = LikesDetailController(postId: post.id)
        navigationController?.pushViewController(likesViewController, animated: true)
    }
    
    func handleLike(post: Post) {
        
        let hasLiked = post.hasLiked == true
        
        let likeOrDislike = hasLiked ? "dislike" : "like"
        
        let url = "\(Service.shared.baseUrl)/\(likeOrDislike)/\(post.id)"
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                
                guard let indexOfPost = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                self.items[indexOfPost].hasLiked?.toggle()
                self.items[indexOfPost].likesCount += hasLiked ? -1 : 1
                let indexPath = IndexPath(item: indexOfPost, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }
    }
    
    func showOptions(post: Post) {
        let alertController = UIAlertController(title: "Options", message: nil,
                                                preferredStyle: .actionSheet)
        let currentUrl = post.user.id
        
        alertController.addAction(.init(title: currentUrl == user?.id ? "Delete Post" : "Remove From Feed", style: .destructive,
                                        handler: { (_) in
            
            let deleteUrl = "\(Service.shared.baseUrl)/post/\(post.id)"
            let removeFeed = "\(Service.shared.baseUrl)/feeditem/\(post.id)"
            let url = currentUrl == self.user?.id ? deleteUrl : removeFeed
            
            AF.request(url, method: .delete)
                .validate(statusCode: 200..<300)
                .responseData(emptyResponseCodes: [200, 204, 205]) { (dataResp) in
                    if let error = dataResp.error {
                        print("Failed to delete", error)
                        return
                    }
                    
                    guard let index = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                    self.items.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                    self.collectionView.reloadData()
                }
        }))
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func showComment(post: Post) {
        let detailsViewController = PostDetailController(postId: post.id)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

class ProfileController: LBTAListHeaderController<UserPostCell, Post, ProfileHeader> {
    
    
    let userId: String
    var user: User?
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    @objc fileprivate func handleSetting() {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let alertController2 = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        let alertController3 = UIAlertController(title: "Are you sure you want to delete your user account? This action cannot be undone and all of your account data will be lost. Click 'Ok' to proceed, or click the 'Cancel' button to cancel the operation.", message: nil, preferredStyle: .alert)
        
        let url = "\(Service.shared.baseUrl)/api/v1/account/logout"
        
        let deleterUserUrl = "\(Service.shared.baseUrl)/destroy"
        
        alertController.addAction(.init(title: "Log out", style: .destructive, handler: { (_) in
            
            alertController2.addAction(.init(title: "Ok", style: .destructive, handler: { (_) in
                AF.request(url)
                    .validate(statusCode: 200..<300)
                    .responseData { (dataResp) in
                        if let error = dataResp.error {
                            print("error logout", error)
                            return
                        } else {
                            let navController = UINavigationController(rootViewController: LoginController())
                            navController.modalPresentationStyle = .fullScreen
                            NSManagedObject().setIsLogged(false)
                            self.present(navController, animated: true)
                        }
                    }
            }))
            
            alertController2.addAction(.init(title: "Cancel", style: .cancel))
            self.present(alertController2, animated: true)
            self.present(alertController, animated: true)
            
        }))
        
        alertController.addAction(.init(title: "Delete this account", style: .destructive, handler: { (_) in
            
            alertController3.addAction(.init(title: "Ok", style: .destructive, handler: { (_) in
                AF.request(deleterUserUrl, method: .delete)
                    .validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                        case .success:
                            let navController = UINavigationController(rootViewController: LoginController())
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true)
                        case .failure(let err):
                            print("error delete account:", err)
                        }
                    }
            }))
            
            alertController3.addAction(.init(title: "Cancel", style: .cancel))
            self.present(alertController3, animated: true)
            self.present(alertController, animated: true)
          
        }))
        
        
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func goToEdit() {

        guard let user = self.user else { return }
        
        if let userId = self.user?.id {
            
            let navController = EditProfileController(userId: userId, user: user)
            navController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(navController, animated: true)
            
        } else {
            print("Kullanıcı bilgilerine erişilemiyor.")
        }
    }
    
    func handleFollowUnfollow() {
        
        guard let user = user else { return }
        let isFollowing = user.isFollowing == true
        
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { (dataResponse) in
                if let error = dataResponse.error {
                    return
                }
                
                self.user?.isFollowing = !isFollowing
                self.collectionView.reloadData()
            }
    }
    
    override func setupHeader(_ header: ProfileHeader) {
        super.setupHeader(header)
        
        if user == nil { return }
        
        header.user = self.user
        header.profileController = self
    }
    
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.startAnimating()
        aiv.color = .darkGray
        
        return aiv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserProfile()
        
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleSetting))
        
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        setupActivityIndicatorView()
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
        self.collectionView.refreshControl = rc
    }
    
   
    fileprivate func setupActivityIndicatorView() {
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    
    
    @objc func fetchUserProfile(){
        
        let currentUserProfileUrl = "\(Service.shared.baseUrl)/profile"
        let publicUserProfileUrl = "\(Service.shared.baseUrl)/user/\(userId)"
        
        let url = self.userId.isEmpty ? currentUserProfileUrl : publicUserProfileUrl
        
        UIView.animate(withDuration: 0.6, animations: {
            self.activityIndicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.6) {
                self.activityIndicatorView.transform = CGAffineTransform.identity
            }
        }
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                }
                self.activityIndicatorView.stopAnimating()
                
                if let error = dataResponse.error {
                    print("error:", error)
                    return
                }
                
                let data = dataResponse.data ?? Data()
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.user = user
                    self.user?.isEditable = self.userId.isEmpty
                    self.items = user.posts ?? []
                    self.collectionView.reloadData()
                } catch(let err) {
                    print("decode error:", err)
                }
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if user == nil {
            return .zero
        }
        
        return .init(width: 0, height: 300)
    }
}


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
    
    func goToEdit() {
        print(self.user)
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
    
    @objc fileprivate func handleSetting() {
        let navController = SettingsController()
        navController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(navController, animated: true)
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

//
//  ViewController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 19.01.2023.
//

import LBTATools
import WebKit
import Alamofire
import SDWebImage
import JGProgressHUD
import CoreData
import SwiftUI

extension HomeController: PostDelegate {
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
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        let currentUrl = post.user.id
        alertController.addAction(.init(title: currentUrl == user?.id ? "Delete Post" : "Remove From Feed", style: .destructive, handler: { (_) in
            
            let deleteUrl = "\(Service.shared.baseUrl)/post/\(post.id)"
            let removeFeed = "\(Service.shared.baseUrl)/feeditem/\(post.id)"
            let url = currentUrl == self.user?.id ? deleteUrl : removeFeed
            
            AF.request(url, method: .delete)
                .responseData(emptyResponseCodes: [200, 204, 205]) { (dataResp) in
                    if let error = dataResp.error {
                        print("failed to error: ",error)
                        return
                    }
                    
                    guard let index = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                    
                    self.items.remove(at: index)
                    self.collectionView.deleteItems(at: [[0, index]])
                    
                    self.dismiss(animated: true) {
                        UIApplication.shared.refreshPosts()
                    }
                    
                }
        }))
        
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func showComment(post: Post) {
        let detailsViewController = PostDetailController(postId: post.id)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
   
}

class HomeController: LBTAListController<UserPostCell, Post>, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userId: String
    var user: User?
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        fetchPosts()
        fetchUserName()
        
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "heart"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Social Media", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-MediumItalic", size: 20)!], for: .normal)
        
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        self.collectionView.refreshControl = rc
        
    }
    
    @objc func fetchUserName() {
        
        let currentUser = "\(Service.shared.baseUrl)/profile"
        let url = currentUser
        
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
                    
                }catch(let err){
                    print("decoding error", err)
                }
            }
    }
    
    
    @objc fileprivate func createPost(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true) {
            
            let createPostController = CreatePostController(selectedImage: image)
            self.present(createPostController, animated: true)
           
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    
    @objc func fetchPosts() {
        
        Service.shared.fetchPosts { res in
            
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
            }
            
            switch res {
            case .failure(let err):
                print("fetch post error:", err)
            case .success(let posts):
                print("success fetch post")
                self.items = posts
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


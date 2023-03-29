//
//  MainTabBarController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 31.01.2023.
//

import UIKit
import SwiftUI
import LBTATools

extension MainTabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
               let createPostController = CreatePostController(selectedImage: image)
                self.present(createPostController, animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}


class MainTabBarController: UITabBarController, UITabBarControllerDelegate  {
   
    
     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewControllers?.firstIndex(of: viewController) == 2 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true)
            return false
        }
        
        return true
        
    }
    
    func refreshPosts() {
        homeController.fetchPosts()
        homeController.fetchUserName()
        profileController.fetchUserProfile()
    }
    
    let homeController = HomeController(userId: "")
    let profileController = ProfileController(userId: "")
    let messageController = MessagesListController(userId: "")//MessageController(userId: "")
    let searchController = UserSearchController(userId: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        
        viewControllers = [
            createNavController(viewController: homeController
                                , tabBarImage: UIImage(systemName: "house")),
            createNavController(viewController: searchController, tabBarImage: UIImage(systemName: "magnifyingglass")),
            createNavController(viewController: vc, tabBarImage: UIImage(systemName: "plus.app")),
            createNavController(viewController: profileController, tabBarImage: UIImage(systemName: "person"))
        ]
        
        tabBar.tintColor = .labelsColor
        tabBar.backgroundColor = .viewBackgroundColor
       
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
        
        
        if index == 0 {
            if let homeNavController = viewController as? UINavigationController,
               let homeTabBarItem = homeNavController.tabBarItem {
                
                let selectedImage = UIImage(systemName: "house.fill") // Seçili halinin görüntüsü
                homeTabBarItem.selectedImage = selectedImage
                
                let homeTabBarButton = homeTabBarItem.value(forKey: "view") as? UIView
                homeTabBarButton?.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 1,
                               options: [.curveEaseInOut],
                               animations: {
                    homeTabBarButton?.transform = CGAffineTransform.identity
                })
            }
        } else if index == 3 {
            if let homeNavController = viewController as? UINavigationController,
               let homeTabBarItem = homeNavController.tabBarItem {
                
                let selectedImage = UIImage(systemName: "person.fill") // Seçili halinin görüntüsü
                homeTabBarItem.selectedImage = selectedImage
                
                let homeTabBarButton = homeTabBarItem.value(forKey: "view") as? UIView
                homeTabBarButton?.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 1,
                               options: [.curveEaseInOut],
                               animations: {
                    homeTabBarButton?.transform = CGAffineTransform.identity
                })
            }
        }
        
        
    }
    
    fileprivate func createNavController(viewController: UIViewController, tabBarImage: UIImage?) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
        
    }
    
}

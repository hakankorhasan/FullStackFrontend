//
//  UserSearchController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 29.01.2023.
//

import LBTATools

class UserSearchController: LBTAListController<UserSearchCell, User> {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        navigationItem.title = "Search"
        modalPresentationStyle = .fullScreen
        //service.shared. ile post isteği at searchforusers ı çağır
        Service.shared.searchForUsers { (res) in
            switch res {
            case .failure(let err):
                print("error", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = items[indexPath.item]
        let controller = ProfileController(userId: user.id)
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}

//
//  UserSearchController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 29.01.2023.
//

import LBTATools


extension UserSearchController: SearchDelegate {
    
    func userProfileGo(user: User) {
        print("selam")
        let currentUrl = user.id
        let userProfile = ProfileController(userId: currentUrl == self.user?.id ? "" : currentUrl)
        navigationController?.pushViewController(userProfile, animated: true)
    }
    
}

class UserSearchController: LBTAListController<UserSearchCell, User>, UISearchResultsUpdating {
    
    
    let searchBarController = UISearchController()
    
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
        navigationItem.title = "Search"
        modalPresentationStyle = .fullScreen
        view.backgroundColor = .viewBackgroundColor
        
        searchBarController.searchResultsUpdater = self
        navigationItem.searchController = searchBarController
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let encodedName = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        Service.shared.searchForUsers(fullName: encodedName) { (res) in
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

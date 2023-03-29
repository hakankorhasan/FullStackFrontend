//
//  PostDetailController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 19.02.2023.
//

import LBTATools
import Alamofire
import JGProgressHUD

class PostDetailController: LBTAListController<CommentCell, Comment> {
    
    let postId: String
    
    init(postId: String) {
        self.postId = postId
        super.init()
    }
    
    lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 700))
        civ.layer.cornerRadius = 15
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
        
    }()
    
    @objc fileprivate func handleSend() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Submitting.."
        hud.show(in: view, animated: true)
        
        let params = ["text": customInputView.textView.text ?? ""]
        let url = "\(Service.shared.baseUrl)/comment/post/\(postId)"
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { dataResp in
                
                hud.dismiss(animated: true)
                self.customInputView.textView.text = nil
                self.customInputView.placeholderText.isHidden = false
                self.fetchPostDetails()
            }
    
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        navigationItem.title = "Comments"
        collectionView.keyboardDismissMode = .interactive
        
        setupActivityIndicatorView()
        fetchPostDetails()
    }
    
    
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.startAnimating()
        aiv.color = .darkGray
        
        return aiv
    }()
    
    
    func fetchPostDetails(){
        
        let url = "\(Service.shared.baseUrl)/post/\(postId)"
        AF.request(url)
            .responseData { (dataResp) in
                
                self.activityIndicatorView.stopAnimating()
                
                guard let data = dataResp.data else { return }
                let string = String(data: data, encoding: .utf8)
                
                do {
                    let post = try JSONDecoder().decode(Post.self, from: data)
                    self.items = post.comments ?? []
                    
                    self.collectionView.reloadData()
                }catch (let err) {
                    print("decoding error: ", err)
                }
                
                
            }
    }
    
    fileprivate func setupActivityIndicatorView() {
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

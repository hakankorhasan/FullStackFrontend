//
//  MessageController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 1.03.2023.
//

import LBTATools
import UIKit
import SocketIO

class UserMessageCell: LBTAListCell<Message> {
    
    let messageLabel = UILabel(text: "message", font: .systemFont(ofSize: 13, weight: .regular))
    
    
    override var item: Message! {
        didSet {
          //  messageLabel.text = item.message
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        
        stack(messageLabel, spacing: 12).withMargins(.allSides(16))
        
        addSeparatorView(leftPadding: 0)
    }
}

class MessageController: LBTAListController<UserMessageCell, Message> {
    
    
    let userId: String
    
    init(userId: String) {
        print(userId)
        self.userId = userId
        super.init()
    }
    
    
    lazy var customInputMessageView: CustomInputMessageView = {
        let cimv = CustomInputMessageView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 60))
        cimv.sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return cimv
    }()
    
    @objc fileprivate func handleSendMessage() {
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            customInputMessageView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "User Name"
        collectionView.keyboardDismissMode = .interactive
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MessageController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    
}



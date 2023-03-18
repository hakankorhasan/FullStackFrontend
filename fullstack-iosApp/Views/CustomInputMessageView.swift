//
//  CustomInputMessageView.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 2.03.2023.
//

import UIKit

class CustomInputMessageView: UIView {
    
    let textView = UITextView()
    
    let sendButton = UIButton(title: "SEND", titleColor: .black, target: nil, action: nil)
    
    let placeHolderText = UILabel(text: "Enter your message", font: .systemFont(ofSize: 15, weight: .regular), textColor: .lightGray)
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        
        
        autoresizingMask = .flexibleHeight
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMessageChange), name: UITextView.textDidChangeNotification, object: nil)
        
        hstack(textView, sendButton.withSize(.init(width: 60, height: 60)),
               alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
        addSubview(placeHolderText)
        
        placeHolderText.anchor(top: nil, leading: textView.leadingAnchor, bottom: nil, trailing: sendButton.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        placeHolderText.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleMessageChange() {
        placeHolderText.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//
//  CustomInputAccessoryView.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 20.02.2023.
//

import LBTATools

class CustomInputAccessoryView: UIView {
    
    let textView = UITextView()
    
    let sendButton = UIButton(title: "SEND", titleColor: .labelsColor, font: .boldSystemFont(ofSize: 15), backgroundColor: .grayButtonsColor, target: nil, action: nil)
    
    let placeholderText = UILabel(text: "Enter your comment", font: .systemFont(ofSize: 15, weight: .regular), textColor: .lightGray)
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .viewBackgroundColor
        setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 0, height: -4), color: .lightGray)
        
        autoresizingMask = .flexibleHeight
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        sendButton.layer.cornerRadius = 15
        
        hstack(textView,
               sendButton.withSize(.init(width: 60, height: 45)), alignment: .center).withMargins(.init(top: 14, left: 16, bottom: 0, right: 16))
        
        addSubview(placeholderText)
        
        placeholderText.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        placeholderText.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleTextChange() {
        placeholderText.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //removeObserver yöntemi, önceki addObserver yöntemiyle kaydedilen bir nesneyi kaldırır. Bu, nesnenin bellekte kalmasını önleyerek performans sorunlarını ve bellek sızıntılarını önler.
}

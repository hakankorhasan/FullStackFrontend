//
//  MessageCelll.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 8.03.2023.
//

import UIKit
import QuartzCore

class MessageCelll: UITableViewCell {

    let messageLabel = UILabel()
    private let cornerRadius: CGFloat = 16.0
        private let pointerSize: CGFloat = 12.0
        private let pointerTopPadding: CGFloat = 8.0
        private let bubbleColor: UIColor = .blue
    private let bubbleLayer = CAShapeLayer()
    
    var text: String? {
            didSet {
                messageLabel.text = text
            }
        }
        
       

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(messageLabel)
        messageLabel.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        messageLabel.layer.shadowColor = UIColor.black.cgColor
        messageLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        messageLabel.layer.shadowRadius = 2
        messageLabel.layer.shadowOpacity = 0.3
        messageLabel.layer.borderWidth = 1
        messageLabel.layer.borderColor = UIColor.gray.cgColor

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
    
    
    /* backgroundColor = .black
     addSubview(messageLabel)
             // Metin etiketi ayarla
             messageLabel.textColor = .white
             messageLabel.font = UIFont.systemFont(ofSize: 16)
             messageLabel.numberOfLines = 0
     messageLabel.translatesAutoresizingMaskIntoConstraints = false
     messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
     messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
     messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
     messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
     messageLabel.font = UIFont.systemFont(ofSize: 17)
     
     layer.addSublayer(bubbleLayer)*/
  /*  override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.borderWidth = 1.0
                layer.borderColor = UIColor.black.cgColor
        // Bubble şeklini hesapla
            let path = UIBezierPath()
            
            // Sol üst köşeden başla
            path.move(to: CGPoint(x: cornerRadius, y: 0))
            
            // Sol kenarın alt tarafı
            path.addLine(to: CGPoint(x: bounds.width - pointerSize - cornerRadius, y: 0))
            
            // Sol alt köşe
            path.addArc(withCenter: CGPoint(x: bounds.width - pointerSize - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(0), clockwise: true)
            
            // Pointer'ın başlangıç noktası
            path.addLine(to: CGPoint(x: bounds.width - pointerSize, y: cornerRadius + pointerTopPadding))
            
            // Pointer'ın ucu
            path.addLine(to: CGPoint(x: bounds.width, y: cornerRadius + pointerTopPadding + pointerSize / 2))
            path.addLine(to: CGPoint(x: bounds.width - pointerSize, y: cornerRadius + pointerTopPadding + pointerSize))
            
            // Sağ alt köşe
            path.addLine(to: CGPoint(x: bounds.width - pointerSize - cornerRadius, y: bounds.height))
            path.addArc(withCenter: CGPoint(x: bounds.width - pointerSize - cornerRadius, y: bounds.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi / 2), clockwise: true)
            
            // Sağ kenarın üst tarafı
            path.addLine(to: CGPoint(x: cornerRadius, y: bounds.height))
            
            // Sağ üst köşe
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: bounds.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            
            // Sol kenarın üst tarafı
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

        path.close()

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask

        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = layer.borderWidth
        borderLayer.strokeColor = layer.borderColor
        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
        
    }*/

    
}


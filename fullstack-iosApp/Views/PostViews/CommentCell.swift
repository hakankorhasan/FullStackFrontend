//
//  CommentCell.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 20.02.2023.
//

import LBTATools
import SDWebImage

class CommentCell: LBTAListCell<Comment> {
    
    let profileImageView = CircularImageView(width: 44, image: UIImage(systemName: "person"))
    
    let usernameLabel = UILabel(text: "temp", font: .boldSystemFont(ofSize: 15), textColor: .labelsColor)
    
    let fromNowLabel = UILabel(text: "posted 5m ago", font: .systemFont(ofSize: 12, weight: .regular), textColor: .gray)
    
    let commentLabel = UILabel(text: "greatfull", font: .systemFont(ofSize: 15, weight: .semibold), textColor: .labelsColor ,textAlignment: .justified, numberOfLines: 0)
    
    
    override var item: Comment! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? ""))
            usernameLabel.text = item.user.fullName
            fromNowLabel.text = item.fromNow
            commentLabel.text = item.text
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .viewBackgroundColor
        stack(hstack(profileImageView,
              stack(usernameLabel,
              fromNowLabel,
              spacing: 4),
              UIView(),
              spacing: 12,
              alignment: .center),
        commentLabel,
              spacing: 12).withMargins(.allSides(16))
        
        addSeparatorView(leftPadding: 0)
    }
}

//
//  PostCell.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 23.01.2023.
//


import LBTATools
import Alamofire

protocol PostCellOptionsDelegate: class {
    func handlePostOptions(cell: PostCell)
}

class PostCell: UITableViewCell {
    
    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15), textColor: .labelsColor)
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "Post Text", font: .systemFont(ofSize: 15), textColor: .labelsColor, numberOfLines: 0)
    
    weak var delegate: PostCellOptionsDelegate?
    lazy var optionsButton = UIButton(image: UIImage(systemName: "ellipsis")!, tintColor: .iconColor, target: self, action: #selector(handleOptions))
    
    @objc fileprivate func handleOptions() {
        
        delegate?.handlePostOptions(cell: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
        backgroundColor = .viewBackgroundColor
        stack(hstack(usernameLabel,
                    UIView(),
                    optionsButton.withWidth(25))
                    .padLeft(16).padRight(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

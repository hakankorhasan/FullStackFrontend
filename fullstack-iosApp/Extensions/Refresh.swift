//
//  Refresh.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 24.02.2023.
//

import UIKit
import CoreData

extension UIApplication {
    
    func refreshPosts() {
        guard let mainTabBarController = self.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.refreshPosts()
    }
}

extension NSString {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}


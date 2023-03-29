//
//  Color.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 25.03.2023.
//

import UIKit

extension UIColor {
  static var editButtonsColor: UIColor {
    return UIColor { (traitCollection: UITraitCollection) -> UIColor in
      return traitCollection.userInterfaceStyle == .dark ?
        UIColor(#colorLiteral(red: 0.1900421381, green: 0.1900421679, blue: 0.1900421381, alpha: 1)) : UIColor(#colorLiteral(red: 1, green: 0.3475894928, blue: 0, alpha: 1))
    }
  }
}

extension UIColor {
  static var grayButtonsColor: UIColor {
    return UIColor { (traitCollection: UITraitCollection) -> UIColor in
      return traitCollection.userInterfaceStyle == .dark ?
        UIColor(#colorLiteral(red: 0.1900421381, green: 0.1900421679, blue: 0.1900421381, alpha: 1)) : UIColor.white
    }
  }
}

extension UIColor {
  static var loginRegisterLabelsColor: UIColor {
    return UIColor { (traitCollection: UITraitCollection) -> UIColor in
      return traitCollection.userInterfaceStyle == .dark ?
        UIColor.black : UIColor.white
    }
  }
}

extension UIColor {
    static var labelsColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ?
            UIColor.white : UIColor.black
        }
    }
}

extension UIColor {
    static var iconColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
    }
}

extension UIColor {
    static var viewBackgroundColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ?
            UIColor.black : UIColor.white
        }
    }
}

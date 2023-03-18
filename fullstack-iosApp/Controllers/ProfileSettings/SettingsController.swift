//
//  SettingsController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 14.03.2023.
//

import LBTATools
import JGProgressHUD
import Alamofire

class SettingsController: LBTAFormController {
    
    let profileButton = UIButton(title: "Change Profile Photo", titleColor: .black,font: .boldSystemFont(ofSize: 15), backgroundColor: .init(white: 0.90, alpha: 1), target: self, action: #selector(changeAvatar))
    
    let profileBio = UIButton(title: "Edit Bio", titleColor: .black, font: .boldSystemFont(ofSize: 15), backgroundColor: .init(white: 0.90, alpha: 1), target: self, action: #selector(changeBio))
    
    let fullnameButton = UIButton(title: "Edit Username", titleColor: .black, font: .boldSystemFont(ofSize: 15), backgroundColor: .init(white: 0.90, alpha: 1), target: self, action: #selector(changeFullname))
    
    let exitButton = UIButton(title: "Sign Out", titleColor: .black,font: .boldSystemFont(ofSize: 15), backgroundColor: .init(white: 0.90, alpha: 1), target: self, action: #selector(handleExitUser))
    
    let destroyButton = UIButton(title: "Delete Account", titleColor: .black,font: .boldSystemFont(ofSize: 15), backgroundColor: .init(white: 0.90, alpha: 1), target: self, action: #selector(destroyUser))
    
    @objc fileprivate func changeAvatar() {
        
    }
    
    
    @objc fileprivate func changeBio() {
     /*   popupView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 250))
        popupView.backgroundColor = .init(white: 0.90, alpha: 1)
            
        let edit = UILabel(frame: CGRect(x: 10, y: 10, width: popupView.frame.width - 80, height: 30))
        edit.text = "Edit Bio"
        edit.font = .boldSystemFont(ofSize: 20)
        edit.tintColor = .black
        popupView.addSubview(edit)
        // Metin kutularını oluşturun
        let textField1 = UITextView(frame: CGRect(x: 20, y: 50, width: popupView.frame.width - 40, height: 130))
        textField1.layer.cornerRadius = 8
        textField1.backgroundColor = .white
        popupView.addSubview(textField1)
            
        // OK ve Cancel butonlarını oluşturun
        let okButton = UIButton(frame: CGRect(x: 20, y: 190, width: 100, height: 30))
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .black
        okButton.layer.cornerRadius = 8
        okButton.addTarget(self, action: #selector(handleBioUpdate), for: .touchUpInside)
        popupView.addSubview(okButton)
            
        let cancelButton = UIButton(frame: CGRect(x: 130, y: 190, width: 100, height: 30))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .black
        cancelButton.layer.cornerRadius = 8
        popupView.addSubview(cancelButton)
            
            // Görünümü merkezde gösterin
        popupView.center = view.center
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.cornerRadius = 8
       
            // Görünümü ekrana ekleyin
        view.addSubview(popupView)
        //showBioPopupView()*/
    }
    
    @objc fileprivate func changeFullname() {
        
    }
    
    @objc fileprivate func handleExitUser() {
        
    }
    
    @objc fileprivate func destroyUser() {
        
    }
    
    
    func showBioPopupView() {
     
       /* let popupHeight: CGFloat = 80
        let popupWidth: CGFloat = view.frame.width - 32 // Popup görünümünün yüksekliği
        let profileBioFrame = profileBio.convert(profileBio.bounds, to: view)
           // EditBio butonunun altındaki tüm buttonları popup yüksekliği kadar aşağı kaydır
           UIView.animate(withDuration: 0.3) {
               self.fullnameButton.frame.origin.y += popupHeight
               self.exitButton.frame.origin.y += popupHeight
               self.destroyButton.frame.origin.y += popupHeight
           }
        
           // Popup görünümünü oluştur
        popupView = UIView(frame: CGRect(x: 0, y: 0, width: Int(popupWidth), height: Int(popupHeight)))
        popupView.backgroundColor = .init(white: 0.90, alpha: 1)
        popupView.layer.cornerRadius = 10
        popupView.center = CGPoint(x: profileBioFrame.midX, y: profileBioFrame.maxY + popupHeight / 2)
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowRadius = 5 // add this line to control the shadow blur radius
        popupView.layer.masksToBounds = false
        popupView.layer.shadowPath = UIBezierPath(roundedRect: popupView.bounds, cornerRadius: popupView.layer.cornerRadius).cgPath

        view.addSubview(popupView)
       
        
        let bioTextField = UITextField(frame: CGRect(x: 50, y: 50, width: popupView.frame.width - 64, height: 40))
        bioTextField.borderStyle = .roundedRect
        popupView.addSubview(bioTextField)
                  
        // Tıklama olayını etkinleştir
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView))
        profileBio.addGestureRecognizer(tapGesture)*/
    }
    
    @objc func dismissPopupView() {
      
      /*  let popupHeight: CGFloat = 80
                    
            // EditBio butonunun altındaki tüm buttonları popup yüksekliği kadar yukarı kaydır
            UIView.animate(withDuration: 0.3) {
                self.fullnameButton.frame.origin.y -= popupHeight
                self.exitButton.frame.origin.y -= popupHeight
                self.destroyButton.frame.origin.y -= popupHeight
            }
                    
            popupView.removeFromSuperview()
            tapGesture.isEnabled = false*/
    }
    
    let buttonView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        navigationItem.title = "Settings"
        
        let buttons = [profileButton, profileBio, fullnameButton, exitButton, destroyButton]

        for button in buttons {
            button.layer.cornerRadius = 8
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.5
        }
        
        buttonView.stack(profileButton.withSize(.init(width: view.frame.width - 32, height: 50)),
                         profileBio.withSize(.init(width: view.frame.width - 32, height: 50)),
                         fullnameButton.withSize(.init(width: view.frame.width - 32, height: 50)),
                         exitButton.withSize(.init(width: view.frame.width - 32, height: 50)),
                         destroyButton.withSize(.init(width: view.frame.width - 32, height: 50)), spacing: 12, alignment: .leading).padLeft(16).padRight(16).padTop(16)
                
        formContainerStackView.addArrangedSubview(buttonView)
        
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
    
    
}




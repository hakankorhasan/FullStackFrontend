//
//  ProfileController+ChangeAvatar.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 31.01.2023.
//

import UIKit
import Alamofire
import JGProgressHUD

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func changeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            print(selectedImage)
            dismiss(animated: true) {
                self.uploadUserProfile(image: selectedImage)
            }
        } else {
            dismiss(animated: true)
        }
        
    }
    
    fileprivate func uploadUserProfile(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Updating profile"
        hud.show(in: view, animated: true)
        
        let url = "\(Service.shared.baseUrl)/profile"
        
        guard let user = self.user else { return }
        let multipartFormData = MultipartFormData()
        multipartFormData.append(Data(user.fullName.utf8), withName: "fullName")
        let bio = Data((user.bio ?? "").utf8)
        multipartFormData.append(bio, withName: "bio")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        multipartFormData.append(imageData, withName: "imagefile", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
        
        AF.upload(multipartFormData: multipartFormData, to: url, method: .post)
            .uploadProgress { progress in
                hud.progress = Float(progress.fractionCompleted)
                hud.textLabel.text = "Updating\n\(Int(progress.fractionCompleted * 100))% Complete"
            }
            .responseData(emptyResponseCodes: [200, 204, 205]) { (res) in
                hud.dismiss(animated: true)
                
                if let error = res.error {
                    return
                }
                
                if let code = res.response?.statusCode, code >= 300 {
                    return
                }
              
                self.fetchUserProfile()
            }
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
    

//
//  CreatePostController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 23.01.2023.
//

import LBTATools
import Alamofire
import JGProgressHUD

class CreatePostController: UIViewController, UITextViewDelegate {
    
    let selectedImage: UIImage
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFit)
    
    let postButton = UIButton(title: "Post", titleColor: .white, font: .systemFont(ofSize: 24), backgroundColor: .black, target: self, action: #selector(handlePost))
    
    let placeholderLabel = UILabel(text: " Enter your post body text...", font: .systemFont(ofSize: 14), textColor: .lightGray)
    
    let postBodyTextView = UITextView(text: nil, font: .systemFont(ofSize: 14))
    
    weak var homeController: HomeController?
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        imageView.image = selectedImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        modalPresentationStyle = .fullScreen
        postButton.layer.cornerRadius = 10
        
        view.stack(imageView.withHeight(300),
                   view.stack(postButton.withHeight(50),
                              placeholderLabel,
                              spacing: 16).padLeft(16).padRight(16),
                UIView(),
                   spacing: 16)
        
        view.addSubview(postBodyTextView)
        postBodyTextView.backgroundColor = .clear
        postBodyTextView.delegate = self
        postBodyTextView.anchor(top: placeholderLabel.bottomAnchor, leading: placeholderLabel.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -25, left: -6, bottom: 0, right: 16))
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.alpha = !textView.text .isEmpty ? 0 : 1
    }
    
    @objc fileprivate func handlePost() {
        let url = "http://localhost:1337/post"
        
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view, animated: true)
        
        guard let text = postBodyTextView.text else { return }
        guard let imageData = self.selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
        let multipartFormData = MultipartFormData()
        
        multipartFormData.append(Data(text.utf8), withName: "postBody")
        multipartFormData.append(imageData, withName: "imagefile", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
        
        AF.upload(multipartFormData: multipartFormData, to: url)
            .uploadProgress(closure: { progress in
                hud.progress = Float(progress.fractionCompleted)
                hud.textLabel.text = "Uploading\n\(Int(progress.fractionCompleted * 100))% Complete"
            })
            .responseData(emptyResponseCodes: [200, 204, 205]) { dataResp in
                hud.dismiss()
                if let error = dataResp.error {
                    print("Failed to hit server:", error)
                    return
                }
                
                if let code = dataResp.response?.statusCode, code >= 300 {
                    print("failed upload with status: ", code)
                    return
                }
                
                let respString = String(data: dataResp.data ?? Data(), encoding: .utf8)
                print("successfully created post, here is the response: ")
                print(respString ?? "")
                
                self.dismiss(animated: true) {
                    UIApplication.shared.refreshPosts()
                }
                
            }
            
    }

}
    



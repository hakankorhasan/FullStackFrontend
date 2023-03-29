//
//  EditProfileController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 15.03.2023.
//

import LBTATools
import SDWebImage
import JGProgressHUD
import Alamofire

class EditProfileController: LBTAFormController,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profileImageView = CircularImageView(width: 125, image: UIImage(named: "personTrans"))
    
    let changePhotoButton = UIButton(title: "Change profile photo", titleColor: UIColor(#colorLiteral(red: 0, green: 0.5148674846, blue: 0.8860286474, alpha: 1)), font: .systemFont(ofSize: 15), backgroundColor: .viewBackgroundColor, target: self, action: #selector(handleChangePhoto))
    
    
    let nameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 12, weight: .light), textColor: .labelsColor)
    let fullNameTextField = UITextField(placeholder: "Username")
    let bioLabel = UILabel(text: "Bio", font: .systemFont(ofSize: 12, weight: .light), textColor: .labelsColor)
    let bioTextField = UITextField(placeholder: "Bio")
    
    let gestureRecognizer = UITapGestureRecognizer()
    var nameLabelInitialY: CGFloat = 0
    var bioLabelInitialY: CGFloat = 0
    
    let lineView = UIView()
    let lineView2 = UIView()
    let lineView3 = UIView()
    
    func changeProfileImg() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    var selectedImg: UIImage?
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
               
                //self.uploadUserProfile(image: selectedImage)
                self.selectedImg = selectedImage
                self.profileImageView.image = self.selectedImg
              //veritabanına kayıt edecek backende istek yapacak method yazılacak
            }
        } else {
            dismiss(animated: true)
        }
            
    }
    
    fileprivate func uploadUserProfile(image: UIImage, newName: String, newBio: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Updating profile"
        hud.show(in: view, animated: true)
        
        let url = "\(Service.shared.baseUrl)/profile"
        
        guard self.user != nil else { return }
        let multipartFormData = MultipartFormData()
        let newName = Data((fullNameTextField.text)?.utf8 ?? String().utf8)
        multipartFormData.append(Data(newName), withName: "fullName")
        let bio = Data((bioTextField.text)?.utf8 ?? String().utf8)
        multipartFormData.append(bio, withName: "bio")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        multipartFormData.append(imageData, withName: "imagefile", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
        
        AF.upload(multipartFormData: multipartFormData, to: url, method: .post)
            .uploadProgress { progress in
                hud.progress = Float(progress.fractionCompleted)
                hud.textLabel.text = "Updating\n\(Int(progress.fractionCompleted * 100))% Complete"
            }
            .responseData(emptyResponseCodes: [200, 204, 205]) { (res) in
                self.profileController?.fetchUserProfile()
                hud.dismiss(animated: true)
                
                if let error = res.error {
                    return
                }
                
                if let code = res.response?.statusCode, code >= 300 {
                    return
                }
              
                self.navigationController?.popViewController(animated: true)
                
            }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    

    @objc fileprivate func handleChangePhoto() {
       changeProfileImg()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func saveChanges() {
        guard let image = selectedImg else { return }
        uploadUserProfile(image: image, newName: self.fullNameTextField.text ?? "", newBio: self.bioTextField.text ?? "")
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    weak var profileController: ProfileController?
    let stackView = UIStackView()
    let stackView2 = UIStackView()
    
    @objc func bioLabelChannge() {
        animateBioLabel(up: false)
    }
    
    @objc func namelabelChange() {
        animateNameLabel(up: false)
    }
    
    
    func animateBioLabel(up: Bool) {
        let offset: CGFloat = up ? -bioLabel.frame.height/2 - 5 : 0

        UIView.animate(withDuration: 0.3, animations: {
            self.bioLabel.frame.origin.y = self.bioLabelInitialY + offset
        })
    }
    
    func animateNameLabel(up: Bool) {
        let offset: CGFloat = up ? -nameLabel.frame.height/2 - 5 : 0
        // Yukarı doğru hareket etmek için -nameLabel.frame.height - 5, aşağı doğru hareket etmek için 0

        UIView.animate(withDuration: 0.3, animations: {
            self.nameLabel.frame.origin.y = self.nameLabelInitialY + offset
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.fullNameTextField {
                animateNameLabel(up: true)
            } else if textField == self.bioTextField {
                animateBioLabel(up: true)
            }
    }
        
    // textField'dan çıkıldığında çağrılan fonksiyon
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.fullNameTextField {
                animateNameLabel(up: false)
            } else if textField == self.bioTextField {
                animateBioLabel(up: false)
            }
    }
    
    let userId: String
    let user: User
    init(userId: String, user: User) {
        self.userId = userId
        self.user = user
        super.init()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        profileImageView.layer.borderWidth = 1
        navigationItem.title = "Account Settings"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem?.tintColor  = .iconColor
        navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem?.tintColor = .iconColor

        gestureRecognizer.addTarget(self, action: #selector(bioLabelChannge))
        gestureRecognizer.addTarget(self, action: #selector(namelabelChange))
        view.addGestureRecognizer(gestureRecognizer)
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? ""))
        fullNameTextField.placeholder = user.fullName
        bioTextField.placeholder = user.bio
        
        bioTextField.delegate = self
        fullNameTextField.delegate = self
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .labelsColor
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        lineView2.backgroundColor = .labelsColor
        lineView3.translatesAutoresizingMaskIntoConstraints = false
        lineView3.backgroundColor = .labelsColor
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 1
        stackView.spacing = 20
        
        
        stackView2.stack(lineView3.withSize(.init(width: view.frame.width, height: 0.5)))
        stackView.stack(stackView.stack(profileImageView,
                                        changePhotoButton, spacing: 10, alignment: .center).padBottom(20).padTop(30),
                        stackView.stack(nameLabel,
                                        fullNameTextField.withSize(.init(width: view.frame.width - 24, height: 35)),
                                        lineView.withSize(.init(width: view.frame.width - 24, height: 0.45))),
                        stackView.stack(bioLabel,
                                        bioTextField.withSize(.init(width: view.frame.width - 24, height: 35)),
                                        lineView2.withSize(.init(width: view.frame.width - 24, height: 0.48))),
                        spacing: 16,
                        alignment: .center).withMargins(.allSides(12))
     
        formContainerStackView.addArrangedSubview(stackView2)
        formContainerStackView.addArrangedSubview(stackView)
        
        
    }
    
    
}


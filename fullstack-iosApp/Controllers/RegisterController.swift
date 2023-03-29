//
//  RegisterController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 19.01.2023.
//

import LBTATools
import Alamofire
import JGProgressHUD
import Lottie
import CoreData

class RegisterController: LBTAFormController, UITextFieldDelegate {
    
    let fullNameTextField = IndentedTextField(placeholder: "Full Name", padding: 24, cornerRadius: 25)
    
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25)
    
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25)
    
    
    lazy var registerButton = UIButton(title: "Register", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: UIColor(#colorLiteral(red: 0.3004268408, green: 0.4430769682, blue: 0.8877891898, alpha: 1)), target: self, action: #selector(handleRegister))
    
    let errorLabel = UILabel(text: "Y", font: .systemFont(ofSize: 16), textColor: .red, textAlignment: .center, numberOfLines: 0)
    
    lazy var goBackButton = UIButton(title: "<- Go back to login.", titleColor: .labelsColor, font: .systemFont(ofSize: 16), target: self, action: #selector(goToBackRegister))
    
    let animationSuccessfully = LottieAnimationView()
    

    @objc fileprivate func goToBackRegister() {
        let navController = UINavigationController(rootViewController: LoginController())
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleRegister()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("login2")
        animationView.center = self.view.center
        animationView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5) // boyutu değiştirildi
        animationView.loopMode = .loop
        animationView.play()
        
        view.backgroundColor = .viewBackgroundColor
        modalPresentationStyle = .fullScreen
        registerButton.layer.cornerRadius = 25
        
        passwordTextField.isSecureTextEntry = true
        
        [fullNameTextField, emailTextField, passwordTextField].forEach{$0.backgroundColor = .grayButtonsColor}
        [fullNameTextField, emailTextField, passwordTextField].forEach{$0.layer.borderWidth = 0.05}
        navigationController?.navigationBar.isHidden = true
        errorLabel.isHidden = true
        
        let registerView = UIView()
        registerView.stack(
            registerView.stack(registerView.hstack(animationView.withSize(.init(width: 125, height: 125))).padLeft(12).padRight(12).padTop(40).padBottom(60), alignment: .center),
        UIView().withHeight(25),
        fullNameTextField.withHeight(50),
        emailTextField.withHeight(50),
        passwordTextField.withHeight(50),
        registerButton.withHeight(50),
        errorLabel,
        goBackButton,
        UIView().withHeight(80),
        spacing: 13).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        view.addSubview(animationSuccessfully)
        animationSuccessfully.centerInSuperview()
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(registerView)
    }
    
    @objc fileprivate func handleRegister() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registering"
        hud.show(in: view)
        
        UIView.animate(withDuration: 0.6, delay: 0.0,  options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.registerButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
            UIView.animate(withDuration: 0.6 , delay: 0.0,  options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut]) {
                    self.registerButton.transform = CGAffineTransform.identity
                }
            })
        
        
        
        guard let fullName = fullNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Service.shared.signUp(fullName: fullName, email: email, password: password) { (res) in
            
            hud.dismiss(animated: true)
            
            switch res {
            case  .failure(let error):
                self.errorLabel.isHidden = false
                self.errorLabel.text = "You entered invalid or incomplete information"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.errorLabel.text = "Please try again"
                    hud.dismiss()
                }
            case .success:
                self.animationSuccessfully.animation = LottieAnimation.named("41647-successfully-completed")
                self.animationSuccessfully.center = self.view.center
                self.animationSuccessfully.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.animationSuccessfully.loopMode = .playOnce
                self.animationSuccessfully.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    NSManagedObject().setIsLogged(true)
                    //hud.dismiss()
                    let navController = MainTabBarController()
                    UIApplication.shared.refreshPosts()
                    self.navigationController?.pushViewController(navController, animated: true)
                }
            }
        }
    }
    
    
}

//
//  LoginController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 19.01.2023.
//

import LBTATools
import Alamofire
import JGProgressHUD
import CoreData
import Lottie

class LoginController: LBTAFormController {
    
   
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25)
    
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25)
    
    lazy var loginButton = UIButton(title: "Login", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: UIColor(#colorLiteral(red: 0.3004268408, green: 0.4430769682, blue: 0.8877891898, alpha: 1)), target: self, action: #selector(handleLogin))
 
    let errorLabel = UILabel(text: "Your login credentials were incorrect, please try again", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
    
    lazy var goToRegisterButton = UIButton(title: "Need an account? Go to register.", titleColor: .labelsColor, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
    
   
    
    @objc fileprivate func goToRegister() {
        let navController = UINavigationController(rootViewController: RegisterController())
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging in"
        hud.show(in: view)
        
        UIView.animate(withDuration: 0.6, delay: 0.0,  options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.loginButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
            UIView.animate(withDuration: 0.6 , delay: 0.0,  options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut]) {
                    self.loginButton.transform = CGAffineTransform.identity
                }
            })
        
        //kullanıcı mailini aldık kontrol yaptık
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        errorLabel.isHidden = true
        
        Service.shared.login(email: email, passwoord: password) { (res) in
            switch res {
            case .failure:
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Your credentials are not correct"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    hud.dismiss()
                    self.errorLabel.text = "Try again please"
                }
            case .success:
                NSManagedObject().setIsLogged(true)
                hud.dismiss()
                let navController = MainTabBarController()
                UIApplication.shared.refreshPosts()
                self.navigationController?.pushViewController(navController, animated: true)
            

            }
        }
        //backend de gidecek olan put isteğinin urlsini belirledik
        //postman da dönen verileri json tipinde kontrol ediyoruz, hangi parametrelere bağlı login yapacaksak parametreleri belirliyoruz.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("121421-login")
        //animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = self.view.center
        animationView.tintColor = .red
        animationView.transform = CGAffineTransform(scaleX: 4.0, y: 4.0) // boyutu değiştirildi
        animationView.loopMode = .loop
    
        
        animationView.play()
        
        view.backgroundColor = .viewBackgroundColor
        modalPresentationStyle = .fullScreen
        
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = .grayButtonsColor
        emailTextField.layer.borderWidth = 0.05
        
        passwordTextField.backgroundColor = .grayButtonsColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderWidth = 0.05
        
        loginButton.layer.cornerRadius = 25
        navigationController?.navigationBar.isHidden = true
        errorLabel.isHidden = true
        
        let loginView = UIView()
        loginView.stack(
            loginView.stack(loginView.hstack(animationView.withSize(.init(width: 125, height: 125))).padLeft(12).padRight(12).padTop(46).padBottom(60), alignment: .center),
            UIView().withHeight(12),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            loginButton.withHeight(50),
            errorLabel,
            goToRegisterButton,
            UIView().withHeight(80),
            spacing: 13).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(loginView)
        
    }
    

  
}

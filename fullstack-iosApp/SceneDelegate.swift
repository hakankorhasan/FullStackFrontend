//
//  SceneDelegate.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 19.01.2023.
//

import UIKit
import CoreData


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "LoginControl")
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
       // window?.rootViewController = MainTabBarController()
           let window = UIWindow(windowScene: windowScene)
            let context = persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginControl")
            do {
                let result = try context.fetch(request)
                if let objectData = result.first as? LoginControl, objectData.isLogged {
                    // Eğer isLogged true ise MainTabBarController'a yönlendir
                    print(objectData.isLogged)
                    let mainTabBarController = MainTabBarController()
                    window.rootViewController = mainTabBarController
                } else {
                    // Eğer isLogged false ise LoginController'a yönlendir
                    let loginController = LoginController()
                    window.rootViewController = loginController
                }
            } catch {
                print("Error fetching data: \(error)")
                let loginController = LoginController()
                window.rootViewController = loginController
            }
            
            self.window = window
            window.makeKeyAndVisible()        
       
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}


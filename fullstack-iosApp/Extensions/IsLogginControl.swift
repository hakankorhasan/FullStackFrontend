//
//  IsLogginControl.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 10.03.2023.
//

import CoreData
import UIKit

extension NSManagedObject {

    func setIsLogged(_ isLogged: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginControl")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            if let object = result.first as? NSManagedObject {
                object.setValue(isLogged, forKey: "isLogged")
            } else {
                let newObject = LoginControl(context: context)
                newObject.isLogged = isLogged
            }
            try context.save()
        } catch let error {
            print("Error updating isLogged: \(error)")
        }
    }

}

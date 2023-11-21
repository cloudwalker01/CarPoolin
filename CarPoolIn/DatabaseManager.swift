//
//  DatabaseManager.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager{
    
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addUser(_ user: User) {
        let userEntity = UserEntity(context: context)
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.age = user.age
        userEntity.sex = user.sex
        userEntity.mobNo = user.phoneNumber
        
        do {
            try context.save()
        }
        catch {
            print("User saving error", error)
        }
    }
    
    func doesUserExist(phoneNumber: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "mobNo == %@", phoneNumber)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        }
        catch {
            print("Fetch error", error)
            return false
        }
    }
}

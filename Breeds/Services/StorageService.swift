//
//  StorageService.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit
import CoreData

class StorageService {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadBreeds() -> [Breed]? {
        let fetchRequest: NSFetchRequest<Breed> = Breed.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadSubbreeds() -> [Sub]? {
        let fetchRequest: NSFetchRequest<Breed> = Breed.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

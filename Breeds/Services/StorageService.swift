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
    
    func addBreed(name: String) -> Bool {
        let breed = Breed(context: context)
        
        breed.id = UUID()
        breed.name = name

        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addSubbreed(name: String) -> Bool {
        let subbreed = Subbreed(context: context)
        
        subbreed.id = UUID()
        subbreed.name = name

        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addImage(for dogId: UUID, with name: String) -> Bool {
        let image = Image(context: context)
        
        image.id = UUID()
        image.name = name
        image.dogId = dogId
        image.favourite = false

        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func loadBreeds() -> [Breed]? {
        let fetchRequest: NSFetchRequest<Breed> = Breed.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadSubbreeds(by breedId: UUID) -> [Subbreed]? {
        let fetchRequest: NSFetchRequest<Subbreed> = Subbreed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", breedId as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImages(by dogId: UUID) -> [Image]? {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dogId == %@", dogId as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func updateImage(for imageId: UUID, with favourite: Bool) -> Bool {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", imageId as CVarArg)
        
        do {
            guard let image = try context.fetch(fetchRequest).first else {
                return false
            }
            image.favourite = favourite
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
}

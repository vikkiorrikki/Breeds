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
    
    func addSubbreed(with name: String, by breedName: String) -> Bool {
        let subbreed = Subbreed(context: context)
        
        subbreed.id = UUID()
        subbreed.name = name
        
        let breed = loadBreed(by: breedName)
        subbreed.breedId = breed?.id
        subbreed.breed = breed

        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addImage(breedName: String, with imageName: String) -> Bool {
        let dogId = loadBreed(by: breedName)?.id
        let image = Image(context: context)
        
        image.id = UUID()
        image.name = imageName
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
    
    func addImage(subbreedName: String, with imageName: String) -> Bool {
        let dogId = loadSubbreed(by: subbreedName)?.id
        let image = Image(context: context)
        
        image.id = UUID()
        image.name = imageName
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
    
    func loadBreed(by name: String) -> Breed? {
        let fetchRequest: NSFetchRequest<Breed> = Breed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            guard let breed = try context.fetch(fetchRequest).first
                else { return nil }
            return breed
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadSubbreeds(by breedName: String) -> [Subbreed]? {
        let breedId = loadBreed(by: breedName)?.id
        let fetchRequest: NSFetchRequest<Subbreed> = Subbreed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "breedId == %@", breedId! as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadSubbreed(by subbreedName: String) -> Subbreed? {
        let fetchRequest: NSFetchRequest<Subbreed> = Subbreed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", subbreedName)
        
        do {
            guard let subbreed = try context.fetch(fetchRequest).first
                else { return nil }
            return subbreed
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImages(breedName: String) -> [Image]? {
        let dogId = loadBreed(by: breedName)?.id
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dogId == %@", dogId! as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImages(subbreedName: String) -> [Image]? {
        let dogId = loadSubbreed(by: subbreedName)?.id
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dogId == %@", dogId! as CVarArg)
        
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

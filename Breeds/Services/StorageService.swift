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
    
    func addBreeds(_ breeds: [String]) {
        var existingBreedsNames = [String]()
        
        if let existingBreeds = loadBreeds() {
            for breed in existingBreeds {
                if let breedName = breed.name {
                    existingBreedsNames.append(breedName)
                }
            }
        }

        for breedName in breeds {
            if !existingBreedsNames.contains(breedName) {
                let breed = Breed(context: context)
                breed.id = UUID()
                breed.name = breedName
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addSubbreeds(_ subbreeds: [String], for breedName: String) {
        var existingSubbreedsNames = [String]()
        
        if let existingSubbreeds = loadSubbreeds(by: breedName) {
            for subbbreed in existingSubbreeds {
                if let subbbreedName = subbbreed.name {
                    existingSubbreedsNames.append(subbbreedName)
                }
            }
        }
        
        let breed = loadBreed(by: breedName)
        for subbreedsName in subbreeds {
            if !existingSubbreedsNames.contains(subbreedsName) {
                let subbreed = Subbreed(context: context)
                subbreed.id = UUID()
                subbreed.name = subbreedsName
                
                subbreed.breedId = breed?.id
                subbreed.breed = breed
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addBreedImage(breedName: String, with imageName: String) {
        let image = Image(context: context)
        
        image.id = UUID()
        image.name = imageName
        image.favourite = false
        
        let breed = loadBreed(by: breedName)
        image.dogId = breed?.id
        image.breed = breed

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addSubbreedImage(subbreedName: String, with imageName: String) {
        let image = Image(context: context)
        
        image.id = UUID()
        image.name = imageName
        image.favourite = false
        
        let subbreed = loadSubbreed(by: subbreedName)
        image.dogId = subbreed?.id
        image.subbreed = subbreed

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func isBreeds() -> Bool {
        if loadBreeds() != nil {
            return true
        } else {
            return false
        }
    }
    
    func isSubbreeds(for breed: String) -> Bool {
        if loadSubbreeds(by: breed) != nil {
            return true
        } else {
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
    
//    func loadImagesBreed(by name: String) -> [Image]? {
//        let fetchRequest: NSFetchRequest<Breed> = Breed.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        
//        do {
//            guard let breed = try context.fetch(fetchRequest).first
//                else { return nil }
//            
//            let request2: NSFetchRequest<Image> = Image.fetchRequest()
//            request2.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Image.breed.name), breed.name!])
//            
//            let images = try context.fetch(request2)
//            return images
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    
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
    
    func loadBreedImages(breedName: String) -> [Image]? {
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
    
    func loadSubbreedImages(subbreedName: String) -> [Image]? {
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
    
    func updateImage(for imageId: UUID, with favourite: Bool) {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", imageId as CVarArg)
        
        do {
            guard let image = try context.fetch(fetchRequest).first else { return }
            image.favourite = favourite
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

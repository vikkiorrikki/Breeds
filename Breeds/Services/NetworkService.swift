//
//  NetworkService.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

class NetworkService {
    
    weak var delegateBreeds: BreedNetworkDelegate?
    weak var delegateSubbreeds: SubbreedNetworkDelegate?
    weak var delegateImages: ImageNetworkDelegate?
    
    let storageService = StorageService()
    let requestURL = "https://dog.ceo/api"
    
    //MARK: - Fetch Breeds
    
    func fetchBreeds() {
        let urlString = "\(requestURL)/breeds/list"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegateBreeds?.showErrorAlert(with: "\(String(describing: error))")
                }
                if let safeData = data {
                    self.parseJSON(breedData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(breedData: Data) -> String {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(BreedData.self, from: breedData)
            let breedNames = decodedData.message
            let status = decodedData.status
            
            for name in breedNames {
                DispatchQueue.main.async {
                    self.storageService.addBreed(name: name)
                }
                fetchSubbreeds(by: name)
            }
            
            return status
        } catch {
            delegateBreeds?.showErrorAlert(with: "\(error)")
            return "\(error)"
        }
    }
    
    //MARK: - Fetch Subbreeds
    
    func fetchSubbreeds(by breed: String) {
        let urlString = "\(requestURL)/breed/\(breed)/list"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegateSubbreeds?.showErrorAlert(with: "\(String(describing: error))")
                }
                if let safeData = data {
                    
                    if self.parseJSON(subbreedData: safeData, by: breed) == "success" {
                        DispatchQueue.main.async {
                            self.delegateBreeds?.update()
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(subbreedData: Data, by breedName: String) -> String {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(SubbreedData.self, from: subbreedData)
            let subbreedNames = decodedData.message
            let status = decodedData.status
            
            for name in subbreedNames {
                DispatchQueue.main.async {
                    self.storageService.addSubbreed(with: name, by: breedName)
                }
            }
            
            return status
        } catch {
            self.delegateSubbreeds?.showErrorAlert(with: "\(error)")
            return "\(error)"
        }
    }
    
    //MARK: - Fetch Images for Breed
    
    func fetchImages(by breed: String) {
        let urlString = "\(requestURL)/breed/\(breed)/images"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegateImages?.showErrorAlert(with: "\(String(describing: error))")
                }
                if let safeData = data {
                    
                    if self.parseJSON(imageData: safeData, breedName: breed) == "success" {
                        DispatchQueue.main.async {
                            self.delegateImages?.updateCollectionView(breedName: breed)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(imageData: Data, breedName: String) -> String {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            let imageNames = decodedData.message
            let status = decodedData.status
            
            for name in imageNames {
                DispatchQueue.main.async {
                    self.storageService.addBreedImage(breedName: breedName, with: name)
                }
            }
            
            return status
        } catch {
            self.delegateImages?.showErrorAlert(with: "\(error)")
            return "\(error)"
        }
    }
    
    //MARK: - Fetch Images for Subbreed
    
    func fetchImages(by breed: String, by subbreed: String) {
        let urlString = "\(requestURL)/breed/\(breed)/\(subbreed)/images"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegateImages?.showErrorAlert(with: "\(String(describing: error))")
                }
                if let safeData = data {
                    
                    if self.parseJSON(imageData: safeData, subbreedName: subbreed) == "success" {
                        DispatchQueue.main.async {
                            self.delegateImages?.updateCollectionView(subbreedName: subbreed)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(imageData: Data, subbreedName: String) -> String {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            let imageNames = decodedData.message
            let status = decodedData.status
            
            for name in imageNames {
                DispatchQueue.main.async {
                    self.storageService.addSubbreedImage(subbreedName: subbreedName, with: name)
                }
            }
            
            return status
        } catch {
            self.delegateImages?.showErrorAlert(with: "\(error)")
            return "\(error)"
        }
    }
}

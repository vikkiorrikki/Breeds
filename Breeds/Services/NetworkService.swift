//
//  NetworkService.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

class NetworkService {
    
    weak var delegateImages: ImageNetworkDelegate?
    
    let storageService = StorageService()
    let requestURL = "https://dog.ceo/api"
    
    //MARK: - Fetch Breeds
    
    func fetchBreeds(resultHandler: @escaping (Result<[String], Error>)->()) {
        let urlString = "\(requestURL)/breeds/list"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        resultHandler(.failure(error))
                    }
                } else if let data = data, let breeds = self.parseBreeds(from: data) {
                    DispatchQueue.main.async {
                        resultHandler(.success(breeds))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseBreeds(from data: Data) -> [String]? {
        do {
            let decodedData = try JSONDecoder().decode(BreedData.self, from: data)
            return decodedData.message
        } catch {
            return nil
        }
    }
    
    //MARK: - Fetch Subbreeds
    
    func fetchSubbreeds(for breed: String, resultHandler: @escaping (Result<[String], Error>)->()) {
        let urlString = "\(requestURL)/breed/\(breed)/list"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        resultHandler(.failure(error))
                    }
                } else if let data = data, let subbreeds = self.parseSubbreeds(from: data) {
                    DispatchQueue.main.async {
                        resultHandler(.success(subbreeds))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseSubbreeds(from data: Data) -> [String]? {
        do {
            let decodedData = try JSONDecoder().decode(SubbreedData.self, from: data)
            return decodedData.message
        } catch {
            return nil
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

//
//  NetworkService.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

class NetworkService {

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
    
    func fetchImages(by breed: String, resultHandler: @escaping (Result<[String], Error>)->()) {
        let urlString = "\(requestURL)/breed/\(breed)/images"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        resultHandler(.failure(error))
                    }
                }
                if let data = data, let imagesBreed = self.parseBreedsImages(from: data, for: breed) {
                    DispatchQueue.main.async {
                        resultHandler(.success(imagesBreed))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseBreedsImages(from data: Data, for breedName: String) -> [String]? {
        do {
            let decodedData = try JSONDecoder().decode(ImageData.self, from: data)
            return decodedData.message
        } catch {
            return nil
        }
    }
    
    //MARK: - Fetch Images for Subbreed
    
    func fetchImages(_ subbreed: String, for breed: String, resultHandler: @escaping (Result<[String], Error>)->()) {
        let urlString = "\(requestURL)/breed/\(breed)/\(subbreed)/images"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        resultHandler(.failure(error))
                    }
                }
                if let data = data, let imagesSubbreed = self.parseSubbreedsImages(from: data, for: subbreed) {
                    DispatchQueue.main.async {
                        resultHandler(.success(imagesSubbreed))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseSubbreedsImages(from data: Data, for subbreedName: String) -> [String]? {
        do {
            let decodedData = try JSONDecoder().decode(ImageData.self, from: data)
            return decodedData.message
        } catch {
            return nil
        }
    }
}

//
//  FavouritesTableViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {

    let storageService = StorageService()
    
    var namesDog = [String]()
    var favouriteDogs: [String: [Image]] = [:]
//    var favouriteSubbreeds: [String: [Image]] = [:]
    
//    var breeds = [Breed]()
//    var subbreeds = [Subbreed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if favouriteDogs.count == 0 {
//            setupTableView()
//        }
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
        tableView.reloadData()
    }
    
    func setupTableView() {
        favouriteDogs.removeAll()
        namesDog.removeAll()
        
        guard let breeds = storageService.loadBreeds() else { return }
//        self.breeds = breeds
        
        for breed in breeds {
            guard let breedName = breed.name, let images = storageService.loadBreedImages(breedName: breedName) else { return }
            if !images.isEmpty {
                for image in images {
                    if image.favourite == true {
                        
                        if (favouriteDogs[breedName]?.first(where: { $0.name == image.name })) == nil {
                            favouriteDogs[breedName, default: []].append(image)
                        }
                    }
                }
            }
            guard let subbreeds = storageService.loadSubbreeds(by: breedName) else { return }
//            self.subbreeds = subbreeds
            for subbreed in subbreeds {
                guard let subbreedName = subbreed.name, let images = storageService.loadSubbreedImages(subbreedName: subbreedName) else { return }
                for image in images {
                    if image.favourite == true {
                        if (favouriteDogs[subbreedName]?.first(where: { $0.name == image.name })) == nil {
                            favouriteDogs[subbreedName, default: []].append(image)
                        }
                    }
                }
            }
        }
        
        for (name, images) in favouriteDogs {
            if !namesDog.contains(name) {
                namesDog.append(name)
            }
            
            if images.count == 0 {
                if let index = namesDog.firstIndex(of: name) {
                    namesDog.remove(at: index)
                }
            }
        }
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Delegate Methods
    
//    func addFavourite(dogsName: String, with image: Image) {
//        favouriteDogs[dogsName]?.append(image)
//
//        if !namesDog.contains(dogsName) {
//            namesDog.append(dogsName)
//        }
//        print("DOGS when ADD: \(namesDog)")
//
//    }
//
//    func removeFavourite(dogsName: String, with image: Image) {
//        if let index = favouriteDogs[dogsName]?.firstIndex(of: image) {
//            favouriteDogs[dogsName]?.remove(at: index)
//        }
//
//        if favouriteDogs[dogsName]?.count == 0 {
//            if let index = namesDog.firstIndex(of: dogsName) {
//                namesDog.remove(at: index)
//            }
//        }
//        print("DOGS when REMOVE: \(namesDog)")
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 
        return favouriteDogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteTableViewCell
        print("DOGS in CELL: \(namesDog)")
        cell.setupCell(for: namesDog[indexPath.row], with: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

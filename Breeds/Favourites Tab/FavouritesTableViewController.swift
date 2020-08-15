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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteDogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteTableViewCell
        cell.setupCell(for: namesDog[indexPath.row], with: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
        let dogsName = namesDog[indexPath.row]
        guard let images = favouriteDogs[dogsName] else { return }
        controller.showFavouritesImages(with: images)
        navigationController?.pushViewController(controller, animated: true)
    }

}

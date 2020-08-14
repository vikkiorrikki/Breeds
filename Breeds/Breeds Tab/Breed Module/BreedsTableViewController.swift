//
//  BreedsTableViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class BreedsTableViewController: UITableViewController {

    var breeds = [Breed]()
    let storageService = StorageService()
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        networkService.delegateBreeds = self
        
        guard let breeds = storageService.loadBreeds() else { return }
        
        if breeds.isEmpty {
            networkService.fetchBreeds()
        } else {
            update()
        }

        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Methods
    
    func update() {
        guard let breeds = storageService.loadBreeds() else { return }
        self.breeds = breeds
        reloadTable()
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath) as! BreedTableViewCell
        cell.setupCell(with: breeds[indexPath.row])
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if breeds[indexPath.row].subbreed?.count != 0 {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubBreedVC") as! SubBreedsTableViewController
            controller.breed = breeds[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
            controller.breed = breeds[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

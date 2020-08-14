//
//  SubBreedsTableViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class SubBreedsTableViewController: UITableViewController, SubbreedNetworkDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    //MARK: - Properties
    
    let storageService = StorageService()
    var breed: Breed?
    var subbreeds = [Subbreed]()
    let networkService = NetworkService()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.delegateSubbreeds = self

        navItem?.title = breed?.name?.capitalized
        guard let breedName = breed?.name, let subbreeds = storageService.loadSubbreeds(by: breedName) else { return }
        self.subbreeds = subbreeds
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Delegate Methods
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subbreeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubbBreedCell", for: indexPath)
        cell.textLabel?.text = subbreeds[indexPath.row].name?.capitalized
        return cell
    }

    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
        controller.subbreed = subbreeds[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

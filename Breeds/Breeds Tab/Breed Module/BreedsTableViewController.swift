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
        
        setupUI()
        loadBreeds()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
    
    private func loadBreeds() {
        let spinner = SpinnerViewController()
        
        if storageService.isBreeds() {
            showSpinnerView(spinner)
        }
        
        networkService.fetchBreeds() { result in
            switch result {
            case .success(let breeds):
                self.storageService.addBreeds(breeds)
                
                for breed in breeds {
                    self.loadSubbreeds(for: breed)
                }
                self.update()
                self.hideSpinnerView(spinner)
            case .failure(let error):
                self.showErrorAlert(error)
            }
        }
    }
    
    private func loadSubbreeds(for breed: String) {
        self.networkService.fetchSubbreeds(for: breed) { result in
            switch result {
            case .success(let subbreeds):
                self.storageService.addSubbreeds(subbreeds, for: breed)
            case .failure(let error):
                self.showErrorAlert(error)
            }
        }
    }
    
    private func update() {
        guard let breeds = storageService.loadBreeds() else { return }
        self.breeds = breeds
        tableView.reloadData()
    }
    
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    //MARK: - Spinner Methods
    
    private func showSpinnerView(_ spinner: SpinnerViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func hideSpinnerView(_ spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
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

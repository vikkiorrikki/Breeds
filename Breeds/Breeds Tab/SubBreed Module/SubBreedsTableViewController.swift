//
//  SubBreedsTableViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class SubBreedsTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    //MARK: - Properties
    
    let networkService = NetworkService()
    let storageService = StorageService()
    var breed: Breed?
    var subbreeds = [Subbreed]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSubbreeds()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        navItem?.title = breed?.name?.capitalized
        tableView.tableFooterView = UIView()
    }
    
    private func loadSubbreeds() {
        let spinner = SpinnerViewController()
        guard let breedName = breed?.name else { return }
        
        if storageService.isSubbreeds(for: breedName) {
            showSpinnerView(spinner)
        }
        
        networkService.fetchSubbreeds(for: breedName) { (result) in
            switch result {
            case .failure(let error):
                self.showErrorAlert(with: error)
            case .success(let subbreeds):
                self.storageService.addSubbreeds(subbreeds, for: breedName)
                self.update()
                self.hideSpinnerView(spinner)
            }
        }
    }
    
    private func update() {
        guard let breedName = breed?.name, let subbreeds = storageService.loadSubbreeds(by: breedName) else { return }
        self.subbreeds = subbreeds
        tableView.reloadData()
    }
    
    private func showErrorAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
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

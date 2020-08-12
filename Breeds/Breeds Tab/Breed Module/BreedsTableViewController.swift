//
//  BreedsTableViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class BreedsTableViewController: UITableViewController {

    let breeds = [Breed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
        
        if breeds[indexPath.row].subbreed != nil {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubBreedVC") as! SubBreedsTableViewController
            controller.delegate = self
            controller.breed = breeds[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
            controller.breed = breeds[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

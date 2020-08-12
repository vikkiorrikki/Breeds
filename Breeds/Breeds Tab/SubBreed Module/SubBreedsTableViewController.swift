//
//  SubBreedsTableViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class SubBreedsTableViewController: UITableViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    weak var delegate: BreedsTableViewController?
    var breed: BreedTransferObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navItem?.title = breed!.name.capitalized
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let subbread = breed?.subBreed else { return 0 }
        return subbread.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubbBreedCell", for: indexPath)
        if let subbread = breed?.subBreed {
            cell.textLabel?.text = subbread[indexPath.row].name.capitalized
        }
        return cell
    }

    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
        guard let subbreed = breed?.subBreed else {
            return
        }
        controller.subbreed = subbreed[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

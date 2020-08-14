//
//  BreedTableViewCell.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class BreedTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!

    func setupCell(with model: Breed) {
        name.text = model.name?.capitalized
        let subbreedCount = model.subbreed?.count
        
        if subbreedCount == 0 {
            count.isHidden = true
        } else {
            count.isHidden = false
            count.text = "(\(String(describing: subbreedCount!)) subbreeds)"
        }
    }
}

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

    func setupCell(with model: BreedTransferObject) {
        name.text = model.name.capitalized
        
        if let subbreedCount = model.subBreed?.count {
            count.text = "(\(subbreedCount) subbreeds)"
        } else {
            count.isHidden = true
        }
    }
}

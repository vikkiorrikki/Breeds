//
//  FavouriteTableViewCell.swift
//  Breeds
//
//  Created by Виктория Саклакова on 15.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(for name: String, with count: Int) {
        textLabel?.text = name.capitalized + " (\(count) favourites)"
    }

}

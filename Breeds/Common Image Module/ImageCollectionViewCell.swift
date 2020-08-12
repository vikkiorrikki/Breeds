//
//  ImageCollectionViewCell.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ImageViewController?
    var favourite = false
    var imageName = ""
    var vcTag: ViewControllerTag?
    
    func updateCell(favourite: Bool, imageName: String, tag: ViewControllerTag) {
        imageView.image = UIImage(named: imageName)
        self.favourite = favourite
        self.imageName = imageName
        if !favourite {
            favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        switch tag {
        case .breed:
            vcTag = tag
        case .subbreed:
            vcTag = tag
        }
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        if favourite {
            favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favourite = false
        } else {
            favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favourite = true
        }
        delegate?.userDidChangeFavourite(favourite: favourite, imageName: imageName, tag: vcTag!)
    }
    
}

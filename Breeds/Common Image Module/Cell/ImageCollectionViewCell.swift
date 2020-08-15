//
//  ImageCollectionViewCell.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ImageCellDelegate?
    var favourite = false
    var image: Image?
    
    func updateCell(image: Image) {
        
        self.image = image
        
        guard let imageName = image.name else { return }
        imageView.sd_setImage(with: URL(string: imageName))
        
        self.favourite = image.favourite
        if !favourite {
            favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    @IBAction func favouriteButtonTouched(_ sender: Any) {
        if favourite {
            favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favourite = false
        } else {
            favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favourite = true
        }
        
        guard let image = image else { return }
        delegate?.userDidChangeFavourite(for: image, with: favourite)
        print("favourites")
    }
    

    @IBAction func shareButtonTouched(_ sender: UIButton) {
        guard let imageName = image?.name, let image = UIImage(named: imageName) else { return }
        delegate?.showSharedMenu(for: image)
        print("SHARED")
    }
    
}

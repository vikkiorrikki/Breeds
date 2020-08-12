//
//  ImageViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var breed: BreedTransferObject?
    var subbreed: SubBreedTransferObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        if let breed = breed {
            navItem.title = breed.name.capitalized
        } else {
            navItem.title = subbreed!.name.capitalized
        }
    }
    
    func userDidChangeFavourite(favourite: Bool, imageName: String, tag: ViewControllerTag) {
        switch tag {
        case .breed:
            breed?.images![0].favourite = favourite
        case .subbreed:
            subbreed?.images![0].favourite = favourite
        }
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSourc

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let breed = breed, let images = breed.images {
            return images.count
        } else if let subbreed = subbreed, let images = subbreed.images {
            return images.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.delegate = self
        
        if let breed = breed, let images = breed.images {
            cell.updateCell(favourite: images[indexPath.item].favourite, imageName: images[indexPath.item].name, tag: .breed)
        } else if let subbreed = subbreed, let images = subbreed.images {
            cell.updateCell(favourite: images[indexPath.item].favourite, imageName: images[indexPath.item].name, tag: .subbreed)
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

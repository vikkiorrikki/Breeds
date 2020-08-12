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
    
    let storageService = StorageService()
    var breed: Breed?
    var subbreed: Subbreed?
    var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        if let breed = breed {
            navItem.title = breed.name?.capitalized
            guard let breedId = breed.id, let images = storageService.loadImages(by: breedId) else { return }
            self.images = images
        } else {
            navItem.title = subbreed?.name?.capitalized
            guard let subbreedId = subbreed?.id, let images = storageService.loadImages(by: subbreedId) else { return }
            self.images = images
        }
    }
    
    @IBAction func sharedButtonTouched(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: nil, message: "Share Photo", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { [unowned self] (UIAlertAction) in
            let sharedController = UIActivityViewController(activityItems: [self.images], applicationActivities: nil)
            sharedController.completionWithItemsHandler = {_, bool, _, _ in
                if bool {
                    print("Success!")
                }
            }
            self.present(sharedController, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func userDidChangeFavourite(for image: Image, with favourite: Bool) {
        guard let imageId = image.id else { return }
        storageService.updateImage(for: imageId, with: favourite)
        imageCollectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSourc

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.delegate = self
        
        cell.updateCell(image: images[indexPath.item])
        
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

//
//  ImageViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, ImageNetworkDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //MARK: - Properties
    
    let storageService = StorageService()
    let networkService = NetworkService()
    
    var breed: Breed?
    var subbreed: Subbreed?
    var images = [Image]()
    let spinner = SpinnerViewController()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        networkService.delegateImages = self
        
        setupCollectionView()
    }
    
    //MARK: - Methods
    
    func setupCollectionView() {
        if let breed = breed {
            navItem.title = breed.name?.capitalized
            guard let breedName = breed.name, let images = storageService.loadBreedImages(breedName: breedName) else { return }
            self.images = images
            
            if images.isEmpty {
                showSpinnerView(spinner)
                networkService.fetchImages(by: breedName)
                guard let images = storageService.loadBreedImages(breedName: breedName) else { return }
                self.images = images
            } else {
                updateCollectionView(breedName: breedName)
            }
        } else {
            navItem.title = subbreed?.name?.capitalized
            guard let subbreedName = subbreed?.name, let breedName = subbreed?.breed?.name, let images = storageService.loadSubbreedImages(subbreedName: subbreedName) else { return }
            self.images = images
            
            if images.isEmpty {
                showSpinnerView(spinner)
                networkService.fetchImages(by: breedName, by: subbreedName)
                guard let images = storageService.loadSubbreedImages(subbreedName: subbreedName) else { return }
                self.images = images
                
            } else {
                updateCollectionView(subbreedName: subbreedName)
                
            }
        }
    }
    
    //MARK: - Delegate Methods
    
    func updateCollectionView(breedName: String) {
        guard let images = storageService.loadBreedImages(breedName: breedName) else { return }
        self.images = images
        imageCollectionView.reloadData()
        hideSpinnerView(spinner)
    }
    
    func updateCollectionView(subbreedName: String) {
        guard let images = storageService.loadSubbreedImages(subbreedName: subbreedName) else { return }
        self.images = images
        imageCollectionView.reloadData()
        hideSpinnerView(spinner)
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    //MARK: - Spinner Methods
    
    func showSpinnerView(_ spinner: SpinnerViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func hideSpinnerView(_ spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    //MARK: - IBActions
    
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
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSourc

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
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

//MARK: - ImageDelegate

extension ImageViewController: ImageCellDelegate {
    func userDidChangeFavourite(for image: Image, with favourite: Bool) {
        guard let imageId = image.id else { return }
        storageService.updateImage(for: imageId, with: favourite)
        imageCollectionView.reloadData()
    }
}

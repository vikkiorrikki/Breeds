//
//  ImageViewController.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {    
    
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
        
        setupCollectionView()
    }
    
    //MARK: - Setup UI
    
    private func setupCollectionView() {
        if let breed = breed {
            setupUIBreeds(breed)
        } else if let subbreed = subbreed {
            setupUISubbreeds(subbreed)
        } else if !images.isEmpty {
            imageCollectionView.reloadData()
        }
    }
    
    func showFavouritesImages(with images: [Image]) {
        self.images = images
    }
    
    private func setupUIBreeds(_ breed: Breed) {
        guard let breedName = breed.name else { return }
        navItem.title = breedName.capitalized
        
        if storageService.isImagesBreeds(breedName) {
            showSpinnerView(spinner)
        }
        
        networkService.fetchImages(by: breedName) { result in
            switch result {
            case .failure(let error):
                self.showErrorAlert(with: error)
            case .success(let images):
                self.storageService.addBreedImages(images, for: breedName)
                self.updateCollectionView(breedName: breedName)
            }
        }
    }

    private func setupUISubbreeds(_ subbreed: Subbreed) {
        guard let subbreedName = subbreed.name, let breedName = subbreed.breed?.name else { return }
        navItem.title = subbreed.name?.capitalized
        
        if storageService.isImagesSubbreeds(subbreedName) {
            showSpinnerView(spinner)
        }
        
        networkService.fetchImages(subbreedName, for: breedName) { result in
            switch result {
            case .failure(let error):
                self.showErrorAlert(with: error)
            case.success(let images):
                self.storageService.addSubbreedImages(images, for: subbreedName)
                self.updateCollectionView(subbreedName: subbreedName)
            }
        }
    }
    
    //MARK: - Delegate Methods
    
    private func updateCollectionView(breedName: String) {
        guard let images = storageService.loadBreedImages(breedName: breedName) else { return }
        self.images = images
        imageCollectionView.reloadData()
        hideSpinnerView(spinner)
    }
    
    private func updateCollectionView(subbreedName: String) {
        guard let images = storageService.loadSubbreedImages(subbreedName: subbreedName) else { return }
        self.images = images
        imageCollectionView.reloadData()
        hideSpinnerView(spinner)
    }
    
    private func showErrorAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    //MARK: - Spinner Methods
    
    private func showSpinnerView(_ spinner: SpinnerViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func hideSpinnerView(_ spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
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
    
    func showSharedMenu(for image: UIImage) {
        let optionMenu = UIAlertController(title: nil, message: "Share Photo", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { [unowned self] (UIAlertAction) in
            let sharedController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
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
        
        self.present(optionMenu, animated: true)
    }
}

//
//  ImageNetworkDelegate.swift
//  Breeds
//
//  Created by Виктория Саклакова on 14.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

protocol ImageNetworkDelegate: class {
    func updateCollectionView(breedName: String)
    func updateCollectionView(subbreedName: String)
}

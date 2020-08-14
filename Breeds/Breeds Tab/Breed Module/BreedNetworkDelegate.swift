//
//  BreedDelegate.swift
//  Breeds
//
//  Created by Виктория Саклакова on 14.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

protocol BreedNetworkDelegate: class {
    func update()
    func showErrorAlert(with message: String)
}

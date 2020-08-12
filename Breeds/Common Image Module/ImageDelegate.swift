//
//  ImageDelegate.swift
//  Breeds
//
//  Created by Виктория Саклакова on 13.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

protocol ImageDelegate: class {
    func userDidChangeFavourite(for image: Image, with favourite: Bool)
}

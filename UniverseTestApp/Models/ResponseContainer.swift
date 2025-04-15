//
//  ResponseContainer.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import Foundation

struct ResponseContainer<T: Decodable>: Decodable {
    let items: [T]
}

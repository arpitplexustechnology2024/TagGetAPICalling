//
//  Model.swift
//  TagGetAPICalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import Foundation


// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let query: String
    let tags: [String]
}

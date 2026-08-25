//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Merve Bulut on 25.08.2026.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

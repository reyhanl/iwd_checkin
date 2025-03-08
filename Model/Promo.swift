//
//  Promo.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

struct Promo: Codable{
    var id: Int?
    var name: String?
    var imagesURL: String?
    var detail: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
        case imagesURL = "images_url"
        case detail = "detail"
    }
}

//
//  RemoteConfigModel.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

struct RemoteConfigModel: Codable{
    var key: String?
    
    enum CodingKeys: String, CodingKey{
        case key = "key"
    }
}

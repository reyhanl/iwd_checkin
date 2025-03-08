//
//  Date.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

extension Date{
    func toString(dateFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

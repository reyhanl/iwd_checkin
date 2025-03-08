//
//  Transaction.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

struct Transaction: Codable{
    var bank: String
    var transactionID: String
    var merchant: String
    var transactionTotal: Double
    var date: String
}

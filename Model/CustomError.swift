//
//  CustomError.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

enum CustomError: Error{
    case unableToScanQRCode
    case somethingWentWrong
    case userNotFound
    case insufficientBalance
    case contextIsNotDefinedCoreDataStack
    case qrIsInvalid
    case sheetNotFound
    case callApiFailBecauseURLNotFound
    case apiReturnNoData
    case custom(String)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .custom(let errorMessage):
            return NSLocalizedString(errorMessage, comment: errorMessage)
        case .unableToScanQRCode:
            return NSLocalizedString("QR is not in the right format", comment: "The QR code scanned is not in the right format")
        case .insufficientBalance:
            return NSLocalizedString("You do not have enough balance to complete the transaction", comment: "You do not have enough balance to complete the transaction")
        case .qrIsInvalid:
            return NSLocalizedString("QR is invalid", comment: "please refresh the data or ask the attende for their detail")
        default:
            return NSLocalizedString("Something went wrong", comment: "Something unexpected occured")
        }
    }
}

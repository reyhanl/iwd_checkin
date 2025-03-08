//
//  ScanQRInteractor.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class ScanQRInteractor: ScanQRPresenterToInteractorProtocol{
    var presenter: ScanQRInteractorToPresenterProtocol?
    
    func userDidScanQR(qrString: String) {
       let pattern = "^[a-zA-Z0-9._%+-]+@+[a-zA-Z0-9.-]+\\.+[a-zA-Z]{2,}$"
        do{
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: qrString.utf16.count)
            let matches = regex.matches(in: qrString, range: range)
            if matches.isEmpty {
                throw CustomError.unableToScanQRCode
            }
            presenter?.result(result: .success(.decodeQR(qrString)))
        }catch{
            presenter?.result(result: .failure(CustomError.unableToScanQRCode))
            return
        }
    }
}

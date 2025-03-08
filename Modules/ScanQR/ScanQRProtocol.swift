//
//  ScanQRProtocol.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

protocol ScanQRViewToPresenterProtocol{
    var view: ScanQRPresenterToViewProtocol?{get set}
    
    func userDidScanQR(qrString: String)
}

protocol ScanQRPresenterToViewProtocol{
    var presenter: ScanQRViewToPresenterProtocol?{get set}
    
    func result(result: Result<ScanQRSuccessType, Error>)
}

protocol ScanQRPresenterToInteractorProtocol{
    var presenter: ScanQRInteractorToPresenterProtocol?{get set}
    
    func userDidScanQR(qrString: String)
}

protocol ScanQRInteractorToPresenterProtocol{
    var interactor: ScanQRPresenterToInteractorProtocol?{get set}
    
    func result(result: Result<ScanQRSuccessType, Error>)
}

protocol ScanQRPresenterToRouterProtocol{
}

enum ScanQRSuccessType{
    case decodeQR(String)
}

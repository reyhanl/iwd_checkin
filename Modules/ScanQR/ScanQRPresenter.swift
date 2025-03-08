//
//  ScanQRPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class ScanQRPresenter: ScanQRInteractorToPresenterProtocol{
    var interactor: ScanQRPresenterToInteractorProtocol?
    var view: ScanQRPresenterToViewProtocol?
    
    
    func result(result: Result<ScanQRSuccessType, Error>) {
        view?.result(result: result)
    }
}

extension ScanQRPresenter: ScanQRViewToPresenterProtocol{
    func userDidScanQR(qrString: String) {
        interactor?.userDidScanQR(qrString: qrString)
    }
}

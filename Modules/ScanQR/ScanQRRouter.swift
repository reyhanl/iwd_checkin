//
//  ScanQRRouter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class ScanQRRouter: ScanQRPresenterToRouterProtocol{
    static func makeComponent(qrCodeHandler: ScanQRDelegate) -> ScanQRViewController {
        var interactor: ScanQRPresenterToInteractorProtocol = ScanQRInteractor()
        var presenter: ScanQRViewToPresenterProtocol & ScanQRInteractorToPresenterProtocol = ScanQRPresenter()
        let view = ScanQRViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        view.delegate = qrCodeHandler
        
        return view
    }
}

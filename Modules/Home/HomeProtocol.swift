//
//  HomeProtocol.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation
import UIKit

protocol HomeViewToPresenterProtocol{
    var view: HomePresenterToViewProtocol?{get set}
    var router: HomePresenterToRouterProtocol?{get set}
    var sheetID: String{get set}
    var attendes: [Attende]{get set}
    
    func viewDidLoad()
    func userDidScanQR(text: String)
    func fetchListOfAttendes(from sheet: String)
    func refreshData()
    func goToQRVC(from: HomeViewController, usingInteraction: Bool)
    func attendeForRow(at: Int) -> Attende
    func numberOfRows() -> Int
    func checkIfAlreadyEnter(attende: Attende) -> Bool
}

protocol HomePresenterToViewProtocol{
    var presenter: HomeViewToPresenterProtocol?{get set}
    
    func presentAlertError(title: String, message: String)
    func updateAttendes(attendes: [Attende])
    func updateUserInfo(user: User)
    func endRefresh()
}

protocol HomePresenterToInteractorProtocol{
    var presenter: HomeInteractorToPresenterProtocol?{get set}
    
    func userDidScanQR(text: String, attendes: [Attende])
    func fetchListOfAttendes(from sheet: String)
}

protocol HomeInteractorToPresenterProtocol{
    var interactor: HomePresenterToInteractorProtocol?{get set}
    
    func result(result: Result<HomeSuccessType, Error>)
}

protocol HomePresenterToRouterProtocol{
    var presenter: HomeRouterToPresenterProtocol?{get set}
    func goToQRVC(from: HomeViewController, usingInteraction: Bool)
    func goToTransactionVC(from: HomeViewController, transaction: Transaction, user: User)
    func presentAlertVC(vc: UIViewController)
    func presentValidQRCodeAlert(vc: UIViewController, attende: Attende)
    func presentQRIsInvalid(vc: UIViewController)
    func presentBubbleAlert(vc: UIViewController, text: String)
    func presentValidQRCodeButReenterAlert(vc: UIViewController, attende: Attende)
}

protocol HomeRouterToPresenterProtocol{
    func userDidEnterSheetID(sheetID: String)
}

enum HomeSuccessType{
    case fetchAttendesSuccess([Attende])
    case qrIsValid(Attende)
    case qrIsValidButReenter(Attende)
}

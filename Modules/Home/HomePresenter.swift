//
//  ViewControllerPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class HomePresenter: HomeInteractorToPresenterProtocol{
    var interactor: HomePresenterToInteractorProtocol?
    var view: HomePresenterToViewProtocol?
    var router: HomePresenterToRouterProtocol?
    var attendes: [Attende] = []
    var sheetID: String = ""
    
    func result(result: Result<HomeSuccessType, Error>) {
        DispatchQueue.main.async {
            switch result{
            case .success(let type):
                self.handleSuccess(type: type)
            case .failure(let error):
                switch error{
                case CustomError.sheetNotFound:
                    guard let vc = self.view as? HomeViewController else{return}
                    self.router?.presentBubbleAlert(vc: vc, text: "Sheet not found")
                case CustomError.insufficientBalance:
                    self.view?.presentAlertError(title: "Insufficient balance", message: error.localizedDescription)
                case CustomError.qrIsInvalid:
                    guard let vc = self.view as? HomeViewController else{return}
                    self.router?.presentQRIsInvalid(vc: vc)
                default:
                    print("error: \(String(describing: error))")
                }
            }
        }
    }
    
    func handleSuccess(type: HomeSuccessType){
        switch type{
        case .fetchAttendesSuccess(let attendes):
            self.attendes = attendes
            view?.endRefresh()
            view?.updateAttendes(attendes: attendes)
        case .qrIsValid(let attende):
            guard let vc = view as? HomeViewController else{return}
            if let index = attendes.firstIndex(where: {$0.email == attende.email}){
                var copy = attende
                copy.haveEntered = true
                attendes[index] = copy
            }
            view?.updateAttendes(attendes: attendes)
            router?.presentValidQRCodeAlert(vc: vc, attende: attende)
        case .qrIsValidButReenter(let attende):
            guard let vc = view as? HomeViewController else{return}
            if let index = attendes.firstIndex(where: {$0.email == attende.email}){
                var copy = attende
                copy.haveEntered = true
                attendes[index] = copy
            }
            view?.updateAttendes(attendes: attendes)
            router?.presentValidQRCodeButReenterAlert(vc: vc, attende: attende)
        }
    }
}

extension HomePresenter: HomeViewToPresenterProtocol{
    
    func fetchLogs() -> [Log]{
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)

        do{
            let logs: [Log] = try helper.fetchItemsToGeneric(entity: .log, with: nil)
            return logs
        }catch{
            return []
        }
    }
    
    func checkIfAlreadyEnter(attende: Attende) -> Bool {
        let logs = fetchLogs()
        return logs.contains(where: {$0.email == attende.email})
    }
    
    func goToQRVC(from: HomeViewController, usingInteraction: Bool) {
        router?.goToQRVC(from: from, usingInteraction: usingInteraction)
    }
    
    func viewDidLoad() {
        view?.endRefresh()
        view?.updateAttendes(attendes: attendes)
    }
    
    func numberOfRows() -> Int {
        return attendes.count
    }
    
    func userDidScanQR(text: String) {
        interactor?.userDidScanQR(text: text, attendes: attendes)
    }
    
    func fetchListOfAttendes(from sheet: String){
        sheetID = sheet
    }
    
    func refreshData() {
        interactor?.fetchListOfAttendes(from: sheetID)
    }
    
    func attendeForRow(at: Int) -> Attende {
        return attendes[at]
    }
}

extension HomePresenter: HomeRouterToPresenterProtocol{
    func userDidEnterSheetID(sheetID: String) {
        self.sheetID = sheetID
        interactor?.fetchListOfAttendes(from: sheetID)
    }
}

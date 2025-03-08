//
//  HomeRouter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation
import UIKit

class HomeRouter: HomePresenterToRouterProtocol{
    var presenter: HomeRouterToPresenterProtocol?
    
    static func makeComponent(data: [Attende], sheetID: String) -> HomeViewController {
        var interactor: HomePresenterToInteractorProtocol = HomeInteractor()
        var presenter: HomeViewToPresenterProtocol & HomeInteractorToPresenterProtocol & HomeRouterToPresenterProtocol = HomePresenter()
        let view = HomeViewController()
        var router: HomePresenterToRouterProtocol = HomeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        presenter.attendes = data
        presenter.sheetID = sheetID
        
        return view
    }
    
    func goToQRVC(from: HomeViewController, usingInteraction: Bool) {
        let vc = ScanQRRouter.makeComponent(qrCodeHandler: from)
        if usingInteraction{
            from.interactionController = UIPercentDrivenInteractiveTransition()
        }else{
            from.interactionController = nil
        }
        vc.customTransitionDelegate.interactionController = from.interactionController
        vc.transitioningDelegate = vc.customTransitionDelegate
        vc.customTransitionDelegate.presentationTransitionType = .swipeRight
        vc.delegate = from
        vc.customTransitionDelegate.dismissalTransitionType = .swipeLeft
        vc.modalPresentationStyle = .custom
        from.present(vc, animated: true)
    }
    
    func goToTransactionVC(from: HomeViewController, transaction: Transaction, user: User) {
        let vc = TransactionModalVC()
        vc.customTransitionDelegate.presentationTransitionType = .swipeUp
        vc.customTransitionDelegate.dismissalTransitionType = .swipeDown
        vc.transitioningDelegate = vc.customTransitionDelegate
        vc.modalPresentationStyle = .custom
        from.transitioningDelegate = vc.customTransitionDelegate
        vc.setupUI(transaction: transaction, user: user)
        vc.delegate = from
        vc.interactionController = nil
        from.present(vc, animated: true)
    }
    
    func presentAlertVC(vc: UIViewController) {
        let alert = UIAlertController(title: "Input sheetID", message: "input the sheetID", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.presenter?.userDidEnterSheetID(sheetID: textField?.text ?? "")
        }))

        // 4. Present the alert.
        vc.present(alert, animated: true, completion: nil)
    }
    
    func presentValidQRCodeAlert(vc: UIViewController, attende: Attende){
        vc.presentBubbleAlert(text: "Welcome \(attende.name)", with: 0.5, floating: 1)
    }
    
    func presentValidQRCodeButReenterAlert(vc: UIViewController, attende: Attende){
        vc.presentBubbleAlert(text: "\(attende.name) re-enter", with: 0.5, floating: 1)
    }
    
    func presentQRIsInvalid(vc: UIViewController) {
        let alert = UIAlertController(title: "Attendes email can't be found", message: "Please make sure the attendes are resgistered", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func presentBubbleAlert(vc: UIViewController, text: String){
        vc.presentBubbleAlert(text: "Welcome \(text)", with: 0.5, floating: 1)
    }
}

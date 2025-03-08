//
//  TransactionModalVC.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class TransactionModalVC: BaseViewController, CustomTransitionEnabledVC{
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var transactionIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var merchantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var bankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Purchase", for: .normal)
        button.setTitle("Balance is insufficient", for: .disabled)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.primaryForegroundColor, for: .normal)
        button.setBackgroundImage(.init(color: .primaryButton), for: .normal)
        button.setBackgroundImage(.init(color: .primaryButtonPressed), for: .selected)
        button.setBackgroundImage(.init(color: .primaryButtonPressed), for: .highlighted)
        button.setBackgroundImage(.init(color: .buttonDisabledColor), for: .disabled)
        button.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.accessibilityIdentifier = "purchaseButton"
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var transaction: Transaction?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var customTransitionDelegate = TransitioningManager()
    var delegate: TransactionModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        addContainerView()
        addStackView()
        addTransactionIDLabel()
        addMerchantLabel()
        addBankLabel()
        addMCostLabel()
        addCancelButton()
        addPurchaseButton()
    }
    
    func addBackgroundView(){
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func addContainerView(){
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.9, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        ])
    }
    
    func addStackView(){
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        ])
    }
    
    func addTransactionIDLabel(){
        containerView.addSubview(transactionIDLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: transactionIDLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: transactionIDLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: transactionIDLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: transactionIDLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 10)
        ])
    }
    
    func addMerchantLabel(){
        containerView.addSubview(merchantLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: merchantLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: merchantLabel, attribute: .top, relatedBy: .equal, toItem: transactionIDLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: merchantLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: merchantLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 10)
        ])

    }
    
    func addBankLabel(){
        containerView.addSubview(bankLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: bankLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: bankLabel, attribute: .top, relatedBy: .equal, toItem: merchantLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: bankLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: bankLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 10)
        ])
    }
    
    func addMCostLabel(){
        containerView.addSubview(costLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: costLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: costLabel, attribute: .top, relatedBy: .equal, toItem: bankLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: costLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: costLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: costLabel, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1, constant: -10)
        ])
    }
    
    func setupUI(transaction: Transaction, user: User){
        self.transaction = transaction
        purchaseButton.isEnabled = user.balance >= transaction.transactionTotal
        merchantLabel.text = transaction.merchant
        bankLabel.text = transaction.bank
        costLabel.text = transaction.transactionTotal.getCurrency()
        transactionIDLabel.text = transaction.transactionID
    }
    
    func addPurchaseButton(){
        stackView.addArrangedSubview(purchaseButton)
    }
    
    func addCancelButton(){
        stackView.addArrangedSubview(cancelButton)
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer){
        let translationY = gestureRecognizer.translation(in: view).y
        let percentageInDecimal = translationY / containerView.frame.height
        
        switch gestureRecognizer.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            customTransitionDelegate.dismissalTransitionType = .swipeDown
            self.transitioningDelegate = customTransitionDelegate
            dismiss(animated: true)
        case .changed:
            print(percentageInDecimal)
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
        default:
            break
        }
    }
    
    @objc func purchase(){
        guard let transaction = transaction else{return}
        delegate?.purchase(transaction: transaction)
    }
    
    @objc func dismissModal(){
        interactionController = nil
        self.dismiss(animated: true)
    }
}

protocol TransactionModalDelegate{
    func purchase(transaction: Transaction)
}

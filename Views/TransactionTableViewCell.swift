//
//  TransactionTableViewCell.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell{
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        return stackView
    }()
    lazy var transactionIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    lazy var merchantLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAmountLabel()
        addStackView()
        addTransactionIDLabel()
        addMerchantLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addStackView(){
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: amountLabel, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        ])

    }
    
    func addMerchantLabel(){
        stackView.addArrangedSubview(merchantLabel)
    }
    
    func addAmountLabel(){
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: amountLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: amountLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
    }
    
    func addTransactionIDLabel(){
        stackView.addArrangedSubview(transactionIDLabel)
    }
    
    func setupCell(attende: Attende, haveEntered: Bool){
        merchantLabel.text = attende.name
        transactionIDLabel.text = attende.email
        self.backgroundColor = haveEntered ? .init(hex: "04490A"):.clear
    }
}

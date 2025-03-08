//
//  SettingTableViewCell.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 05/06/24.
//


import UIKit

class SettingTableViewCell: UITableViewCell{
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        ])

    }
    
    func addMerchantLabel(){
        stackView.addArrangedSubview(merchantLabel)
    }
    
    func addTransactionIDLabel(){
        stackView.addArrangedSubview(transactionIDLabel)
    }
    
    func setupCell(setting: Setting){
        merchantLabel.text = setting.rawValue
        transactionIDLabel.text = setting.icon
        backgroundColor = .systemBackground
    }
}

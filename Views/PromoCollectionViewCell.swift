//
//  PromoCollectionViewCell.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class PromoCollectionViewCell: UICollectionViewCell{
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var containerView: GradientView = {
        let view = GradientView()
        view.startColor = .clear
        view.endColor = .black.withAlphaComponent(0.9)
        view.startLocation = 0
        view.endLocation = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .secondaryBackgroundColor
        addImageView()
        addContainerView()
        addNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageView(){
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func addContainerView(){
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        ])
    }
    
    func addNameLabel(){
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 10)
        ])
    }
}

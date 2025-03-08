//
//  BackgroundCollectionViewCell.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 05/06/24.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell{
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
    func setupCell(background: BackgroundName, isSelected: Bool){
        imageView.image = UIImage(named: background.homeBackgroundName)
        self.layer.borderColor = isSelected ? UIColor.white.withAlphaComponent(0.4).cgColor:UIColor.darkGray.withAlphaComponent(0.4).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemBackground
    }
}

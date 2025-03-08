//
//  SplashVC.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 27/03/24.
//

import UIKit

class SplashVC: BaseViewController{
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(named: "SKEN")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var statusLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageView()
        addLabel()
    }
    
    func addImageView(){
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.4, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.4, constant: 0)
        ])
    }
    
    func addLabel(){
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: statusLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: statusLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 10)
        ])
    }
}

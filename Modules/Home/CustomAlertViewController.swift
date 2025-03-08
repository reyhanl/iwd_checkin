//
//  CustomAlertViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 05/06/24.
//

import UIKit

class CustomAlertViewController: UIViewController{
    
    
    var backgroundView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = .black.withAlphaComponent(0)
        view.endColor = .black
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "1d1d1d")
        view.layer.cornerRadius = 10
//        view.clipsToBounds = true
        return view
    }()
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return stackView
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        addBackgroundView()
        addContainerView()
        addContainerStackView()
        addImageView()
        addTitleLabel()
        addStackView()
    }
    
    convenience init(image: UIImage? = nil, title: String) {
        self.init()
        imageView.isHidden = image == nil
        imageView.image = image
        titleLabel.text = title
    }
    
    @objc func dismissAlert(){
        self.dismiss(animated: true)
    }
    
    func addBackgroundView(){
        view.insertSubview(backgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addContainerView(){
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        ])
    }
    
    func addContainerStackView(){
        containerView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerStackView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerStackView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerStackView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerStackView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: -30),
        ])
    }
    
    func addImageView(){
        containerStackView.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 100),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0),
        ])
    }
    
    func addTitleLabel(){
        containerStackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        ])
    }
    
    func addStackView(){
        containerStackView.addArrangedSubview(stackView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: containerStackView, attribute: .width, multiplier: 1, constant: 0)
        ])
        
        stackView.setCustomSpacing(0, after: stackView)
    }
    
    func addAction(action: ActionButton){
        stackView.addArrangedSubview(action)
        
        action.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: action, attribute: .height, relatedBy: .equal, toItem: stackView, attribute: .height, multiplier: 1, constant: 0)
        ])
    }
}

class ActionButton: UIButton{
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var closure: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, action: (() -> Void)?, color: UIColor = .blue, textColor: UIColor = .primaryForegroundColor){
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = color
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: self.titleLabel?.font.pointSize ?? 12)
        self.closure = action
        self.addTarget(self, action: #selector(act), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func act(){
        closure?()
    }
}

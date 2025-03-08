//
//  UIViewController+Extension.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 29/05/24.
//

import UIKit

extension UIViewController{
    func presentBubbleAlert(text: String, with duration: Double, floating interval: Double){
        enum AnimationType{
            case animateIn
            case animateOut
        }
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let multiplication = 0.8
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        let xPosition = ((1.0 - multiplication) / 2.0) * screenWidth
        let yPosition = screenHeight - 40
        let width = screenWidth * multiplication
        let height = 40.0
        view.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        
        view.backgroundColor = .secondaryBackgroundColor
        self.view.addSubview(view)
        
        let topConstraint =             NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)

        
        NSLayoutConstraint.activate([
            topConstraint,
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
        
        view.layer.cornerRadius = 15
        
        addLabel()
        
        animate(animationType: .animateIn) {
            Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { timer in
                animate(animationType: .animateOut) {
                    view.removeFromSuperview()
                }
                timer.invalidate()
            }
        }
        
        func animate(animationType: AnimationType, completion: @escaping() -> ()){
            switch animationType {
            case .animateIn:
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: duration) {
                    view.frame.origin.y -= view.frame.height + 20
                } completion: { bool in
                    completion()
                }

            case .animateOut:
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: duration) {
                    view.frame.origin.y += view.frame.height + 20
                } completion: { bool in
                    completion()
                }

            }
        }
        
        func addLabel(){
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20),
                NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            ])
            
            label.text = text
            label.textAlignment = .center
            label.textColor = .primaryForegroundColor
            label.numberOfLines = 0
        }
    }
}

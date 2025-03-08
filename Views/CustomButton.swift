//
//  CustomButton.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 04/06/24.
//

import UIKit

class CustomButton: UIButton{
    
    var pressedBackgroundColor: UIColor?
    var normalBackgroundColor: UIColor?
    var disabledColor: UIColor = .buttonDisabledColor
    override var isEnabled: Bool{
        didSet{
            backgroundColor = isEnabled ? normalBackgroundColor:disabledColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor? = UIColor.primaryButton, pressedColor: UIColor? = nil) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
        self.normalBackgroundColor = backgroundColor
        pressedBackgroundColor = pressedColor
    }
    
    func addGestureRecognizer(){
        
        self.addTarget(self, action: #selector(hover), for: .touchDown)
        self.addTarget(self, action: #selector(cancelHover), for: .touchCancel)
        self.addTarget(self, action: #selector(cancelHover), for: .touchDragExit)
        self.addTarget(self, action: #selector(cancelHover), for: .touchUpOutside)
    }
    
    @objc func hover(){
        guard let pressedBackgroundColor = pressedBackgroundColor else{return}
        backgroundColor = pressedBackgroundColor
    }
    
    @objc func cancelHover(){
        guard let normalBackgroundColor = normalBackgroundColor else{return}
        backgroundColor = normalBackgroundColor
    }
}


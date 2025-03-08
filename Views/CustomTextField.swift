//
//  CustomTextField.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 04/06/24.
//

import UIKit
import RegexBuilder

class CustomTextField: UIView{
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleIsSecureTextEntry))
        imageView.addGestureRecognizer(gestureRecognizer)
        return imageView
    }()
    
    var isSecureTextEntry: Bool = false{
        didSet{
            textField.isSecureTextEntry = isSecureTextEntry
            imageView.image = isSecureTextEntry ? UIImage(systemName: "eye"):UIImage(systemName: "eye.fill")
        }
    }
    var shouldShowSecureTextEntryToggle: Bool = false{
        didSet{
            imageView.isHidden = !shouldShowSecureTextEntryToggle
            if shouldShowSecureTextEntryToggle{
                isSecureTextEntry = true
            }
            textField.textContentType = .oneTimeCode
        }
    }
    var delegate: UITextFieldDelegate?{
        get{
            textField.delegate
        }
        set{
            textField.delegate = newValue
        }
    }
    var text: String?{
        get{
            return textField.text
        }
        set{
            textField.text = newValue
        }
    }
    
    var placeholder: String{
        get{
            return textField.placeholder ?? ""
        }
        set{
            textField.placeholder = newValue
        }
    }
    var status: textFieldStatus = .inactive{
        didSet{
            if oldValue != status && shouldValidate{
                setupStatus()
            }
        }
    }
    private var firstTime: Bool = true
    var shouldValidate: Bool = false
    var validation: [Requirement] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addStackView()
        addTextField()
        addIsSecureTextEntryButton()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addStackView()
        addTextField()
        addIsSecureTextEntryButton()
        addGestureRecognizer()
    }
    
    private func addStackView(){
        addSubview(stackView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    private func addTextField(){
        stackView.addArrangedSubview(textField)
        
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: textField, attribute: .left, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10),
//            NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
//            NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
//        ])
    }
    
    
    private func addIsSecureTextEntryButton(){
        stackView.addArrangedSubview(imageView)
        
//        let height = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0)
//        height.priority = .defaultLow
//        let width = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 0)
//        width.priority = .defaultLow
//
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .lessThanOrEqual, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40),
//            height,
//            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40),
//            width
//        ])
    }
    
    @objc private func toggleIsSecureTextEntry(){
        isSecureTextEntry.toggle()
    }
    
    @objc func textDidChange(_ sender: UITextField){
        checkTextFieldStatus()
    }
    
    @objc func textFieldDidEndEditing(){
        firstTime = false
        checkTextFieldStatus()
    }
    
    func checkTextFieldStatus(){
        guard let text = textField.text else{
            status = .inactive
            firstTime = true
            return
        }
        
        var invalid = false
        if shouldValidate{
            var pattern = ""
        requirementLoop: for requirement in validation {
            switch requirement{
            case .shouldContainsWord:
                let regex = Regex{
                    OneOrMore(.word)
                }
                let status = text.firstMatch(of: regex)!
                print(status.output)
            case .minimumNumberOfLetter(let count):
                pattern = "^[a-zA-Z0-9]{\(count),}$"
            case .isAValidEmailAddress:
                pattern = "^[a-zA-Z0-9._%+-]+@+[a-zA-Z0-9.-]+\\.+[a-zA-Z]{2,}$"
            case .shouldContainUppercase:
                pattern = ".*[A-Z].*"
            case .custom(let temp):
                pattern = temp
            }
            do{
                let regex = try NSRegularExpression(pattern: pattern)
                let range = NSRange(location: 0, length: text.utf16.count)
                let matches = regex.matches(in: text, range: range)
                if matches.isEmpty {
                    invalid = true
                    break requirementLoop
                }
            }catch{
                
            }
            
        }
        }else{
            status = textField.isFirstResponder ? .active:.inactive
            return
        }
        
        
        if firstTime && invalid{
            status = .active
            return
        }else if firstTime && !invalid {
            status = .valid
            firstTime = false
            return
        }
        
        status = invalid ? .invalid:.valid
    }
    
    func setupStatus(){
        switch status{
        case .active:
            self.layer.borderColor = UIColor.primaryForegroundColor.cgColor
            self.layer.borderWidth = 2
        case .inactive:
            self.layer.borderColor = UIColor.primaryForegroundColor.cgColor
            self.layer.borderWidth = 0
        case .valid:
            self.layer.borderColor = UIColor.validColor.cgColor
            self.layer.borderWidth = 2
        case .invalid:
            self.layer.borderColor = UIColor.invalidColor.cgColor
            self.layer.borderWidth = 2
        }
    }
    
    func addTarget(target: Any?, selector: Selector, for event: UIControl.Event){
        textField.addTarget(target, action: selector, for: event)
    }
    
    func addGestureRecognizer() {
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userDidTapTextField))
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func userDidTapTextField(){
        textField.becomeFirstResponder()
    }
}


enum Requirement{
    case shouldContainsWord
    case minimumNumberOfLetter(Int)
    case isAValidEmailAddress
    case shouldContainUppercase
    case custom(String)
    
    var regexString: String{
        switch self{
        case .shouldContainsWord:
            return "^.*[a-zA-Z0-9]+.*$"
        case .minimumNumberOfLetter(let count):
            return "^[a-zA-Z0-9]{\(count),}$"
        case .isAValidEmailAddress:
            return "^[a-zA-Z0-9._%+-]+@+[a-zA-Z0-9.-]+\\.+[a-zA-Z]{2,}$"
        case .shouldContainUppercase:
            return ".*[A-Z].*"
        case .custom(let regex):
            return regex
        }
    }
}

enum textFieldStatus{
    case active
    case inactive
    case valid
    case invalid
}

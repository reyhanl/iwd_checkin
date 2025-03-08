//
//  BaseViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 27/03/24.
//

import UIKit

class BaseViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = String(describing: type(of: self))
        overrideUserInterfaceStyle = .dark
    }
}
